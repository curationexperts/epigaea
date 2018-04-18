var BatchSelection = {
  resetToAllFieldsOnTurboLinksLoad: function() {
    document.addEventListener("turbolinks:load", function() {
      $('#search_field').val('all_fields')
    })
  },
  changeSearchFieldOnBatchSelect: function() {
    $('.batch-search-dropdown-js').on('click', function() {
      $('#search_field').val('batch')
    })
  },
  changeSearchFieldOnOtherSelect: function() {
    $('.search-dropdown-js').on('click', function() {
      $('#search_field').val('all_fields')
    })
  }
}
