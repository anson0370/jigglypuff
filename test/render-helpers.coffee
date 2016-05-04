require "../src/handlebars/render_helpers"
handlebars = require "handlebars"
should = require "should"

describe "handlebars/render_helpers", ->
  describe "inject helper", ->
    it "should work", ->
      template = handlebars.compile("{{inject 'test'}}")
      template().should.be.equal("test view\n")
    it "should get and render hash param", ->
      template = handlebars.compile("{{inject 'test' hashParam=1}}")
      template().should.be.equal("test view1\n")
