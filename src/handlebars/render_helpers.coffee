render = require "./render"
asyncRender = require "./async_render"

asyncRender.registerAsyncHelper "inject", (path, options, resolve) ->
  render.renderComponent path, @, resolve
