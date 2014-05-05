fs = require "fs"
handlebars = require "handlebars"
env = require "../enviroments"
utils = require "../utils"

pathCache = {}
textCache = {}
blankTemplate = handlebars.compile ""

module.exports =
  # async
  fromPath: (path, callback) ->
    if env.cache and t = pathCache[path]
      callback(undefined, t)
      return
    fs.readFile path, (err, data) ->
      if err
        console.error("open file #{path} error", err)
        callback(err)
      else
        t = handlebars.compile(data.toString())
        pathCache[path] = t if env.cache
        callback(undefined, t)
  # sync
  fromText: (text) ->
    if env.cache
      md5 = utils.md5(text)
      if t = textCache[md5]
        return t
    t = handlebars.compile(text)
    textCache[md5] = t if env.cache
    t
