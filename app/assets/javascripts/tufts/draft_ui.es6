export default class DraftUI {
  constructor () {
  }
  addRefreshToButton () {
    $('.glyphicon-ok').remove()
    $('.save-draft').append(`   <span class="glyphicon glyphicon-refresh glyphicon-refresh-animate" />`)
  }
  removeRefreshButton () {
    $('.glyphicon-refresh').remove()
    $('.save-draft').append(`   <span class="glyphicon glyphicon-ok" />`)
  }
  addEditedWorkflowStatus () {
    $('.workflow-status-container').remove()
    $('ul.drafts').append(`<li class="workflow-status-container"><span class="workflow-status edited">edited</span></li>`)
  }
  addPublishedWorkflowStatus () {
    $('.workflow-status-container').remove()
    $('ul.drafts').append(`<li class="workflow-status-container"><span class="workflow-status published">published</span></li>`)
  }
}
