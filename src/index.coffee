# require env to init all config
env = require "./enviroments"
# require render to init render enviroment
render = require "./handlebars/render"
express = require "express"

app = express()

app.get /^([^\.]+)$/, (req, res) ->
  path = req.params[0]
  render.renderFile path, req.query, (err, result) ->
    if err
      res.send 500, {error: "render failed: \n#{err}"}
    else
      res.send result

app.get /^(.+)$/, (req, res) ->
  path = req.params[0]
  res.sendfile "#{env.filesHome}#{path}"

app.listen env.serverPort
console.log "server listening at port: #{env.serverPort}"
