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
  getUrlData: (path, params) ->
    @getData("URL", path, params)

  getCompData: (path, params) ->
    @getData("COMP", path, params)

  getData: (type, path, params) ->
    targetData = switch type
      when "URL" then urlData
      when "COMP" then compData

    return {found: false} unless _.has(targetData, path)
    result = targetData[path]
    {
      found: true
      result: if _.isFunction(result) then result(params) else result
    }
