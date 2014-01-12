return unless require.main is module

render = require "../lib/handlebars/render"
async = require "../lib/handlebars/async"
http = require "http"
childProcess = require "child_process"

http.globalAgent.maxSockets = 150

loopCount = 1000
port = 8081

if process.argv[2] is "fake_server"
  server = http.createServer (req, res) ->
    setTimeout ->
      res.end("ok")
    , 20

  server.listen port
  server.on "listening", ->
    process.send {event: "listening"}
  process.on "message", (m) ->
    switch m.event
      when "stop"
        server.close ->
          process.exit()
else
  fakeServerProcess = childProcess.fork module.filename, ["fake_server"]
  async.registerAsyncHelper "httpCall", (path, resolve) ->
    http.get {host: "localhost", port: port, path: "/"}, (res) ->
      data = ''
      res.on 'data', (chunk) ->
        data += chunk.toString()
      res.on 'end', ->
        resolve data

  fakeServerProcess.on "message", (m) ->
    switch m.event
      when "listening"
        doneCount = 0
        startTime = Date.now()
        console.log "loop #{loopCount} times start."
        for i in [1..loopCount]
          render.renderInline "{{x}} - {{httpCall}} - {{y}}", {x: 1, y: 2}, (result) ->
            if ++doneCount is loopCount
              spendTime = Date.now() - startTime
              console.log "render result: #{result}"
              console.log "loop end, spended #{Date.now() - startTime}ms, tps: #{loopCount * 1000 / spendTime}"
              fakeServerProcess.send {event: "stop"}
