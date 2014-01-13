fs = require "fs"
handlebars = require "handlebars"
utils = require "../utils"

pathCache = {}
textCache = {}
blankTemplate = handlebars.compile ""

module.exports =
  # async
  fromPath: (path, callback) ->
    if t = pathCache[path]
      callback(t)
      return
    fs.readFile path, (err, data) ->
      if err
        console.error("open file #{path} error", err)
        callback(err)
      else
        pathCache[path] = t = handlebars.compile(data.toString())
        callback(undefined, t)
  # sync
  fromText: (text) ->
    md5 = utils.md5(text)
    if t = textCache[md5]
      return t
    textCache[md5] = t = handlebars.compile(text)
    t
