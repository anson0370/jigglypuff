handlebars = require "handlebars"
async = require "../lib/handlebars/async"

describe "async", ->
  before ->
    async.registerAsyncHelper "asyncTest", (param1, param2, options, resolve) ->
      param1.should.be.a.Boolean
      param2.should.be.a.Number
      if param1
        process.nextTick ->
          if param2 is 1
            resolve("ok")
          else
            resolve("thanks")
      else
        if param2 is 1
          resolve("ok")
        else
          resolve("thanks")

    async.registerAsyncHelper "asyncInAsync", (param1, options, resolve) ->
      template = handlebars.compile("{{ok}}")
      content = if param1 is 1 then {ok: "ok"} else {ok: "thanks"}
      process.nextTick ->
        async.do template, content, (result) ->
          resolve(result)

  it "should support async helper", (done) ->
    template = handlebars.compile("it's {{asyncTest true 1}} {{asyncTest true 2}}")
    async.do template, {}, (result) ->
      result.should.be.equal("it's ok thanks")
      done()

  it "can ignore second argument", (done) ->
    template = handlebars.compile("it's {{asyncTest true 1}} {{asyncTest true 2}}")
    async.do template, (result) ->
      result.should.be.equal("it's ok thanks")
      done()

  it "should support nested async call", (done) ->
    template = handlebars.compile("it's {{asyncInAsync 1}} {{asyncInAsync 2}}")
    async.do template, (result) ->
      result.should.be.equal("it's ok thanks")
      done()

  it "async helper should get the correctly 'this'", (done) ->
    template = handlebars.compile("it's {{asyncTest true a}} {{asyncTest true b}}")
    async.do template, {a: 1, b: 2}, (result) ->
      result.should.be.equal("it's ok thanks")
      done()

  it "should work correctly when async helper return synced", ->
    template = handlebars.compile("it's {{asyncTest false 1}} {{asyncTest false 2}}")
    async.do template, (result) ->
      result.should.be.equal("it's ok thanks")

  it "should work correctly when async helpers mixed with async and sync return", (done) ->
    template = handlebars.compile("it's {{asyncTest false 1}} {{asyncTest false 2}}")
    async.do template, (result) ->
      result.should.be.equal("it's ok thanks")
      done()

  it "should work correctly when render multiple templates", (done) ->
    template1 = handlebars.compile("it's {{asyncTest false 1}} {{asyncTest false 2}}")
    template2 = handlebars.compile("it's {{asyncTest false 2}} {{asyncTest false 1}}")
    t1done = false
    t2done = false
    async.do template1, (result) ->
      result.should.be.equal("it's ok thanks")
      t1done = true
      done() if t2done
    async.do template2, (result) ->
      result.should.be.equal("it's thanks ok")
      t2done = true
      done() if t1done
