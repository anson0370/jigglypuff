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
      templateLoader.fromPath "#{env.viewsHome}/template.hbs", (template) ->
        template.should.be.an.instanceOf(Function)
        done()

describe "async", ->
  before ->
    async.registerAsyncHelper "asyncTest", (param1, param2, options, resolve) ->
      param1.should.be.a.Boolean
      param2.should.be.a.Number
      if param1
        setTimeout ->
          if param2 is 1
            resolve("ok")
          else
            resolve("thanks")
        , 10
      else
        if param2 is 1
          resolve("ok")
        else
          resolve("thanks")

  it "should support async helper", (done) ->
    template = handlebars.compile("it's {{asyncTest true 1}} {{asyncTest true 2}}")
    async.done template(), (result) ->
      result.should.be.equal("it's ok thanks")
      done()

  it "async helper should get the correctly 'this'", (done) ->
    template = handlebars.compile("it's {{asyncTest true a}} {{asyncTest true b}}")
    async.done template({a: 1, b: 2}), (result) ->
      result.should.be.equal("it's ok thanks")
      done()

  it "should work correctly when async helper return synced", ->
    template = handlebars.compile("it's {{asyncTest false 1}} {{asyncTest false 2}}")
    result = template()
    result.should.be.equal("it's ok thanks")
    async.done result, (result) ->
      result.should.be.equal("it's ok thanks")

  it "should work correctly when async helper mixed with async and sync return", (done) ->
    template = handlebars.compile("it's {{asyncTest false 1}} {{asyncTest false 2}}")
    async.done template(), (result) ->
      result.should.be.equal("it's ok thanks")
      done()

describe "render", ->
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
