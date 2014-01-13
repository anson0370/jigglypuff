# set node env to test first
process.env.NODE_ENV = "test"

env = require "../src/enviroments"

describe "enviroments", ->
  it "should provid default settings", ->
    env.useless.should.be.equal("wtf")

  it "should override default settings when jiggly.json exists", ->
    env.serverPort.should.be.equal(8081)
