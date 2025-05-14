# How to Use the Medical Reminder App

This guide will help you understand how to use the Medical Reminder App for your college project.

## Getting Started

1. **Extract the ZIP file**: Unzip the `medical_reminder_app.zip` file to a location on your computer.

2. **Open in an IDE**: Open the extracted folder in an IDE like Visual Studio Code or Android Studio.

3. **Install dependencies**: Run `flutter pub get` in the terminal to install all required dependencies.

4. **Run the app**: Connect a device or start an emulator, then run `flutter run` to start the app.

## Using the App

### Adding a Medication

1. Tap the "+" button in the bottom right corner or the "Add Medication" button on the empty state screen.
2. Enter the medication name and dosage (both required).
3. Set the reminder time(s) by tapping the clock icon.
4. Add additional reminder times if needed by tapping "Add Another Reminder Time".
5. Optionally add notes about the medication.
6. Tap "Add Medication" to save.

### Editing a Medication

1. Tap the edit (pencil) icon on any medication card.
2. Modify any details as needed.
3. Tap "Update Medication" to save changes.

### Deleting a Medication

1. Tap the delete (trash) icon on any medication card.
2. The medication will be removed immediately.

## App Structure Explanation

The app is organized into several key components:

1. **Models**: Define the data structure for medications
2. **Services**: Handle data management, storage, and notifications
3. **Screens**: Provide the user interface for interacting with the app
4. **Widgets**: Reusable UI components used across screens

## Code Explanation

All code is thoroughly documented with comments explaining what each part does. Here's a brief overview:

- **Medication Model**: Defines what information is stored for each medication
- **Storage Service**: Handles saving and loading data from the device
- **Notification Service**: Manages scheduling reminders
- **Home Screen**: Shows the list of medications
- **Medication Form**: Allows adding and editing medications

## Customizing the App

If you want to customize the app for your college project:

1. **Change the app theme**: Modify the colors in `main.dart`
2. **Add new features**: Create new screens or widgets as needed
3. **Modify the UI**: Adjust the layout and design in the screen files

## Troubleshooting

- If notifications aren't working, check that permissions are granted on your device
- If the app crashes, check the console output for error messages
- For any Flutter-specific issues, refer to the Flutter documentation

I hope this helps you with your college project! The app is designed to be simple yet functional, with clean code that's easy to understand even without coding experience.
