import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import "./controllers"
import "@oddcamp/cocoon-vanilla-js"
import { initRecordVideo } from "./components/record_video"
import * as echarts from 'echarts'
import 'echarts/theme/dark.js'

window.echarts = echarts

Rails.start()

// Ensure initRecordVideo is called when DOM is ready or Turbo renders new content
const initializeVideoRecording = () => {
  const liveVideoElement = document.querySelector("#live")
  if (liveVideoElement) {
    // console.log("Initializing video recording...")
    initRecordVideo()
  }
}

// Call the function on initial page load
// document.addEventListener("DOMContentLoaded", () => {
//   initializeVideoRecording()
// })

// Call the function when Turbo renders new content
document.addEventListener("turbo:load", () => {
  initializeVideoRecording()
})
