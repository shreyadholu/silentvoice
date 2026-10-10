import os
import numpy as np
import cv2
from tensorflow.keras.models import Sequential # type: ignore
from tensorflow.keras.layers import TimeDistributed, Conv2D, MaxPooling2D, Flatten, LSTM, Dense # type: ignore
from sklearn.model_selection import train_test_split # type: ignore

# Settings
DATASET_DIR = 'SignFrames'
IMG_SIZE = (64, 64)
FRAMES_PER_VIDEO = 30  # or less based on your dataset

def load_dataset():
    X, y = [], []
    class_names = sorted(os.listdir(DATASET_DIR))
    label_map = {label: idx for idx, label in enumerate(class_names)}

    for label in class_names:
        folder_path = os.path.join(DATASET_DIR, label)
        frames = sorted(os.listdir(folder_path))[:FRAMES_PER_VIDEO]
        video = []
        for frame_file in frames:
            img_path = os.path.join(folder_path, frame_file)
            img = cv2.imread(img_path)
            img = cv2.resize(img, IMG_SIZE)
            video.append(img / 255.0)
        
        if len(video) == FRAMES_PER_VIDEO:  # Ensure consistent input size
            X.append(video)
            y.append(label_map[label])
    
    return np.array(X), np.array(y), class_names

X, y, class_names = load_dataset()

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Model
model = Sequential([
    TimeDistributed(Conv2D(32, (3,3), activation='relu'), input_shape=(FRAMES_PER_VIDEO, *IMG_SIZE, 3)),
    TimeDistributed(MaxPooling2D(2, 2)),
    TimeDistributed(Flatten()),
    LSTM(64),
    Dense(64, activation='relu'),
    Dense(len(class_names), activation='softmax')
])

model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
model.summary()

# Train
model.fit(X_train, y_train, epochs=20, validation_data=(X_test, y_test))

# Save the model
model.save('sign_interpreter_model.h5')
