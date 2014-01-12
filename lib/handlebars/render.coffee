fs = require "fs"
env = require "../enviroments"
templateLoader = require "./template_loader"
handlebars = require "handlebars"
async = require "./async"
utils = require "../utils"
# init register all helpers
require "./helpers"

# register all layout as partial first
layouts = []
findLayouts = (dir) ->
  files = fs.readdirSync(dir)
  files.forEach (file) ->
    filePath = "#{dir}/#{file}"
    stat = fs.statSync filePath
    if stat.isDirectory()
      findLayouts filePath
    else
      if file[0] is "_" and file.split(".")[1] is "hbs"
        layouts.push filePath
findLayouts env.viewsHome
layouts.forEach (file) ->
  t = fs.readFileSync file
  name = file[(env.viewsHome.length + 1)..].split(".")[0]
  handlebars.registerPartial name, handlebars.compile(t.toString())

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
        async.done template(context), next
      (result) ->
        cb(result)
    ]

  renderInline: (templateStr, context, cb) ->
    if cb is undefined and typeof context is "function"
      cb = context
      context = {}
    template = templateLoader.fromText(templateStr)
    async.done template(context), cb
