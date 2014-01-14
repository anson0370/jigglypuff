crypto = require "crypto"

module.exports =
  md5: (content) ->
    crypto.createHash("md5").update(content).digest("hex")

  homePath: ->
    process.env[if process.platform is "win32" then "USERPROFILE" else "HOME"]
