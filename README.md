# Task Manager App

A real-world Flutter task management app with a focus on clean architecture, excellent UI/UX, and reliable local persistence.

## Current status

- Project scaffold is in place (demo code removed from `lib/main.dart`).
- UI shell placeholder is implemented so the app runs cleanly before adding the full Task CRUD + persistence.

## Planned features

- Task CRUD with dependency logic (blocked tasks)
- Search + status filtering (with debounced search)
- Local persistence using Hive
- State management using Riverpod

## Tech Stack

- Flutter
- Material 3
- Riverpod (to be added next)
- Hive (to be added next)
- Intl, uuid (to be added next)

## Getting Started

1. Install Flutter SDK
2. From this project directory, run:
   - `flutter pub get`
   - `flutter run`

## Project Structure

The code will be organized into the following layers:

- `lib/models/`
- `lib/services/`
- `lib/providers/`
- `lib/screens/`
- `lib/widgets/`
- `lib/utils/`
