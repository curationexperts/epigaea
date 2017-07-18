var Draft = {
  saveDraft: function () {
    Draft.deleteDraft()
    var request = new XMLHttpRequest()
    var form = document.querySelector('.simple_form')
    var formData = new FormData(form)
    formData.delete('_method')

    request.open('POST', `/draft/save_draft/${this.getWorkId()}`)
    request.send(formData)

    request.onreadystatechange = function () {
      if (request.readyState == XMLHttpRequest.DONE) {
        console.log(request.responseText)
      }
    }
  },
  applyDraft: function () {
    $.get('/draft/apply_draft/' + this.getWorkId(), (data) => {
      var formData = JSON.parse(data.draft)
      console.log(formData)
    })
  },
  deleteDraft: function () {
    $.post('/draft/delete_draft/' + this.getWorkId(), (data) => {
      console.log(data)
    })
  },
  draftSaved: function () {
    $.get('/draft/draft_saved/' + this.getWorkId(), (data) => {
      console.log(data)
    })
  },
  getWorkId: function () {
    return document.querySelector('.simple_form').id.split('_')[2]
  }
}
