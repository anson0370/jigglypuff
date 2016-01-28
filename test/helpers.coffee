require "../src/handlebars/helpers"
handlebars = require "handlebars"
should = require "should"

describe "handlebars/helpers", ->
  describe "ifCond helper", ->
    it "should work", ->
      template = handlebars.compile("{{#ifCond 1 '<' 2}}true{{else}}false{{/ifCond}}")
      template().should.be.equal("true")

  describe "i18n helper", ->
    it "should work", ->
      template = handlebars.compile("{{i18n 'some sentence'}}")
      template().should.be.equal("some sentence")

  describe "i18nJs helper", ->
    it "should work", ->
      template = handlebars.compile("{{i18nJs}}")
      template().should.be.equal("")
