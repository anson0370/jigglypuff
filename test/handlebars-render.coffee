render = require "../src/handlebars/render"
handlebars = require "handlebars"
should = require "should"

describe "render", ->
  it "should register layout correctly", ->
    should.exist handlebars.partials["_layout"]
    should.exist handlebars.partials["sub_dir/_layout"]

  it "should register custom helpers correctly", ->
    should.exist handlebars.helpers["customHelper1"]
    should.exist handlebars.helpers["customHelper2"]
    should.exist handlebars.helpers["customHelper3"]

  describe "#renderFile()", ->
    it "should render single view correctly", (done) ->
      render.renderFile "template", {ok: "ok", thanks: "thanks"}, (err, result) ->
        should.not.exist err
        result.trim().should.be.equal("it's ok, thanks")
        done()

    it "can ignore second argument", (done) ->
      render.renderFile "template", (err, result) ->
        should.not.exist err
        result.should.a.String
        done()

    it "should render partial and layout correctly", (done) ->
      render.renderFile "partial", (err, result) ->
        should.not.exist err
        result.trim().should.be.equal("it's ok, thanks")
        done()

    it "should render partial and layout in sub dir correctly", (done) ->
      render.renderFile "sub_dir/partial", (err, result) ->
        should.not.exist err
        result.trim().should.be.equal("it's ok, thanks")
        done()

  describe "#renderInline()", ->
    it "should render inline template correctly", (done) ->
      render.renderInline "it's {{ok}}, {{thanks}}", {ok: "ok", thanks: "thanks"}, (err, result) ->
        should.not.exist err
        result.trim().should.be.equal("it's ok, thanks")
        done()

    it "can ignore second argument", (done) ->
      render.renderInline "it's ok, thanks", (err, result) ->
        should.not.exist err
        result.trim().should.be.equal("it's ok, thanks")
        done()
