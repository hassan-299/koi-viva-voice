import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    // this.autoHide() // this can be un commented to set the autohide flash messages
  }

  autoHide () {
    setTimeout(() => {
      this.close()
    }, 5000) // 5 seconds till auto hide
  }

  close () {
    this.element.remove()
  }
}
