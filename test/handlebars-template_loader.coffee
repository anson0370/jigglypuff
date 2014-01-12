# set node env to test first
process.env.NODE_ENV = "test"

env = require "../lib/enviroments"
templateLoader = require "../lib/handlebars/template_loader"

describe "template_loader", ->
  describe "#fromPath()", ->
    it "should get template from file", (done) ->
      templateLoader.fromPath "#{env.viewsHome}/template.hbs", (template) ->
        template.should.be.an.instanceOf(Function)
        done()
