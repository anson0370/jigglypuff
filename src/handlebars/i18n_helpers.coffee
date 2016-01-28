handlebars = require "handlebars"

handlebars.registerHelper "i18n", (key, options) ->
  key

handlebars.registerHelper "i18nJs", ->
  ""

handlebars.registerHelper "i18nJsHelper", ->
  new handlebars.SafeString('if (window.Handlebars) {Handlebars.registerHelper("i18n", function(key) {return key;});}')
