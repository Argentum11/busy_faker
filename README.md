# Busy Faker
<img src="assets/icons/app_icon.png" width="100" height="100" alt="App Icon">

## Description
A mobile app that helps you create fake phone calls to avoid social interactions or appear busy in various situations.

## Screenshots
<div style="display: flex; justify-content: space-between;">
  <img src=".github/readme_images/select_timer.jpg" width="200" height="400" alt="Timer Selection">
  <img src=".github/readme_images/select_caller.jpg" width="200" height="400" alt="Caller Selection">
  <img src=".github/readme_images/select_theme.jpg" width="200" height="400" alt="Theme Selection">
  <img src=".github/readme_images/phone_call.jpg" width="200" height="400" alt="Incoming Call">
  <img src=".github/readme_images/in_call.jpg" width="200" height="400" alt="In Call Screen">
</div>

## Features
- Customizable phone call countdown timer
- Multiple caller profiles
- Themed call interfaces
- AI-powered call scenario generation

## Prerequisites
- Flutter SDK
- Dart SDK
- OpenAI API key

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/Argentum11/busy_faker
cd busy-faker
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure API Key
1. Copy the API key template:
```bash
cp lib/services/ChatGPT/api_key_template.dart lib/services/ChatGPT/api_key.dart
```
2. Add your OpenAI API key in `lib/services/ChatGPT/api_key.dart`

### 4. Hive Code Generation
For Hive-annotated classes, regenerate .g.dart files:
```bash
dart run build_runner build
```

To clean and rebuild:
```bash
dart run build_runner clean
dart run build_runner build
```

## Development

### Running the App
```bash
flutter run
```

### Testing
```bash
flutter test
```

## Project Structure
```
lib/
├── main.dart
├── models/
├── services/
│   └── ChatGPT/
└── pages/
```

## Technologies Used
- Flutter
- Dart
- Hive
- OpenAI GPT API