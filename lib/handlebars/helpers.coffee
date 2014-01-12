handlebars = require "handlebars"

handlebars.registerHelper 'equals', (a, b, options) ->
  if a?.toString() == b?.toString()
    options.fn @
  else
    options.inverse @
