fs = require "fs"
env = require "../enviroments"
templateLoader = require "./template_loader"
handlebars = require "handlebars"
async = require "./async"
utils = require "../utils"
# init register all helpers
require "./helpers"

# register all layout as partial first
views = fs.readdirSync(env.viewsHome)
views.forEach (fileName) ->
  if fileName[0] is "_" and fileName.split(".")[1] is "hbs"
    templateBuffer = fs.readFileSync "#{env.viewsHome}/#{fileName}"
    handlebars.registerPartial fileName.split(".")[0], templateBuffer.toString()

getRealPath = (path) ->
  "#{env.viewsHome}/#{path}.hbs"

module.exports =
  renderFile: (path, context, cb) ->
    if cb is undefined and typeof context is "function"
      cb = context
      context = {}
    realPath = getRealPath path
    utils.syncLike [
      (next) ->
        templateLoader.fromPath realPath, next
      (template, next) ->
        async.do template(context), next
      (result) ->
        cb(result)
    ]
