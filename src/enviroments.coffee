fs = require "fs"
path = require "path"
_ = require "lodash"

env = process.env.NODE_ENV or "dev"

# default config
config =
  serverPort: 8080
  filesHome: "public"
  viewsHome: undefined
  componentsHome: undefined
  dataFiles: ["data.js"]
  extraHelpers: ["extra_helpers.js"]
  oldMode: false
  pageMode: false

cwdPath = process.cwd()
configFile = path.resolve cwdPath, "jiggly.json"
if fs.existsSync configFile
  outerConfig = require configFile
  _.assign config, outerConfig
  delete config.env
  if envConfig = outerConfig.env?[env]
    _.assign config, envConfig

# resolve all relative path to absolute path
config.filesHome = path.resolve cwdPath, config.filesHome

if config.viewsHome
  config.viewsHome = path.resolve cwdPath, config.viewsHome
else
  config.viewsHome = path.resolve cwdPath, config.filesHome, "views"

if config.componentsHome
  config.componentsHome = path.resolve cwdPath, config.componentsHome
else
  config.componentsHome = path.resolve cwdPath, config.filesHome, "components"

config.dataFiles = _.map config.dataFiles, (dataFile) ->
  path.resolve cwdPath, dataFile

config.extraHelpers = _.map config.extraHelpers, (helperFile) ->
  path.resolve cwdPath, helperFile

console.log "config loaded:"
console.log config

module.exports = config
