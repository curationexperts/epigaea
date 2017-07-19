var Draft = {
  init: () => {
    Draft.isSaved()
    Draft.bindSaveDraftClick()
    Draft.deleteDraftOnSave()
  },
  save: () => {
    Draft.delete()
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
      }
    }
  },
  apply: () => {
    $.get('/draft/apply_draft/' + Draft.getWorkId(), (data) => {
      var formData = JSON.parse(data.draft)
      for (key in formData) {
        if (formData.hasOwnProperty(key)) {
          $(`[id$=${key}]`).val(formData[key])
	  }
      }
    })
  },
  delete: () => {
    $.post('/draft/delete_draft/' + Draft.getWorkId(), (data) => {
      console.log(data)
    })
  },
  isSaved: () => {
    $.get('/draft/draft_saved/' + Draft.getWorkId(), (data) => {
      if (data.status) {
        $('.draft-bar').append(`<span class='draft-status'>This work has a saved draft.</span>`)
        Draft.apply()
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
  }
}
