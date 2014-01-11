env = require "../enviroments"
fs = require "fs"
handlebars = require "handlebars"
utils = require "../utils"

pathCache = {}
textCache = {}
blankTemplate = handlebars.compile ""

getRealPath = (path) ->
  "#{env.views_home}/#{path}.hbs"

module.exports =
  # async
  fromPath: (path, callback) ->
    realPath = getRealPath(path)
    if t = pathCache[realPath]
      callback(t)
      return
    fs.readFile realPath, (err, data) ->
      if err
        console.error("open file #{realPath} error", err)
        callback(blankTemplate)
      else
        pathCache[realPath] = t = handlebars.compile(data.toString())
        callback(t)
  # sync
  fromText: (text) ->
    md5 = utils.md5(text)
    if t = textCache[md5]
      return t
    textCache[md5] = t = handlebars.compile(text)
    t
