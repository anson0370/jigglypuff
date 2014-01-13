# set node env to test first
process.env.NODE_ENV = "test"

env = require "../src/enviroments"

describe "enviroments", ->
  it "should provid default settings", ->
    env.serverPort.should.be.equal(8080)

  it "should override default settings when jiggly.json exists", ->
    env.filesHome.should.be.equal("#{__dirname}/files")
