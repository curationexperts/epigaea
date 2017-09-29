var Tufts = {
  qrStatus: function () {
    var QrStatus = require('tufts/qr_status')
    return new QrStatus()
  },
  autocomplete: function () {
    var Autocomplete = require('hyrax/autocomplete')
    var autocomplete = new Autocomplete()
    
    autocomplete.setup($('#contribution_department'),'default','/authorities/search/local/departments')
  }
}
