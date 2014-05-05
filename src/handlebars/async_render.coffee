handlebars = require "handlebars"
_ = require "lodash"

class AsyncRender
  constructor: ->
    @values = {}
    @callback = undefined
    @resolved = false
    @count = 0
    @idCount = 0

  genId: ->
    "__ASYNC_PLACEHOLDER_#{@idCount++}__"

  deferred: ->
    ++@count

  resolve: (id, value) ->
    @values[id] = value
    if --@count is 0
      @resolved = true
      @callback?()

  done: (cb) ->
    @callback = cb
    @callback() if @resolved

  @KEY: "__ASYNC__"

  @do: (t, content, cb) ->
    if cb is undefined and typeof content is "function"
      cb = content
      content = {}
    content = content or {}
    if content[@KEY] isnt undefined
      # shallow clone is enough
      content = _.clone content
      content[@KEY] = undefined
    try
      result = t(content)
    catch e
      console.error "error when render template: #{t}"
      cb(e)
    asyncRender = content[@KEY]
    if asyncRender is undefined
      cb(undefined, result)
    else
      asyncRender.done ->
        vals = @values
        Object.keys(vals).forEach (id) ->
          result = result.replace id, vals[id].toString()
        cb(undefined, result)

  @resolve: (fn, context, args) ->
    asyncRender = context[@KEY]
    asyncRender = context[@KEY] = new AsyncRender if asyncRender is undefined
    asyncRender.deferred()
    id = asyncRender.genId()
    [].push.call args, (err, result) ->
      if err
        console.error "error when render async helper: #{err}"
        asyncRender.resolve id, ""
      else
        asyncRender.resolve id, result

    fn.apply context, args
    id

module.exports =
  do: AsyncRender.do.bind(AsyncRender)
  registerAsyncHelper: (name, fn) ->
    handlebars.registerHelper name, ->
      AsyncRender.resolve fn, @, arguments
