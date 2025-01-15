import Rails from "@rails/ujs";

const initRecordVideo = () => {
  // console.log(".......initRecordVideo.......");
  const form = document.querySelector("form");
  const startButton = document.getElementById("start");
  const autoStartButton = document.getElementById("auto-start");
  const stopButton = document.getElementById("stop");
  const liveVideo = document.getElementById("live");
  const secondsDisplay = document.getElementById("video-recording-seconds");
  const recorded = document.getElementById("recorded");
  const submitButton = document.getElementById("submit");
  const prefix = document.getElementById("prefix");
  const answer = document.getElementById("answer");
  const durationElement = document.getElementById("duration");
  const duration = durationElement?.value;
  const answerInput = document.getElementById("answer-input");

  answer.style.display = 'none';
  submitButton.style.display = 'none';
  startButton.style.display = 'none';

  // If answer already exists, exit
  if (answerInput?.value.length > 0) {
    prefix.innerHTML = '<strong>Answer already submitted</strong>';
    prefix.style.display = 'block';
    return;
  }
  if (!form || !stopButton || !liveVideo || !secondsDisplay || (answerInput && !answerInput?.value === undefined)) return;

  let timerInterval;
  let secondsElapsed = 0;

  const stopVideoStream = () => {
    if (liveVideo.srcObject) {
      liveVideo.srcObject.getTracks().forEach(track => track.stop());
      liveVideo.srcObject = null;
    }
  };

  const waitForStop = () =>
    new Promise(resolve => stopButton.addEventListener("click", resolve, { once: true }));

  const startRecording = (stream) => {
    console.log("Starting video recording...");
    const recorder = new MediaRecorder(stream);
    const chunks = [];
    recorder.ondataavailable = event => chunks.push(event.data);
    recorder.start();

    // Reset and start the timer
    secondsElapsed = 0;
    secondsDisplay.textContent = `Recording starting...`;
    timerInterval = setInterval(() => {
      secondsElapsed++;
      secondsDisplay.textContent = `Recording: ${secondsElapsed} seconds`;
    }, 1000);

    const stopped = new Promise((resolve, reject) => {
      recorder.onstop = () => {
        clearInterval(timerInterval); // Stop the timer
        resolve();
      };
      recorder.onerror = event => reject(event.name);
    });

    const recordingStopped = waitForStop().then(() => {
      stopVideoStream();
      if (recorder.state === "recording") recorder.stop();
    });

    return Promise.all([stopped, recordingStopped]).then(() => chunks);
  };

  const uploadToS3 = (videoBlob) => {
    // console.log("----------- s3 --------------");
    const formData = new FormData(form); // Create FormData from the original form
    formData.append("video[live]", videoBlob, "my_video.mp4"); // Append the video blob with a name

    // Rails AJAX request to upload the video
    // Rails.ajax({
    //   url: form.action,
    //   type: "POST",
    //   data: formData,
    //   success: () => alert("Video uploaded successfully!"),
    //   error: () => alert("Video upload failed. Please try again, and make sure video size must be less than 50 MB."),
    // });
    Rails.ajax({
      url: form.action,
      type: "POST",
      data: formData
    });
  };

  startButton.addEventListener("click", () => {
    // console.log("----------- start button --------------");
    startButton.style.display = 'none';
    stopButton.style.display = 'block';
    navigator.mediaDevices.getUserMedia({ video: true, audio: true })
      .then(stream => {
        liveVideo.srcObject = stream;
        return new Promise(resolve => (liveVideo.onplaying = resolve));
      })
      .then(() => startRecording(liveVideo.srcObject))
      .then(recordedChunks => {
        const recordedBlob = new Blob(recordedChunks, { type: "video/mp4" });
        // console.log("Recorded Blob:", recordedBlob);
        startButton.style.display = 'block';
        stopButton.style.display = 'none';
        secondsDisplay.textContent = `To start recording again, please click the button below.`;
        uploadToS3(recordedBlob); // Upload the video to s3
        const videoURL = URL.createObjectURL(recordedBlob);
        const videoPreviewElement = document.createElement('video');
        videoPreviewElement.src = videoURL;
        videoPreviewElement.controls = true;
        videoPreviewElement.width = 300; // Set preview width
        videoPreviewElement.height = 200; // Set preview height

        // Append the preview video element to the preview container
        recorded.innerHTML = '<strong>Preview</strong>';
        recorded.appendChild(videoPreviewElement);

        // Optionally, auto-play the preview video
        videoPreviewElement.play();
      })
      .catch(error => {
        console.error("Error with video recording:", error);
        // alert("Could not start the video recording. Check your permissions or settings.");
      });
  });

  // Delayed initialization for Start recording
  setTimeout(() => {
    if (autoStartButton) {
      // console.log("----------- in --------------");
      navigator.mediaDevices.getUserMedia({ video: true, audio: true })
        .then(stream => {
          liveVideo.srcObject = stream;
          return new Promise(resolve => (liveVideo.onplaying = resolve));
        })
        .then(() => startRecording(liveVideo.srcObject))
        .then(recordedChunks => {
          const recordedBlob = new Blob(recordedChunks, { type: "video/mp4" });
          // console.log("Recorded Blob:", recordedBlob);
          
          startButton.style.display = 'block';
          stopButton.style.display = 'none';
          secondsDisplay.textContent = `To start recording again, please click the button below.`;
          // // Get the hidden input field
          // const hiddenInput = document.getElementById('live-input');

          // // Create a File object from the Blob (optional, but often useful)
          // const recordedFile = new File([recordedBlob], 'recorded-video.mp4', {
          //   type: "video/mp4"
          // });

          // // Set the files property of the hidden input
          // hiddenInput.files = new FileList(recordedFile);

          // // If you're using a form that will be submitted via Rails
          // // You might also want to trigger a change event to ensure Rails picks up the file
          // const event = new Event('change', { bubbles: true });
          // hiddenInput.dispatchEvent(event);

          // Convert the Blob to a File object
          // const videoFile = new File([recordedBlob], "recorded_video.mp4", { type: "video/mp4" });

          // // Create a DataTransfer object
          // const dataTransfer = new DataTransfer();

          // // Add the video file to the DataTransfer object
          // dataTransfer.items.add(videoFile);

          // // Assign the DataTransfer files to the hidden file input
          // liveInput.files = dataTransfer.files; // Set the files property of the hidden input
              // const form = document.querySelector('form'); // your form
              // const formData = new FormData(form);
              // formData.set('video[live]', recordedBlob, 'recorded-video.mp4');
          // // assign the recorded video blob to the hidden file input
          // const videoFile = new File([recordedBlob], "recorded_video.mp4", { type: "video/mp4" });
          // const dataTransfer = new DataTransfer();  // Creating a DataTransfer object
          // dataTransfer.items.add(videoFile); // Adding the video file to the DataTransfer object
          // liveInput.files = dataTransfer.files;

          uploadToS3(recordedBlob); // Upload the video to s3
          // // Preview
          const videoURL = URL.createObjectURL(recordedBlob);
          const videoPreviewElement = document.createElement('video');
          videoPreviewElement.src = videoURL;
          videoPreviewElement.controls = true;
          videoPreviewElement.width = 300; // Set preview width
          videoPreviewElement.height = 200; // Set preview height

          // Append the preview video element to the preview container
          recorded.innerHTML = '<strong>Preview</strong>';
          recorded.appendChild(videoPreviewElement);

          // Optionally, auto-play the preview video
          videoPreviewElement.play();
        })
        .catch(error => {
          console.error("Error with video recording:", error);
          alert("Could not start the video recording. Check your permissions or settings.");
        });
    }
  }, 5000); // Wait for 5 seconds

  // countdown display
  let countdownValue = 5;
  const countdownInterval = setInterval(() => {
    prefix.textContent = `Starting in ${countdownValue} seconds...`;
    countdownValue--;

    if (countdownValue < 0) {
      clearInterval(countdownInterval);
      prefix.style.display = 'none';
      answer.style.display = 'block';
      // preview.style.display = 'block';
      submitButton.style.display = 'block';
    }
  }, 1000);

  // Check duration and auto-submit if valid
  if (duration && !isNaN(duration) && parseInt(duration) > 0) {
    const totalSeconds = parseInt(duration) * 60; // Convert minutes to seconds
    console.log("Auto-submit will happen in", totalSeconds, "seconds.");

    setTimeout(() => {
      // Stop recording and auto-submit
      stopButton.click();
      // submitButton.click();  // Automatically trigger form submission after recording is stopped
    }, totalSeconds * 1000);
  }
};

export { initRecordVideo };
