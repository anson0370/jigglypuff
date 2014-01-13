env = require "../src/enviroments"
should = require "should"

describe "enviroments", ->
  it "should provid default settings", ->
    env.serverPort.should.be.equal(8080)
    should.not.exist env.env

  it "should override default settings when jiggly.json exists", ->
    env.filesHome.should.be.equal("#{__dirname}/files")
    env.componentsHome.should.be.equal("#{__dirname}/components")
