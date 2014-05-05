fs = require "fs"
handlebars = require "handlebars"
utils = require "../utils"

blankTemplate = handlebars.compile ""

module.exports =
  # async
  fromPath: (path, callback) ->
    try
      template = fs.readFileSync path, encoding: "utf-8"
      t = handlebars.compile(template)
    catch e
      console.error("get and compile template from path #{path} error", e)
      callback(e)
      return
    callback(null, t)
  # sync
  fromText: (text) ->
    try
      return handlebars.compile(text)
    catch err
      console.error("compile template from text error", err)
      return ""
