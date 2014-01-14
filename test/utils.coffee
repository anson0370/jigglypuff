utils = require "../src/utils"

describe "utils", ->
  describe "#homePath()", ->
    it "should get home path", ->
      utils.homePath().should.be.equal "/Users/anson"
