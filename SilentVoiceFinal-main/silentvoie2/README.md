<div align="center">

# SilentVoice

### Breaking communication barriers through sign language technology.

A Flutter-based mobile application that combines sign-language learning resources, a sign dictionary, and camera-based sign recognition.

![Flutter](https://img.shields.io/badge/Flutter-Mobile%20App-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Language-Dart-0175C2?logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3FCF8E?logo=supabase&logoColor=white)
![TensorFlow Lite](https://img.shields.io/badge/ML-TensorFlow%20Lite-FF6F00?logo=tensorflow&logoColor=white)

</div>

---

## About

**SilentVoice** is a mobile application built with Flutter to support sign-language learning and recognition. It brings learning content and a sign dictionary together with a camera-based interpreter that uses a TensorFlow Lite model to recognize supported signs.

The project explores how mobile development and on-device machine learning can help make sign-language tools more accessible.

## Features

- **Sign Dictionary** — browse supported signs and their associated meanings.
- **Learning Modules** — access screens designed to help users learn sign language.
- **Live Sign Recognition** — use the device camera to recognize signs supported by the model.
- **Authentication** — login and sign-up screens integrated with Supabase authentication/session handling.
- **Settings and Personalization** — access app settings and available preferences.

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile app framework |
| Dart | Application programming language |
| Supabase | Authentication/session integration |
| TensorFlow Lite | On-device sign-recognition model inference |
| Camera plugin | Camera access for live recognition |
| SharedPreferences | Local preference storage, where used |
| ML Kit / image-processing utilities | Image-processing support, where used by the implementation |

## How Sign Recognition Works

The app's interpreter uses a camera feed and a TensorFlow Lite model to classify supported signs.

```text
Camera Input
     |
     v
Image / Frame Processing
     |
     v
TensorFlow Lite Model
     |
     v
Predicted Class Label
     |
     v
Recognition Result in the App
```

This is a high-level overview. Exact preprocessing and inference steps depend on the interpreter code and model.

## Project Structure

```text
silentvoice/
├── android/                  # Android platform files
├── ios/                      # iOS platform files, if configured
├── lib/
│   ├── main.dart              # App entry point and startup flow
│   ├── homepage.dart          # Main dashboard and navigation
│   ├── sign_interpreter.dart  # Camera-based sign recognition
│   ├── sign_dict.dart         # Sign dictionary
│   ├── sign_learning.dart     # Learning screens
│   ├── login.dart             # Login screen
│   └── signup.dart            # Sign-up screen
├── assets/
│   ├── sign_model.tflite      # Sign-recognition model
│   └── labels.txt             # Model class labels
├── test/                      # Tests
├── pubspec.yaml               # Dependencies and asset configuration
└── README.md
```

> File names and folders reflect the project layout described for this README. Adjust the tree if your repository uses different names or locations.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio) or another configured Flutter development environment
- An Android device or emulator
- A Supabase project if you want to use the authentication integration

A physical device with camera access is recommended for testing live sign recognition.

### Installation

1. **Clone the repository**

   ```bash
   git clone <your-repository-url>
   ```

2. **Move into the project directory**

   ```bash
   cd <your-project-folder>
   ```

3. **Install Flutter dependencies**

   ```bash
   flutter pub get
   ```

4. **Check your Flutter environment**

   ```bash
   flutter doctor
   ```

5. **Run the app**

   ```bash
   flutter run
   ```

To see available devices before running:

```bash
flutter devices
flutter run -d <device_id>
```

Replace `<your-repository-url>` and `<your-project-folder>` with the actual repository URL and directory name.

## Configuration

### Supabase

The current implementation has been described as initializing Supabase with a URL and anon key in `lib/main.dart`.

- Use the correct Supabase project URL and anon key for your own project.
- Never commit service-role keys or other privileged secrets.
- Configure appropriate Supabase Row Level Security (RLS) policies for tables exposed to the client.
- For a public repository, consider moving configuration out of source code using an appropriate configuration method. A client-side anon key is not a substitute for database access policies.

### Sign-Recognition Model

Check that the model and label file are present at the paths expected by the app:

```text
assets/sign_model.tflite
assets/labels.txt
```

Confirm that these assets are declared under `flutter: assets:` in `pubspec.yaml`. The model's input shape, preprocessing, output format, and label order must match the inference code.

## Limitations

- Recognition is limited to the signs and classes represented by the trained model.
- Accuracy can vary with lighting, camera position, background, and signing variations.
- A successful build depends on compatible Flutter and plugin versions and correct native Android/iOS configuration.
- Platform support should be considered verified only after testing on that platform.

## Future Improvements

- Add screenshots and a short demonstration video.
- Expand the sign dictionary and learning content.
- Evaluate recognition accuracy across varied real-world conditions.
- Improve setup documentation and add automated tests.

## License

No license has been specified yet. Unless a license is added to the repository, others should not assume they have permission to reuse, modify, or distribute the project.

## Disclaimer

SilentVoice is an educational/prototype project. It is not a substitute for a qualified sign-language interpreter, and its recognition output may be incorrect.
