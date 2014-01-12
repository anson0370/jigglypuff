path = require "path"

module.exports =
  serverPort: 8081
  filesHome: path.resolve("#{__dirname}/../files")
  viewsHome: path.resolve("#{__dirname}/../views")
  componentsHome: path.resolve("#{__dirname}/../components")
