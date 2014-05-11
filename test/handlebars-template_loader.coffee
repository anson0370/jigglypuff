env = require "../src/enviroments"
templateLoader = require "../src/handlebars/template_loader"
should = require "should"

describe "handlebars/template_loader", ->
  describe "#fromPathSync()", ->
    it "should get template from file", ->
      template = templateLoader.fromPathSync "#{env.viewsHome}/template.hbs"
      template.should.be.an.instanceOf(Function)
