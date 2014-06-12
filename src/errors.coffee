class FileNotFoundError
  constructor: (@path) ->

module.exports =
  FileNotFoundError: FileNotFoundError
