// import Rails from "@rails/ujs";

// const initRecordVideo = () => {
//   const form = document.querySelector("ex-form");
//   const startButton = document.getElementById("start");
//   const stopButton = document.getElementById("stop");
//   const liveVideo = document.getElementById("live");

//   if (!form || !startButton || !stopButton || !liveVideo) return;

//   const stopVideoStream = () => {
//     if (liveVideo.srcObject) {
//       liveVideo.srcObject.getTracks().forEach(track => track.stop());
//       liveVideo.srcObject = null;
//     }
//   };

//   const waitForStop = () =>
//     new Promise(resolve => stopButton.addEventListener("click", resolve, { once: true }));

//   const startRecording = (stream) => {
//     const recorder = new MediaRecorder(stream);
//     const chunks = [];
//     recorder.ondataavailable = event => chunks.push(event.data);
//     recorder.start();

//     const stopped = new Promise((resolve, reject) => {
//       recorder.onstop = resolve;
//       recorder.onerror = event => reject(event.name);
//     });

//     const recordingStopped = waitForStop().then(() => {
//       stopVideoStream();
//       if (recorder.state === "recording") recorder.stop();
//     });

//     return Promise.all([stopped, recordingStopped]).then(() => chunks);
//   };

//   const uploadToCloudinary = (videoBlob) => {
//     const formData = new FormData(form); // Create FormData from the original form
//     formData.append("video[file]", videoBlob, "my_video.mp4"); // Append the video blob with a name

//     // Rails AJAX request to upload the video
//     Rails.ajax({
//       url: form.action,
//       type: "POST",
//       data: formData,
//       success: () => alert("Video uploaded successfully!"),
//       error: () => alert("Video upload failed. Please try again."),
//     });
//   };

//   startButton.addEventListener("click", () => {
//     navigator.mediaDevices.getUserMedia({ video: true, audio: true })
//       .then(stream => {
//         liveVideo.srcObject = stream;
//         return new Promise(resolve => (liveVideo.onplaying = resolve));
//       })
//       .then(() => startRecording(liveVideo.srcObject))
//       .then(recordedChunks => {
//         const recordedBlob = new Blob(recordedChunks, { type: "video/mp4" });
//         console.log("Recorded Blob:", recordedBlob);
//         uploadToCloudinary(recordedBlob); // Upload the video to Cloudinary
//       })
//       .catch(error => {
//         console.error("Error with video recording:", error);
//         alert("Could not start the video recording. Check your permissions or settings.");
//       });
//   });
// };

// export { initRecordVideo };
