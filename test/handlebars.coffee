templateLoader = require "../lib/handlebars/template_loader"

describe "template_loader", ->
  describe "#fromPath", ->
    it "should get template from file", (done) ->
      templateLoader.fromPath "layout", (template) ->
        template.should.be.an.instanceOf(Function)
        done()
