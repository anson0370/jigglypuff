_ = require "lodash"
fs = require "fs"
env = require "../enviroments"
templateLoader = require "./template_loader"
handlebars = require "handlebars"
asyncRender = require "./async_render"
async = require "async"
# register all helpers first
require "./helpers"
# register all extra helpers
env.extraHelpers.forEach (helperPath) ->
  try
    require(helperPath)(handlebars)
  catch e
    console.error "error when load extra helper file: #{helperPath}", e

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

registerLayout = ->
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
        if /layout\.hbs$/.test file
          layouts.push filePath
  findLayouts env.viewsHome
  layouts.forEach (file) ->
    t = fs.readFileSync file
    name = file[(env.viewsHome.length + 1)..].split(".")[0]
    name = "views/#{name}" if env.oldMode
    handlebars.registerPartial name, handlebars.compile(t.toString())

getRealPath = (path) ->
  "#{env.viewsHome}/#{path}.hbs"

getComponentViewPath = (path) ->
  "#{env.componentsHome}/#{path}/view.hbs"

renderFromRealPath = (path, context, cb) ->
  async.waterfall [
    (next) ->
      templateLoader.fromPath path, next
    (template, next) ->
      asyncRender.do template, context, next
  ], cb


module.exports =
  renderFile: (path, context, cb) ->
    if cb is undefined and typeof context is "function"
      cb = context
      context = {}
    renderFromRealPath getRealPath(path), context, cb

  renderComponent: (path, context, cb) ->
    if cb is undefined and typeof context is "function"
      cb = context
      context = {}
    context[@CONST.COMP_PATH] = path # add COMP_PATH to context
    renderFromRealPath getComponentViewPath(path), context, cb

  renderInline: (templateStr, context, cb) ->
    if cb is undefined and typeof context is "function"
      cb = context
      context = {}
    template = templateLoader.fromText(templateStr)
    asyncRender.do template, context, cb

  registerLayout: registerLayout

  CONST:
    COMP_PATH: "COMP_PATH"

# cause render helpers need the render module, so require (init) them after module exports
require "./render_helpers"
