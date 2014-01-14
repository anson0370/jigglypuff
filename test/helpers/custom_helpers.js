module.exports = function (handlebars) {
  handlebars.registerHelper("customHelper1", function() {
    return "c1";
  });
  handlebars.registerHelper("customHelper2", function() {
    return "c2";
  });
}
