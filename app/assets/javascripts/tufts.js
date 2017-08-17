var Tufts = {
  qrStatus: function () {
    var QrStatus = require('tufts/qr_status')
    return new QrStatus()
  },
  draft: function() {
    var Draft = require('tufts/draft')
    return new Draft()
  }
}

