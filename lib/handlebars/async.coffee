handlebars = require "handlebars"
_ = require "lodash"

class Async
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
    result = t(content)
    async = content[@KEY]
    if async is undefined
      cb(result)
    else
      async.done ->
        vals = @values
        Object.keys(vals).forEach (id) ->
          result = result.replace id, vals[id].toString()
        cb(result)

  @resolve: (fn, context, args) ->
    async = context[@KEY]
    async = context[@KEY] = new Async if async is undefined
    async.deferred()
    id = async.genId()
    [].push.call args, (result) ->
      async.resolve id, result

    fn.apply context, args
    id

module.exports =
  do: Async.do.bind(Async)
  registerAsyncHelper: (name, fn) ->
    handlebars.registerHelper name, ->
      Async.resolve fn, @, arguments
