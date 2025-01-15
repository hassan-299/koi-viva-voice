import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="form"
export default class extends Controller {
  connect () {
    console.log('form conntected')
  }

  closeModal (e) {
    if (e.detail.success) {
      const modal = document.getElementById('remote-modal')
      const backdrop = document.querySelector('.Polaris-Backdrop')
      modal.classList.add('Polaris--hidden')
      this.real_close()
      backdrop.remove()
    }
  }

  real_close (event) {
    const modalFrame = document.getElementById('modal')
    if (modalFrame) {
      modalFrame.outerHTML = '<turbo-frame id="modal"></turbo-frame>'
    }
  }
}
