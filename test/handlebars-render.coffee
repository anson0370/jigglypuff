# set node env to test first
process.env.NODE_ENV = "test"

render = require "../lib/handlebars/render"
handlebars = require "handlebars"

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

  describe "#renderInline()", ->
    it "should render inline template correctly", (done) ->
      render.renderInline "it's {{ok}}, {{thanks}}", {ok: "ok", thanks: "thanks"}, (result) ->
        result.trim().should.be.equal("it's ok, thanks")
        done()

    it "can ignore second argument", (done) ->
      render.renderInline "it's ok, thanks", (result) ->
        result.trim().should.be.equal("it's ok, thanks")
        done()
