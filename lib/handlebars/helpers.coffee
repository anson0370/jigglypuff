handlebars = require "handlebars"
http = require "http"

asyncRender = require "./async_render"

blocks = {}

handlebars.registerHelper "partial", (name, options) ->
  unless block = blocks[name]
    block = blocks[name] = []
  block.push options.fn(@)
  undefined

handlebars.registerHelper "block", (name, options) ->
  content = (blocks[name] or []).join("\n")
  blocks[name] = []
  content
