# Medical Reminder App

A simple Flutter application for setting and managing medication reminders. This app allows users to add, edit, and delete medication reminders with multiple reminder times per medication.

## Features

- Add medications with name, dosage, and notes
- Set multiple reminder times for each medication
- Edit existing medications
- Delete medications
- Receive notifications for medication reminders
- Data persistence to save medications between app sessions
- Clean, user-friendly interface

## App Structure

The app is organized into the following directories:

- `lib/models`: Contains the data models for the app
- `lib/screens`: Contains the UI screens
- `lib/services`: Contains services for data management and notifications
- `lib/widgets`: Contains reusable UI components

### Key Files

- `lib/main.dart`: Entry point of the application
- `lib/models/medication.dart`: Defines the Medication data model
- `lib/services/medication_service.dart`: Manages medication data
- `lib/services/notification_service.dart`: Handles scheduling notifications
- `lib/services/storage_service.dart`: Handles data persistence
- `lib/screens/home_screen.dart`: Main screen showing the list of medications
- `lib/screens/medication_form_screen.dart`: Form for adding/editing medications

## How to Run the App

1. Make sure you have Flutter installed on your development machine
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Connect a device or start an emulator
5. Run `flutter run` to start the app

## Dependencies

- `shared_preferences`: For storing medication data
- `flutter_local_notifications`: For scheduling medication reminders
- `timezone`: For handling time zones in notifications
- `uuid`: For generating unique IDs for medications

## Code Documentation

All code is thoroughly documented with comments explaining what each part does. This makes it easy to understand how the app works, even without prior coding experience.

## Future Improvements

Potential improvements for the app include:

- Adding user authentication
- Syncing data across devices
- Adding medication categories
- Adding a calendar view for reminders
- Adding medication history tracking
- Adding refill reminders
