var Draft = {
  saveDraft: function () {
    var request = new XMLHttpRequest()
    var form = document.querySelector('.simple_form')
    request.open('PATCH', `/draft/save_draft/${this.getWorkId()}`)
    request.setRequestHeader('X-CSRF-Token', document.querySelector('[name=csrf-token]').getAttribute('content'))
    request.send(new FormData(form))
  },
  applyDraft: function () {
    $.get('/draft/apply_draft/' + this.getWorkId(), (data) => {
      var formData = JSON.parse(data.draft)
    })
  },
  getWorkId: function () {
    return document.querySelector('.simple_form').id.split('_')[2]
  }
}
