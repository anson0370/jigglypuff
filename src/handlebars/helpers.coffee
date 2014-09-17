handlebars = require "handlebars"

handlebars.registerHelper "helperMissing", ->
  "missing helper"

handlebars.registerHelper "equals", (a, b, options) ->
  if a?.toString() == b?.toString()
    options.fn @
  else
    options.inverse @

handlebars.registerHelper "gt", (a, b, options) ->
  if parseFloat(a) > parseFloat(b)
    options.fn @
  else
    options.inverse @

handlebars.registerHelper "and", (a, b, options) ->
  if a? and b?
    options.fn @
  else
    options.inverse @

handlebars.registerHelper "neither", (a, b, options) ->
  if !a and !b
    options.fn @
  else
    options.inverse @

handlebars.registerHelper "mod", (a, b, options) ->
  if (a + 1) % b != 0
    options.inverse @
  else
    options.fn @

handlebars.registerHelper "pp", (options) ->
  JSON.stringify @

handlebars.registerHelper "json", (options) ->
  JSON.stringify @

handlebars.registerHelper "size", (a, options) ->
  return 0 if a is undefined
  if a.length
    return if _.isFunction(a.length) then a.length() else a.length
  if a.size
    return if _.isFunction(a.size) then a.size() else a.size
  0
