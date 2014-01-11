handlebars = require "handlebars"
http = require "http"

class AsyncRender
  @KEY: "_ASYNC_RENDER_"

  constructor: (template, data, callback) ->
    @clean()
    @template = template
    @data = data or {}
    @data[AsyncRender.KEY] = @
    @callback = callback

  clean: ->
    @context = {}
    @fillMode = false
    @index = 0
    @doCount = 0
    @doneCount = 0
    @canComplete = false

  render: ->
    @result = @template(@data)
    @canComplete = true
    @complete()

  complete: ->
    return unless @canComplete
    if @doCount is 0
      @callback(@result)
      return
    if @doneCount is @doCount
      @fillMode = true
      @result = @template(@data)
      @clean()
      @callback(@result)

  do: ->
    @doCount++

  done: (index, data) ->
    @context[index] = data
    @doneCount++
    @complete()

  get: ->
    @context[@index++]

handlebars.registerHelper 'inject', (path, options) ->
  asyncRender = @[AsyncRender.KEY]
  if asyncRender.fillMode
    asyncRender.get()
  else
    index = asyncRender.do()
    ### TODO
    1. get component info by path
    2. parse parameters from options.fn()
    3. get component template from template loader
    4. invoke rest api if have
    5. render and put to asyncRender
    ###
    http.get({host: 'localhost', port: '8080', path: '/'}, (res) ->
    # http.get('http://www.rrs.cn/api/cart/count?callback=_test', (res) ->
      data = ''
      res.on 'data', (chunk) ->
        data += chunk.toString()

      res.on 'end', ->
        asyncRender.done index, data
    )
    ""

module.exports = AsyncRender
