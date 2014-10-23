require "../src/handlebars/helpers"
handlebars = require "handlebars"
should = require "should"

describe "handlebars/helpers", ->
  describe "ifCond helper", ->
    it "should work", ->
      template = handlebars.compile("{{#ifCond 1 '<' 2}}true{{else}}false{{/ifCond}}")
      template().should.be.equal("true")
