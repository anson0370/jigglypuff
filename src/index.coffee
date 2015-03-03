require "./polyfill"

_ = require "lodash"
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
app.get /^([^\.]+)$/, (req, res, next) ->
  path = req.params[0]
  # find data
  dataResult = dataProvider.getUrlData(path, req.query)
  # merge data and query params
  context = if _.isPlainObject(dataResult.result) then _.assign req.query, dataResult.result else req.query
  try
    result = render.renderFile path, context
    res.send result
  catch err
    if err instanceof FileNotFoundError
      # if view not found, next
      next()
    else
      throw err

# send file direct when dot in path
app.get /^(.+)$/, (req, res, next) ->
  path = req.params[0]
  if env.assetsPrefix isnt undefined and path.startsWith(env.assetsPrefix)
    path = path.substring env.assetsPrefix.length
  realPath = "#{env.filesHome}#{path}"
  if fs.existsSync realPath
    res.sendFile realPath
  else
    # if static resource not found, next
    next()

app.all /^(.+)$/, (req, res) ->
  path = req.params[0]
  dataResult = dataProvider.getUrlData(path, req.method, req.query)
  if dataResult.found
    res.send(dataResult.result)
  else
    console.log "[Not Found] #{path}"
    res.status(404)
    res.send()

app.listen env.serverPort
console.log "server listening at port: #{env.serverPort}"
