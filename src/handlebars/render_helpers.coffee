render = require "./render"
asyncRender = require "./async_render"

asyncRender.registerAsyncHelper "inject", (path) ->
  render.renderComponent path, @, arguments[arguments.length - 1]
