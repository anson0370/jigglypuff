dataProvider = require "../src/data_provider"
should = require "should"

describe "data_provider", ->
  it "should return {found: true} when data exists", ->
    result = dataProvider.getUrlData("/api/test")
    result.found.should.be.equal(true)
  it "should return {found: false} when data not exists", ->
    result = dataProvider.getUrlData("/api/not/exists")
    result.found.should.be.equal(false)
  it "should load all data from a path list", ->
    result = dataProvider.getUrlData("/api/test")
    result.found.should.be.equal(true)
    result = dataProvider.getUrlData("/api2/test")
    result.found.should.be.equal(true)
  it "should get pure url data", ->
    result = dataProvider.getUrlData("/api/test").result
    result.should.be.equal(1)
  it "should get url data from function", ->
    result = dataProvider.getUrlData("/api/test2", "GET", 2).result
    result.should.be.equal(2)
  it "should get pure comp data", ->
    result = dataProvider.getCompData("test/comp").result
    result.a.should.be.equal(1)
    result.b.should.be.equal(2)
  it "should get comp data from function", ->
    result = dataProvider.getCompData("test/comp2", {a: 1, b: 2}).result
    result.a.should.be.equal(1)
    result.b.should.be.equal(2)
