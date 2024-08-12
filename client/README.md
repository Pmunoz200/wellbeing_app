<h3 align="center">Project Vitalis</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)](https://github.com/Pmunoz200/wellbeing_app)

</div>

---

## 📝 Table of Contents

- [About the Project](#about)
- [Features](#features)
- [Dependencies](#dependencies)
- [Limitations](#limitations)
- [Future Scope](#future_scope)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Technology Stack](#tech_stack)
- [Contributing](#contributing)
- [Authors](#authors)
- [Acknowledgments](#acknowledgments)

## ✨ Features <a name = "features"></a>

- **User Enrollment**: New users go through an enrollment process on their first login, where they answer personal questions such as age, weight, exercise routines, eating preferences, and available exercise spaces.
- **Personalized Communication**: Based on the collected data, the app establishes a tailored communication process using Gemini AI to provide customized health recommendations.
- **Daily Chat Interactions**: Each day, users start a new chat with the AI, which also considers the information from previous interactions to offer more relevant advice.
- **User Data Management**: Users can manage and update their personal data to refine the recommendations and insights provided by the AI.
- **Secure Authentication**: Login and authentication are handled securely through Google and Firebase.
- **Data Sync**: User data is automatically synced with Firebase Firestore, ensuring that all information is up-to-date and accessible across devices.
- **In-App Media Capture**: Capture and upload images and audio directly within the app for tracking progress and sharing updates.
- **Intuitive Interface**: The app features a responsive and user-friendly design, making it easy to navigate and interact with the AI.

## ⛓️ Dependencies <a name = "dependencies"></a>

This project relies on the following Flutter and Dart packages:

- `firebase_auth`: For user authentication via Firebase.
- `firebase_core`: Core functionalities for Firebase.
- `google_sign_in`: Google Sign-In integration.
- `cloud_firestore`: Firestore for data storage.
- `flutter_sound`: To capture and play audio files.
- `permission_handler`: To manage access permissions to media.
- `fluttertoast`: To display toast messages.
- `image_picker`: To capture or select images from the gallery.
- `provider`: State management.
- `carousel_slider`: To create image carousels.
- `intl`: Internationalization support.
- `drop_cap_text`: To style text with drop caps.

## 🚧 Limitations <a name = "limitations"></a>

- **Internet Dependency**: The app relies on an internet connection for most functionalities, including real-time data synchronization and communication with the AI. Offline usage is limited and may not support all features.
- **Data Storage Constraints**: The current implementation utilizes Firebase's free tier, which has restrictions on storage capacity and database operations. Users with extensive data needs may encounter limitations related to storage and performance.
- **Privacy and Data Security**: While Firebase provides secure data handling, users must be aware of the privacy implications of storing personal health data in the cloud.
- **Initial Enrollment Complexity**: The initial data collection during the enrollment process might be seen as intrusive by some users, potentially affecting user experience and adoption.

## 🚀 Future Scope <a name = "future_scope"></a>

Planned improvements and future developments:

- **Expanded Data Tracking**: Introduce tracking for additional health metrics, such as sleep patterns and hydration levels, to provide a more comprehensive health profile.
- **Integration with Wearables**: Allow integration with wearable devices to automatically sync exercise data, heart rate, and other vital statistics.
- **Offline Functionality**: Improve the offline mode, enabling users to interact with the AI and track their progress even without an internet connection, with automatic syncing once reconnected.
- **Audio and Video Support**: Add support for audio and video content, allowing users to record and review exercise sessions and food, and receive AI-generated feedback.
- **Localization and Accessibility**: Expand language support and improve accessibility features to make the app usable by a broader audience.
- **Customizable Notifications**: Implement a more advanced notification system that allows users to customize reminders and updates based on their personal preferences.

## 🏁 Getting Started <a name = "getting_started"></a>

These instructions will help you set up the project on your local machine for development and testing purposes.

### Prerequisites

- **Flutter SDK**: Version 3.3.3 or higher. Make sure Flutter is properly installed and added to your system path.
- **Android Studio/VS Code**: Preferred Integrated Development Environments (IDEs) for Flutter development. Ensure that the Flutter and Dart plugins are installed.
- **Firebase Account**: Required to set up Firebase services like authentication, Firestore, and cloud storage for the project.
- **Git**: Version control system to clone the repository and manage project versions.

### Installing

1. **Clone the repository**:

```
 git clone https://github.com/yourusername/gemini_folder.git
```

2. **Navigate to the project directory**:

```
   cd gemini_folder
```

3. **Install dependencies**:

```
   flutter pub get
```

4. **Configure Firebase**:

   - Create a project in Firebase and configure it for your application (Android, iOS).
   - Download the `google-services.json` file (for Android) or `GoogleService-Info.plist` file (for iOS) and place it in the appropriate directory.

5. **Run the project**:

   flutter run

## 🎈 Usage <a name="usage"></a>

Once installed, you can use the app to:

- **Log in** using Google authentication to securely access your personalized health dashboard.
- **Complete Enrollment** by providing initial information such as age, weight, exercise routines, and dietary preferences.
- **Engage in Daily Chats** with the Gemini AI to receive tailored health advice and track your progress over time.
- **Track and update your data** as you progress on your health journey, with the AI adapting its recommendations based on your latest inputs.
- **Sync your data** with the cloud to ensure it’s accessible across all your devices and safely stored.
- **Review insights and analytics** provided by the AI to understand trends in your health habits and identify areas for improvement.
