handlebars = require "handlebars"

handlebars.registerHelper "equals", (a, b, options) ->
  if a?.toString() == b?.toString()
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
