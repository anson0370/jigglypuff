render = require "./render"
handlebars = require "handlebars"
_ = require "lodash"

handlebars.registerHelper "inject", (path, options) ->
  tempContext = _.clone @
  if options.fn
    compData = JSON.parse(options.fn())
    _.assign tempContext, compData
  new handlebars.SafeString(render.renderComponent path, tempContext)

handlebars.registerHelper "component", (className, options) ->
  new handlebars.SafeString("<div class=\"#{className}\" data-comp-path=\"#{@[render.CONST.COMP_PATH]}\">#{options.fn(@)}</div>")
