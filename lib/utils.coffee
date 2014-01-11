crypto = require "crypto"

module.exports =
  syncLike: (fs) ->
    return if fs is undefined or fs.length is 0
    return fs[0]() if fs.length is 1

    nextList = []
    for i in [(fs.length - 1)..0]
      if i is fs.length - 1
        nextList[i] = undefined
      else
        do ->
          index = i
          nextList[index] = ->
            [].push.call(arguments, nextList[index + 1])
            fs[index + 1].apply undefined, arguments

    fs[0].call undefined, nextList[0]

  md5: (content) ->
    crypto.createHash("md5").update(content).digest("hex")

  homePath: ->
    process.env[if process.platform is "win32" then "USERPROFILE" else "HOME"]
