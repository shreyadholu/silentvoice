import cv2
import os
import time

# Labels for different gestures
labels = [
    "hello",
    "thank_you",
    "please",
    "good_morning",
    "good_night",
    "i_am_hungry",
    "i_am_thirsty",
    "how_are_you"
]

# Default label
selected_label = labels[0]

# Create dataset directory if not exists
dataset_path = "SignDataset"
if not os.path.exists(dataset_path):
    os.mkdir(dataset_path)

# Start capturing video
cap = cv2.VideoCapture(0)

# Define video parameters
fps = 30
video_duration = 3  # Duration of each video in seconds
fourcc = cv2.VideoWriter_fourcc(*'mp4v')

print("Press 'r' to record a video, 'n' to switch labels, or 'q' to quit.")
print(f"Each recording will be {video_duration} seconds long.")
label_index = 0  # Tracks the selected label
recording = False
video_writer = None
start_time = 0

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # Display the selected label and recording status on the video feed
    status = "RECORDING" if recording else "Ready"
    cv2.putText(frame, f"Label: {selected_label} | Status: {status}", (10, 40),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    cv2.imshow("Sign Language Data Collection", frame)

    # If recording, write frame to video file
    if recording:
        video_writer.write(frame)
        elapsed_time = time.time() - start_time
        
        # Stop recording after duration
        if elapsed_time >= video_duration:
            recording = False
            video_writer.release()
            print(f"Saved video: {video_path}")

    key = cv2.waitKey(1) & 0xFF

    # Start recording when 'r' is pressed
    if key == ord("r") and not recording:
        label_dir = os.path.join(dataset_path, selected_label)
        if not os.path.exists(label_dir):
            os.makedirs(label_dir)

        timestamp = int(time.time())
        video_path = os.path.join(label_dir, f"{selected_label}_{timestamp}.mp4")
        
        # Initialize video writer
        frame_height, frame_width = frame.shape[:2]
        video_writer = cv2.VideoWriter(video_path, fourcc, fps, (frame_width, frame_height))
        
        recording = True
        start_time = time.time()
        print(f"Recording started for {selected_label}...")

    # Switch labels with 'n'
    elif key == ord("n") and not recording:
        label_index = (label_index + 1) % len(labels)
        selected_label = labels[label_index]
        print(f"Switched to label: {selected_label}")

    # Quit with 'q'
    elif key == ord("q") and not recording:
        break

# Cleanup
if video_writer is not None:
    video_writer.release()
cap.release()
cv2.destroyAllWindows()
