export default class Draft {
  contructor () {
  }
  init () {
    this.isSaved()
    this.bindSaveDraftClick()
    this.bindRevertDraftClick()
    this.deleteDraftOnSave()
    this.activateSaveButtonOnChange()
    this.activateRevertButton()
  }
  save () {
    // Save the form's data as a draft
    DraftUI.addRefreshToButton()
    // Clear out existing draft
    var deleteDraft = this.delete()
    deleteDraft.then(() => {
      var request = new XMLHttpRequest()
      var form = document.querySelector('.simple_form')
      var formData = new FormData(form)
      // Hyrax has a hidden field on the edit form that switches it to PATCH, we don't want to PATCH -- that's weird
      formData.delete('_method')

      request.open('POST', `/draft/save_draft/${this.getWorkId()}`)
      request.send(formData)

      request.onreadystatechange = () => {
        if (request.readyState === XMLHttpRequest.DONE) {
          this.isSaved()
          DraftUI.removeRefreshButton()
          this.activateRevertButton()
        }
      }
    })
  }
  delete () {
    // Delete the draft on the back-end
    return Promise.resolve($.post('/draft/delete_draft/' + this.getWorkId()))
  }
  isSaved () {
    // Check to see if the work has a saved draft
    $.get('/draft/draft_saved/' + this.getWorkId(), (data) => {
      if (data.status) {
        DraftUI.addEditedWorkflowStatus()
        this.activateRevertButton()
      } else {
        DraftUI.addPublishedWorkflowStatus()
      }
    })
  }
  getWorkId () {
    return document.querySelector('.simple_form').id.split('_')[2]
  }
  bindSaveDraftClick () {
    $('.save-draft').on('click', () => {
      this.save()
    })
  }
  bindRevertDraftClick () {
    $('.revert-draft').on('click', () => {
      var deleteDraft = this.delete()
      deleteDraft.then(() => {
        Turbolinks.visit(window.location.toString())
      })
    })
  }
  deleteDraftOnSave () {
    $('[name=save_with_files]').on('click', () => {
      this.delete()
    })
  }
  activateSaveButtonOnChange () {
    // Don't allow the user to click the save button until the form changes
    $('.simple_form').each(function () {
      $(this).data('serialized', $(this).serialize())
    }).on('change input', function () {
      $('.save-draft').prop('disabled', $(this).serialize() == $(this).data('serialized'))
    })
    $('.save-draft').prop('disabled', true)
  }
  activateRevertButton () {
    if ($('.workflow-status').text() === 'edited') {
       $('.revert-draft').prop('disabled', false)
    }
  }
}
