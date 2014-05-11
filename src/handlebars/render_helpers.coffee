render = require "./render"
asyncRender = require "./async_render"
handlebars = require "handlebars"

asyncRender.registerAsyncHelper "inject", (path) ->
  render.renderComponent path, @, arguments[arguments.length - 1]

handlebars.registerHelper "component", (className, options) ->
  new handlebars.SafeString("<div class=\"#{className}\">#{options.fn()}</div>")
