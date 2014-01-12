fs = require "fs"
env = require "../enviroments"
templateLoader = require "./template_loader"
handlebars = require "handlebars"
async = require "./async"
utils = require "../utils"
# register all helper first
require "./helpers"

########################################################
# helpers to support layout render
blocks = {}

handlebars.registerHelper "partial", (name, options) ->
  unless block = blocks[name]
    block = blocks[name] = []
  block.push options.fn(@)
  undefined

handlebars.registerHelper "block", (name, options) ->
  block = blocks[name] or []
  if block.length is 0
    if options.fn then options.fn(@) else ""
  else
    content = block.join("\n")
    blocks[name] = []
    content
########################################################
# register all layout as partial
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
########################################################

getRealPath = (path) ->
  "#{env.viewsHome}/#{path}.hbs"

getComponentViewPath = (path) ->
  "#{env.componentsHome}/#{path}/view.hbs"

renderFromRealPath = (path, context, cb) ->
  if cb is undefined and typeof context is "function"
    cb = context
    context = {}
  utils.syncLike [
    (next) ->
      templateLoader.fromPath path, next
    (template, next) ->
      async.do template, context, next
    (result) ->
      cb(result)
  ]

module.exports =
  renderFile: (path, context, cb) ->
    renderFromRealPath getRealPath(path), context, cb

  renderComponent: (path, context, cb) ->
    renderFromRealPath getComponentViewPath(path), context, cb

  renderInline: (templateStr, context, cb) ->
    if cb is undefined and typeof context is "function"
      cb = context
      context = {}
    template = templateLoader.fromText(templateStr)
    async.do template, context, cb

# cause render helpers need the render module, so require (init) them after module exports
require "./render_helpers"
