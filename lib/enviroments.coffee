env = process.env.NODE_ENV or "dev"
if env is "test"
  config = require("../test/properties/env_test")
else
  config = require("./properties/env_#{env}")
config.env = env

module.exports = config
