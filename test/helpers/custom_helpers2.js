module.exports = function (handlebars) {
  handlebars.registerHelper("customHelper3", function() {
    return "c3";
  });
}
