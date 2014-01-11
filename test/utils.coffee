utils = require "../lib/utils"

describe "utils", ->
  describe "#homePath()", ->
    it "should get home path", ->
      utils.homePath().should.be.equal "/Users/anson"

  describe "#syncLike()", ->
    it "should run async function sequenced", (done) ->
      r = []
      utils.syncLike [
        (next) ->
          setTimeout ->
            r.push 1
            next()
          , 10
        (next) ->
          process.nextTick ->
            r.push 2
            next()
        (next) ->
          r.push 3
          next()
        ->
          r[0].should.be.equal 1
          r[1].should.be.equal 2
          r[2].should.be.equal 3
          done()
      ]
