# set node env to test first
process.env.NODE_ENV = "test"

env = require "../src/enviroments"
templateLoader = require "../src/handlebars/template_loader"
should = require "should"

describe "template_loader", ->
  describe "#fromPath()", ->
    it "should get template from file", (done) ->
      templateLoader.fromPath "#{env.viewsHome}/template.hbs", (err, template) ->
        should.not.exist err
        template.should.be.an.instanceOf(Function)
        done()

    it "should callback with err when file not exist", (done) ->
      templateLoader.fromPath "#{env.viewsHome}/not_exist.hbs", (err, template) ->
        should.exist err
        should.not.exist template
        done()
