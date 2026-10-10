import cv2
import os

def extract_frames(video_path, output_folder, frame_size=(64, 64)):
    cap = cv2.VideoCapture(video_path)
    frame_count = 0

    os.makedirs(output_folder, exist_ok=True)

    while True:
        ret, frame = cap.read()
        if not ret:
            break
        # Resize frame (optional)
        frame = cv2.resize(frame, frame_size)
        frame_path = os.path.join(output_folder, f"frame_{frame_count:04d}.jpg")
        cv2.imwrite(frame_path, frame)
        frame_count += 1

    cap.release()
    print(f"✅ Extracted {frame_count} frames from {video_path}")

def process_dataset(input_root='SignDataset', output_root='SignFrames'):
    for sign_name in os.listdir(input_root):
        sign_path = os.path.join(input_root, sign_name)
        if os.path.isdir(sign_path):
            # There should be only one video file in each sign folder
            video_files = [f for f in os.listdir(sign_path) if f.endswith(('.mp4', '.mov', '.avi'))]
            if video_files:
                video_path = os.path.join(sign_path, video_files[0])
                output_path = os.path.join(output_root, sign_name)
                extract_frames(video_path, output_path)

if __name__ == "__main__":
    process_dataset()
