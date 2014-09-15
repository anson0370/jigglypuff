fs = require "fs"
path = require "path"
watch = require "node-watch"
env = require "./enviroments"
_ = require "lodash"

dataFilePath = env.dataFile

data = {}
data = require(dataFilePath) if fs.existsSync(dataFilePath)

watch dataFilePath, ->
  require.cache[dataFilePath] = null # clear module cache to reload module
  data = require(dataFilePath)
  console.log("[Data Reload]")

module.exports =
  get: (path, params) ->
    return {found: false} unless _.has(data, path)
    result = data[path]
    {
      found: true
      result: if _.isFunction(result) then result(params) else result
    }
