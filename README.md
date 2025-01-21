# Busy faker

<img src="assets/icons/app_icon.png" width="100" height="100" alt="App Icon">

A new Flutter project

## Getting Started

### Install packages

```bash
flutter pub get
```

### GPT API key

1. Copy the file

```bash
cp lib/services/ChatGPT/api_key_template.dart lib/services/ChatGPT/api_key.dart
```

2. Enter your GPT API key in lib/api_key.dart

### Hive

If you make changes to the Hive-annotated classes, or when pulling changes that affect these classes, you must regenerate the .g.dart files. Run the following command:

```bash
dart run build_runner build
```

To clean any stale build outputs before regenerating, you can use:

```bash
dart run build_runner clean
dart run build_runner build
```
