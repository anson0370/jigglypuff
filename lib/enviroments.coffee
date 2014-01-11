env = process.env.NODE_ENV or "dev"
config = require("./properties/env_#{env}")
config.env = env

module.exports = config
