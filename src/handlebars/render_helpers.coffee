render = require "./render"
handlebars = require "handlebars"

handlebars.registerHelper "inject", (path) ->
  new handlebars.SafeString(render.renderComponent path, @)

handlebars.registerHelper "component", (className, options) ->
  new handlebars.SafeString("<div class=\"#{className}\" data-comp-path=\"#{@[render.CONST.COMP_PATH]}\">#{options.fn()}</div>")
