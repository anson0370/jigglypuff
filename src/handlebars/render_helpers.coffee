render = require "./render"
async = require "./async"

async.registerAsyncHelper "inject", (path, options, resolve) ->
  render.renderComponent path, @, resolve
