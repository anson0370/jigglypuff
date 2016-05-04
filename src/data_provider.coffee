fs = require "fs"
path = require "path"
fileWatcher = require "./file_watcher"
env = require "./enviroments"
_ = require "lodash"

dataFilePaths = env.dataFiles

urlData = {}
compData = {}
globalData = {}

loadData = (dataFilePath) ->
  if fs.existsSync(dataFilePath)
    data = require(dataFilePath)
    urlData = _.assign urlData, data.urls
    compData = _.assign compData, data.comps
    globalData = _.assign globalData, data.globals

_.each dataFilePaths, loadData

fileWatcher.watchFiles dataFilePaths, (dataFilePath) ->
  require.cache[dataFilePath] = null # clear module cache to reload module
  try
    loadData(dataFilePath)
    console.log("[Data Reload] #{dataFilePath}")
  catch err
    console.log("[Data Reload Error] #{dataFilePath} - #{err}")

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

  getGlobalData: ->
    return globalData
