templateLoader = require "../lib/handlebars/template_loader"
async = require "../lib/handlebars/async"
handlebars = require "handlebars"

describe "template_loader", ->
  describe "#fromPath", ->
    it "should get template from file", (done) ->
      templateLoader.fromPath "layout", (template) ->
        template.should.be.an.instanceOf(Function)
        done()

describe "async", ->
  it "should support async helper", (done) ->
    async.registerAsyncHelper "asyncTest", (param1, param2, options, resolve) ->
      param1.should.be.equal("param1")
      param2.should.be.a.Number
      setTimeout ->
        if param2 is 1
          resolve("ok")
        else
          resolve("thanks")
      , 10
    template = handlebars.compile("it's {{asyncTest \"param1\" 1}} {{asyncTest \"param1\" 2}}")
    async.do template(), (result) ->
      result.should.be.equal("it's ok thanks")
      done()
