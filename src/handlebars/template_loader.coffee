fs = require "fs"
handlebars = require "handlebars"
utils = require "../utils"
{FileNotFoundError} = require "../errors"

blankTemplate = handlebars.compile ""

module.exports =
  fromPathSync: (path) ->
    throw new FileNotFoundError(path) unless fs.existsSync(path)
    template = fs.readFileSync path, encoding: "utf-8"
    handlebars.compile(template)

  fromText: (text) ->
    handlebars.compile(text)
