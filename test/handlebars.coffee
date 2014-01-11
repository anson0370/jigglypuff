# set views home to test views
fs = require "fs"
env = require "../lib/enviroments"
env.viewsHome = "#{__dirname}/views"

templateLoader = require "../lib/handlebars/template_loader"
async = require "../lib/handlebars/async"
render = require "../lib/handlebars/render"
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

describe.only "render", ->
  it "should register layout correctly", ->
    handlebars.partials["_layout"].should.be.ok
    handlebars.partials["sub_dir/_layout"].should.be.ok

  describe "#renderFile()", ->
    it "should render single view correctly", (done) ->
      render.renderFile "template", {ok: "ok", thanks: "thanks"}, (result) ->
        result.trim().should.be.equal("it's ok, thanks")
        done()

    it "can ignore second argument", (done) ->
      render.renderFile "template", (result) ->
        result.should.a.String
        done()

    it "should render partial and layout correctly", (done) ->
      render.renderFile "partial", (result) ->
        result.trim().should.be.equal("it's ok, thanks")
        done()

    it "should render partial and layout in sub dir correctly", (done) ->
      render.renderFile "sub_dir/partial", (result) ->
        result.trim().should.be.equal("it's ok, thanks")
        done()
