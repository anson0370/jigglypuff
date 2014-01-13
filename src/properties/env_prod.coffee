utils = require "../utils"

module.exports =
  serverPort: 8080
  filesHome: "#{utils.homePath()}/nuwa/public"
  viewsHome: "#{utils.homePath()}/nuwa/public/views"
  componentsHome: "#{utils.homePath()}/nuwa/public/components"
