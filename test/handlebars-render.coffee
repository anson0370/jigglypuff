render = require "../src/handlebars/render"
handlebars = require "handlebars"
should = require "should"

describe "handlebars/render", ->
  it "should register layout correctly", ->
    should.exist handlebars.partials["_layout"]
    should.exist handlebars.partials["sub_dir/_layout"]

  it "should register custom helpers correctly", ->
    should.exist handlebars.helpers["customHelper1"]
    should.exist handlebars.helpers["customHelper2"]
    should.exist handlebars.helpers["customHelper3"]

  describe "#renderFile()", ->
    it "should render single view correctly", ->
      result = render.renderFile "template", {ok: "ok", thanks: "thanks"}
      result.trim().should.be.equal("it's ok, thanks")

    it "can ignore second argument", ->
      result = render.renderFile "template"
      result.should.a.String

    it "should render partial and layout correctly", ->
      result = render.renderFile "partial"
      result.trim().should.be.equal("it's ok, thanks")

    it "should render partial and layout in sub dir correctly", ->
      result = render.renderFile "sub_dir/partial"
      result.trim().should.be.equal("it's ok, thanks")
