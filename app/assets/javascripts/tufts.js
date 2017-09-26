var Tufts = {
  qrStatus: function () {
    var QrStatus = require('tufts/qr_status')
    return new QrStatus()
  },
  draft: function () {
    var Draft = require('tufts/draft')
    return new Draft()
  },
  autocomplete: function () {
    var Autocomplete = require('hyrax/autocomplete')
    var autocomplete = new Autocomplete()
  
    autocomplete.setup($('#contribution_geonames_placeholder'),'default','/authorities/search/geonames')
  }
}
