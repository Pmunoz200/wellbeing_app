<h3 align="center">Project Vitalis - Repository Overview</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)](https://github.com/Pmunoz200/wellbeing_app)

</div>

---

<p align="center">
  Vitalis is a comprehensive project designed to revolutionize personal health management by seamlessly integrating food, exercise, and other wellbeing aspects, <b>powered by Google's Gemini AI</b>. This repository includes both the client-side application and the server-side components, working in unison to deliver personalized health insights, streamline health tracking, and ensure secure data management.
  <br>
</p>

## 📝 Table of Contents

- [📝 Table of Contents](#-table-of-contents)
- [📖 Introduction ](#-introduction-)
- [📂 Repository Structure ](#-repository-structure-)
- [🏁 Getting Started ](#-getting-started-)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [🚀 App Features ](#-app-features-)
- [🛠 Technology Stack ](#-technology-stack-)
- [🚧 Limitations and Future Work ](#-limitations-and-future-work-)
- [🤝 Contributing ](#-contributing-)
- [✍️ Authors ](#️-authors-)

## 📖 Introduction <a name = "introduction"></a>

**Project Vitalis** is an innovative health-focused mobile application designed to assist users in achieving their wellness goals by improving their eating and exercise habits, with future expansion into other areas of wellbeing. Powered by Gemini, Google’s cutting-edge multi-modal AI, the app offers a holistic approach to health management by combining various aspects of wellbeing into a unified platform.

The app’s core functionality revolves around personalized health recommendations and seamless data logging. By utilizing multi-modal inputs (video, audio, text), the app makes tracking health activities effortless and accurate. With its focus on simplicity and comprehensive integration, Vitalis is poised to become an essential tool for anyone looking to enhance their health and wellness journey.

## 📂 Repository Structure <a name = "repository_structure"></a>

The repository is organized into the following main directories:

- **/client**: Contains the Flutter application code for the mobile client.
- **/server**: Contains the server-side code responsible for backend processing, AI communication, and data management.
- **/docs**: Documentation and guides related to the project.
- **/assets**: Shared assets such as images, icons, and styles used across the project.

## 🏁 Getting Started <a name = "getting_started"></a>

To set up the project locally, follow the instructions provided in the client and server-side README files located in their respective directories.

### Prerequisites

- **Flutter SDK**: For building and running the client-side application.
- **Node.js**: For setting up and deploying the server-side functions.
- **Firebase Account**: Required for setting up Firebase services and deploying cloud functions.
- **Git**: Version control to manage the project’s source code.

### Installation

1. **Clone the repository**:
```
   git clone https://github.com/yourusername/vitalis.git
```
2. **Set up the client-side**:

   Navigate to the `/client` directory and follow the installation instructions in the client README.

3. **Set up the server-side**:

   Navigate to the `/server` directory and follow the installation instructions in the server README.

4. **Configure Firebase**:

   Set up Firebase for both the client and server following the detailed steps in each README.

## 🚀 App Features <a name = "app_features"></a>

### **Multi-Modal Logging**
- Users can log data through video, audio, and text inputs, leveraging Gemini's advanced multi-modal capabilities. This feature simplifies the process of tracking food intake and exercise activities, reducing manual input errors and saving time.

### **Personalized Suggestions**
- The app offers customized recommendations tailored to individual goals and preferences. Whether it’s suggesting a 400-calorie dinner to meet daily nutritional targets or recommending a workout routine to align with fitness goals, the app delivers precise and actionable insights.

### **Minimal Input**
- The user interface is designed for simplicity, making health management intuitive and stress-free. The app minimizes the need for complex manual inputs, ensuring that users can focus on their wellbeing rather than data entry.

### **All-in-One Solution**
- Vitalis integrates food, exercise, and other wellbeing features into a single platform. This all-in-one solution ensures that users have everything they need for comprehensive health management without the need for multiple separate applications.

### **Enhanced Accuracy**
- By harnessing the power of Gemini, the app ensures more accurate data logging for both food and exercise activities. This feature is particularly beneficial for users who struggle with estimating portion sizes or exercise intensity.

### **Future Focus Areas**
- The app will expand to include habit tracking, meditation, and sleep management features, further enhancing its holistic approach to health and wellness.

## 🛠 Technology Stack <a name = "technology_stack"></a>

The technology stack used in Project Vitalis includes:

- **Flutter**: A UI toolkit from Google that enables the development of natively compiled applications for mobile, web, and desktop from a single codebase. Flutter powers the client-side of the Vitalis app, ensuring a smooth and responsive user interface.

- **Firebase Authentication**: A robust and secure authentication system from Google, used to manage user sign-in, sign-up, and authentication processes in the app. This ensures that user data is protected and accessible only to authorized users.

- **Firebase Firestore Database**: A flexible, scalable database for mobile, web, and server development from Firebase. Firestore is used to store and sync user data in real-time, making it integral to the backend of the app for managing health logs, user profiles, and personalized recommendations.

- **Firebase Functions**: A serverless framework from Firebase that allows the backend code to be deployed and executed in response to events, automatically scaling up as needed. It handles the backend processing and communication with Gemini AI.

- **Gemini (Google AI)**: Gemini is Google’s state-of-the-art multi-modal AI model that powers the app’s core functionalities. It enables the app to process and understand various forms of input (text, video, audio), providing personalized and accurate health recommendations and improving the overall user experience.

## 🚧 Limitations and Future Work <a name = "limitations-and-future-work"></a>

### **Limitations**
- **Text-Only Logging**: Currently, the server only supports logging with text. However, the app is designed to easily incorporate other input methods like video and audio in the future.
- **Local Server Deployment**: The server is not deployed online and is intended for local use only due to budget constraints, particularly involving the deployment and subscription to Gemini's API.
- **Limited Features**: At this stage, only exercise and food tracking are available. Other aspects of health management are not yet implemented.

### **Future Work**
- **Multi-Modal Logging**: Expand the server to support logging via video, audio, and other input methods to fully leverage the multi-modal capabilities of Gemini.
- **Full Deployment**: Plan to deploy the server online, including a subscription to Gemini’s API to make the app fully operational and accessible to a broader audience.
- **Comprehensive Health Features**: Future development will focus on creating a complete all-in-one holistic health app that covers all aspects of wellbeing, beyond just exercise and food.

## 🤝 Contributing <a name = "contributing"></a>

Contributions to Project Vitalis are welcome! Whether it's improving documentation, fixing bugs, or adding new features, your input is highly valued. Please fork the repository, create a new branch, and submit a pull request with your proposed changes. For major changes, it's recommended to open an issue first to discuss the proposed updates.

## ✍️ Authors <a name = "authors"></a>

- **Juan José Jaramillo Botero** - [@JuanJoseJ](https://github.com/JuanJoseJ)
- **Pablo Muñoz** - [@Pmunoz200](https://github.com/Pmunoz200)
- **Manuel Escobar Ferrer** - [@manuelescobar-dev](https://github.com/manuelescobar-dev)
