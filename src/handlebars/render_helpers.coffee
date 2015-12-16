render = require "./render"
handlebars = require "handlebars"
_ = require "lodash"
dataProvider = require "../data_provider"

handlebars.registerHelper "inject", (path, options) ->
  tempContext = _.clone @
  if options.fn
    compData = JSON.parse(options.fn())
    _.assign tempContext, compData
  dataResult = dataProvider.getCompData(path, tempContext)
  if dataResult.found
    mockResult = dataResult.result
    servicesResult = mockResult["_SERVICES_"]
    delete mockResult["_SERVICES_"]
    mockContext = {_DATA_: mockResult}
    if _.isObject(servicesResult)
      _.assign mockContext, servicesResult
    _.assign tempContext, mockContext
  new handlebars.SafeString(render.renderComponent path, tempContext)

handlebars.registerHelper "component", (className, options) ->
  new handlebars.SafeString("<div class=\"#{className}\" data-comp-path=\"#{@[render.CONST.COMP_PATH]}\">#{options.fn(@)}</div>")

handlebars.registerHelper "designPart", ->
  options = _.last(arguments)
  options.fn @ if options.fn
