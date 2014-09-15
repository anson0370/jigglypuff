fs = require "fs"
# require env to init all config
env = require "./enviroments"
# require render to init render enviroment
render = require "./handlebars/render"
express = require "express"
dataProvider = require "./data_provider"
{FileNotFoundError} = require "./errors"

app = express()

# render file to html when no dot in path
app.get /^([^\.]+)$/, (req, res) ->
  path = req.params[0]
  try
    result = render.renderFile path, req.query
    res.send result
  catch err
    if err instanceof FileNotFoundError
      dataResult = dataProvider.get(path, req.query)
      if dataResult.found
        res.send(dataResult.result)
      else
        console.log "[View Not Found] #{err.path}"
        res.status(404)
        res.send()
    else
      throw err

# send file direct when dot in path
app.get /^(.+)$/, (req, res) ->
  path = req.params[0]
  realPath = "#{env.filesHome}#{path}"
  if fs.existsSync realPath
    res.sendfile realPath
  else
    console.log "[Resource Not Found] #{realPath}"
    res.status(404)
    res.send()

app.listen env.serverPort
console.log "server listening at port: #{env.serverPort}"
