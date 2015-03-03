fs = require "fs"
path = require "path"
_ = require "lodash"
commander = require "commander"

# default config
config =
  serverPort: 8080
  filesHome: "public"
  viewsHome: undefined
  componentsHome: undefined
  dataFiles: []
  extraHelpers: []
  oldMode: false
  pageMode: false
  assetsPrefix: undefined

env = process.env.NODE_ENV or "dev"

configFilePath = "jiggly.json"
port = 8080

if env isnt "test"
  commander
    .version("Jigglypuff version: 0.0.15")
    .usage("[options] [file], file default: jiggly.json")
    .option("-p, --port [port]", "Use the specified port, will override port config in config.json.")

  commander.on "--help", ->
    console.log "  Examples:"
    console.log ""
    console.log "    $ jiggly"
    console.log "    $ jiggly config.json"
    console.log "    $ jiggly -p 8000"

  commander.parse(process.argv)

  if not _.isEmpty(commander.args)
    configFilePath = commander.args[0]
  if commander.port isnt undefined
    port = parseInt(commander.port)
    if _.isNaN(port)
      commander.help()

configFile = path.resolve process.cwd(), configFilePath
basePath = path.dirname configFile
if fs.existsSync configFile
  outerConfig = require configFile
  _.assign config, outerConfig
  delete config.env
  if envConfig = outerConfig.env?[env]
    _.assign config, envConfig

# resolve all relative path to absolute path
config.filesHome = path.resolve basePath, config.filesHome

if config.viewsHome
  config.viewsHome = path.resolve basePath, config.viewsHome
else
  config.viewsHome = path.resolve basePath, config.filesHome, "views"

if config.componentsHome
  config.componentsHome = path.resolve basePath, config.componentsHome
else
  config.componentsHome = path.resolve basePath, config.filesHome, "components"

config.dataFiles = _.map config.dataFiles, (dataFile) ->
  path.resolve basePath, dataFile

config.extraHelpers = _.map config.extraHelpers, (helperFile) ->
  path.resolve basePath, helperFile

# override port
if commander.port isnt undefined
  port = parseInt(commander.port)
  if _.isNaN(port)
    commander.help()
  config.serverPort = port

console.log "Config file path: #{configFile}"
console.log "Config loaded:"
console.log config

module.exports = config
