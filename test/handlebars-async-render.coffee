handlebars = require "handlebars"
asyncRender = require "../src/handlebars/async_render"
should = require "should"

describe "handlebars/async_render", ->
  before ->
    asyncRender.registerAsyncHelper "asyncTest", (param1, param2, options, resolve) ->
      param1.should.be.a.Boolean
      param2.should.be.a.Number
      if param1
        process.nextTick ->
          if param2 is 1
            resolve(undefined, "ok")
          else
            resolve(undefined, "thanks")
      else
        if param2 is 1
          resolve(undefined, "ok")
        else
          resolve(undefined, "thanks")

    asyncRender.registerAsyncHelper "asyncInAsync", (param1, options, resolve) ->
      template = handlebars.compile("{{ok}}")
      content = if param1 is 1 then {ok: "ok"} else {ok: "thanks"}
      process.nextTick ->
        asyncRender.do template, content, (err, result) ->
          should.not.exist err
          resolve(undefined, result)

  it "should support async helper", (done) ->
    template = handlebars.compile("it's {{asyncTest true 1}} {{asyncTest true 2}}")
    asyncRender.do template, {}, (err, result) ->
      should.not.exist err
      result.should.be.equal("it's ok thanks")
      done()

  it "can ignore second argument", (done) ->
    template = handlebars.compile("it's {{asyncTest true 1}} {{asyncTest true 2}}")
    asyncRender.do template, (err, result) ->
      should.not.exist err
      result.should.be.equal("it's ok thanks")
      done()

  it "should support nested async call", (done) ->
    template = handlebars.compile("it's {{asyncInAsync 1}} {{asyncInAsync 2}}")
    asyncRender.do template, (err, result) ->
      should.not.exist err
      result.should.be.equal("it's ok thanks")
      done()

  it "async helper should get the correctly 'this'", (done) ->
    template = handlebars.compile("it's {{asyncTest true a}} {{asyncTest true b}}")
    asyncRender.do template, {a: 1, b: 2}, (err, result) ->
      should.not.exist err
      result.should.be.equal("it's ok thanks")
      done()

  it "should work correctly when async helper return synced", ->
    template = handlebars.compile("it's {{asyncTest false 1}} {{asyncTest false 2}}")
    asyncRender.do template, (err, result) ->
      should.not.exist err
      result.should.be.equal("it's ok thanks")

  it "should work correctly when async helpers mixed with async and sync return", (done) ->
    template = handlebars.compile("it's {{asyncTest false 1}} {{asyncTest false 2}}")
    asyncRender.do template, (err, result) ->
      should.not.exist err
      result.should.be.equal("it's ok thanks")
      done()

  it "should work correctly when render multiple templates", (done) ->
    template1 = handlebars.compile("it's {{asyncTest false 1}} {{asyncTest false 2}}")
    template2 = handlebars.compile("it's {{asyncTest false 2}} {{asyncTest false 1}}")
    t1done = false
    t2done = false
    asyncRender.do template1, (err, result) ->
      should.not.exist err
      result.should.be.equal("it's ok thanks")
      t1done = true
      done() if t2done
    asyncRender.do template2, (err, result) ->
      should.not.exist err
      result.should.be.equal("it's thanks ok")
      t2done = true
      done() if t1done
