require('normalize.css')
require('./stylesheets/main.css')
var Main = require('./Main.elm').Elm.Main

module.exports = {
  create: function (flags) {
    var app = Main.init({ flags: flags })
  }
}
