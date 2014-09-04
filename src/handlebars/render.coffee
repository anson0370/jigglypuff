_ = require "lodash"
fs = require "fs"
env = require "../enviroments"
templateLoader = require "./template_loader"
handlebars = require "handlebars"
{FileNotFoundError} = require "../errors"
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
    # console.log "[Layout Registered] #{name} - #{file}"

normalizePath = (path) ->
  if path[0] is "/" then path[1..] else path

getRealPath = (path) ->
  if env.pageMode then "#{env.viewsHome}/#{normalizePath(path)}/view.hbs" else "#{env.viewsHome}/#{normalizePath(path)}.hbs"

getComponentViewPath = (path) ->
  "#{env.componentsHome}/#{normalizePath(path)}/view.hbs"

renderFromRealPath = (path, context) ->
  template = templateLoader.fromPathSync path
  template(context)

module.exports =
  renderFile: (path, context) ->
    try
      renderFromRealPath getRealPath(path), context
    catch err
      if err instanceof FileNotFoundError
        console.log "[View Not Found] #{err.path}"
        "404 view not found: #{err.path}"
      else
        throw err

  renderComponent: (path, context) ->
    context = context or {}
    context[@CONST.COMP_PATH] = path # add COMP_PATH to context
    try
      renderFromRealPath getComponentViewPath(path), context
    catch err
      if err instanceof FileNotFoundError
        console.log "[Component Not Found] #{err.path}"
        "component view not found: #{err.path}"
      else
        throw err

  registerLayout: registerLayout

  CONST:
    COMP_PATH: "COMP_PATH"

# cause render helpers need the render module, so require (init) them after module exports
require "./render_helpers"
