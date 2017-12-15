var Tufts = {
  qrStatus: function () {
    var QrStatus = require('tufts/qr_status')
    return new QrStatus()
  },
  autocomplete: function () {
    var Autocomplete = require('hyrax/autocomplete')
    var autocomplete = new Autocomplete()

    autocomplete.setup($('#contribution_department'),'default','/authorities/search/local/departments')
  },
  selectAllOfHyrax: function() {
    $('[data-search-option="/catalog"]').click()
  },
  activateDataTable: function(options) {
    $(document).on('turbolinks:load', function() {
      if ($.fn.dataTable.isDataTable(options.selector)) {
        table = $(options.selector).DataTable()
      }
      else {
        table = $(options.selector).DataTable( {
          paging: options.paging
        })
      }
    })
    $(document).on("turbolinks:before-cache", function() {
      $(options.selector).DataTable().destroy()
    })
  },
  activateBatchesTable: function() {
    $(document).on('turbolinks:load', function() {
      if ($.fn.dataTable.isDataTable('#batch-table')) {
        table = $('#batch-table').DataTable()
      }
      else {
        $('#batch-table').DataTable( {
          "stateSave": true,
          "processing": true,
          "paging": true,
          "serverSide": true,
          "searching": false,
          "ajax": "/batches.json"
        })

      }
    })
    $(document).on("turbolinks:before-cache", function() {
      $('#batch-table').DataTable().destroy()
    })
  }
}
