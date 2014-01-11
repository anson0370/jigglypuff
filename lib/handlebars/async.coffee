handlebars = require "handlebars"

idCount = 0
async = undefined

genId = ->
  "__HANDLEBARS_ASYNC_ID_#{idCount++}__"

class Async
  constructor: ->
    @values = {}
    @callback = undefined
    @resolved = false
    @count = 0

  deferred: ->
    ++@count

  resolve: (id, value) ->
    @values[id] = value
    if --@count is 0
      @resolved = true
      @callback?()

  done: (cb) ->
    @callback = cb
    cb() if @resolved

  ###
  This method should be called immediately once a template rendered.
  By follow this principle, it can reset the async instance before next instance created.

  use like this:
    Async.do template(), (result) -> console.log result
  ###
  @do: (result, cb) ->
    if async is undefined
      cb(result)
    else
      async.done ->
        vals = @values
        Object.keys(vals).forEach (id) ->
          result = result.replace id, vals[id].toString()
        cb(result)

    # reset for next template
    async = undefined
    idCount = 0

  @resolve: (fn, context, args) ->
    async = new Async() if async is undefined
    curAsync = async
    curAsync.deferred()
    id = genId()
    [].push.call args, (result) ->
      curAsync.resolve id, result

    fn.apply context, args
    id

module.exports =
  do: Async.do
  registerAsyncHelper: (name, fn) ->
    handlebars.registerHelper name, ->
      Async.resolve fn, @, arguments
