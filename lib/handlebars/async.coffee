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
    @resolved = false
    @

  resolve: (id, value) ->
    @values[id] = value
    if --@count is 0
      @resolved = true
      @callback?()
    @

  synced: (id) ->
    value = @values[id]
    delete @values[id]
    value

  done: (cb) ->
    @callback = cb
    @callback() if @resolved
    @

  ###
  This method should be called immediately once a template rendered.
  By follow this principle, it can reset the async instance before next instance created.

  use like this:
    Async.do template(), (result) -> console.log result
  ###
  @done: (result, cb) ->
    if async is undefined
      cb(result)
    else
      async.done ->
        vals = @values
        keys = Object.keys(vals)
        if keys.length > 0
          keys.forEach (id) ->
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

    res = fn.apply context, args
    # if return synced, return helper render result directly
    if res instanceof Async
      res.synced id
    else
      id

module.exports =
  done: Async.done
  registerAsyncHelper: (name, fn) ->
    handlebars.registerHelper name, ->
      Async.resolve fn, @, arguments
