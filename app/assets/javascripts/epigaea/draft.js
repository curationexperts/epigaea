var Draft = {
  init: () => {
    Draft.isSaved()
    Draft.bindSaveDraftClick()
    Draft.deleteDraftOnSave()
    Draft.activateSaveButtonOnChange()
  },
  save: () => {
    // Set spinner
    $('.glyphicon-ok').remove()
    $('.save-draft').append(`   <span class="glyphicon glyphicon-refresh glyphicon-refresh-animate" />`)
    // Clear out existing draft
    var deleteDraft = Draft.delete()
    console.log(deleteDraft)
    deleteDraft.then(() => {
      var request = new XMLHttpRequest()
      var form = document.querySelector('.simple_form')
      var formData = new FormData(form)
      formData.delete('_method')

      request.open('POST', `/draft/save_draft/${Draft.getWorkId()}`)
      request.send(formData)

      request.onreadystatechange = () => {
        if (request.readyState === XMLHttpRequest.DONE) {
          console.log(request.responseText)
          Draft.isSaved()
          $('.glyphicon-refresh').remove()
          $('.save-draft').append(`   <span class="glyphicon glyphicon-ok" />`)
        }
      }
    })
  },
  apply: () => {
    $.get('/draft/apply_draft/' + Draft.getWorkId(), (data) => {
      var formData = JSON.parse(data.draft)
      for (var key in formData) {
        // Filter out values that we don't want
        if (formData[key] != [''] && formData[key] !== null && formData[key] !== [] && formData[key] && formData[key][0] !== '' && formData[key].length != 0) {
          var inputField = $(`[id$=${key}]:first`)
          inputField.val(formData[key])
        }
      }
    })
  },
  delete: () => {
    return Promise.resolve($.post('/draft/delete_draft/' + Draft.getWorkId()))
  },
  isSaved: () => {
    $.get('/draft/draft_saved/' + Draft.getWorkId(), (data) => {
      console.log(data)
      if (data.status) {
        $('.workflow-status-container').remove()
        $('ul.drafts').append(`<li class="workflow-status-container"><span class="workflow-status edited">edited</span></li>`)
        Draft.apply()
      } else {
        $('.workflow-status-container').remove()
        $('ul.drafts').append(`<li class="workflow-status-container"><span class="workflow-status published">published</span></li>`)
      }
    })
  },
  getWorkId: () => {
    return document.querySelector('.simple_form').id.split('_')[2]
  },
  bindSaveDraftClick: () => {
    $('.save-draft').on('click', () => {
      Draft.save()
    })
  },
  deleteDraftOnSave: () => {
    $('[name=save_with_files]').on('click', () => {
      Draft.delete()
    })
  },
  activateSaveButtonOnChange: () => {
    $('.simple_form').each(function () {
      $(this).data('serialized', $(this).serialize())
    }).on('change input', function () {
      $('.save-draft').prop('disabled', $(this).serialize() == $(this).data('serialized'))
    })
    $('.save-draft').prop('disabled', true)
  }
}
