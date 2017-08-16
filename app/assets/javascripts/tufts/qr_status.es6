export default class QrStatus {
  constructor () {
    this.workId = $('.work-id').data().workId
    this.status()
    this.reloadOnClick()
  }
  status () {
    return Promise.resolve($.get(`/qr_statuses/${this.workId}/status`)).then(
      (data) => {
        if (data.batch_reviewed === true) {
          $('.mark-as-reviewed').attr('disabled', true)
        }
      }
    )
  }
  reloadOnClick () {
    $('.mark-as-reviewed').on('click', () => {
      Turbolinks.visit(location.toString())
    })
  }
}
