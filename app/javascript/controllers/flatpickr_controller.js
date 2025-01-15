import Flatpickr from 'stimulus-flatpickr'

export default class extends Flatpickr {
  static values = {
    enableTime: Boolean,
    rangeMode: Boolean
  }

  connect () {
    console.log('flatpicker connected')
    this.config = {
      ...this.config,
      mode: this.rangeModeValue ? 'range' : 'single',
      enableTime: this.enableTimeValue,
      altInput: true,
      altFormat: this.enableTimeValue ? 'F j, Y H:i' : 'F j, Y',
      dateFormat: this.enableTimeValue ? 'Y-m-d H:i' : 'Y-m-d'
    }
    super.connect()
  }
}
