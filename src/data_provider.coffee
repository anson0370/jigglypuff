fs = require "fs"
path = require "path"
watch = require "node-watch"
env = require "./enviroments"
_ = require "lodash"

dataFilePath = env.dataFile

urlData = {}
compData = {}

loadData = ->
  if fs.existsSync(dataFilePath)
    data = require(dataFilePath)
    urlData = data.urls or {}
    compData = data.comps or {}

loadData()

watch dataFilePath, ->
  require.cache[dataFilePath] = null # clear module cache to reload module
  try
    loadData()
    console.log("[Data Reload]")
  catch err
    console.log("[Data Reload Error] #{err}")

module.exports =
  getUrlData: (path, method, params) ->
    return {found: false} unless _.has(urlData, path)
    data = urlData[path]
    {
      found: true
      result: if _.isFunction(data) then data(params, method) else data
    }

  getCompData: (path, params) ->
    return {found: false} unless _.has(compData, path)
    data = compData[path]
    {
      found: true
      result: if _.isFunction(data) then data(params) else data
    }
