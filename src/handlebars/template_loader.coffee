fs = require "fs"
handlebars = require "handlebars"
utils = require "../utils"

blankTemplate = handlebars.compile ""

module.exports =
  fromPathSync: (path) ->
    template = fs.readFileSync path, encoding: "utf-8"
    handlebars.compile(template)

  fromText: (text) ->
    handlebars.compile(text)
