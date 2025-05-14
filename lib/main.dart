// main.dart
// This is the entry point of the medical reminder app
// This file sets up the application theme and initializes the app

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // Ensure Flutter is initialized before running the app
  // This is important for plugins that need to access platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app by passing the root widget to runApp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Constructor with key parameter for widget identification
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title - appears in task switchers and app management screens
      title: 'Medical Reminder',

      // App theme configuration - defines colors and visual properties
      theme: ThemeData(
        // Primary color for the app - used in app bars, buttons, etc.
        primarySwatch: Colors.blue,

        // Use Material 3 design for modern UI components
        useMaterial3: true,

        // Define app color scheme based on a seed color
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),

      // Dark theme configuration - used when device is in dark mode
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      // Use system theme mode (light/dark) based on device settings
      themeMode: ThemeMode.system,

      // Disable debug banner that appears in the top-right corner during development
      debugShowCheckedModeBanner: false,

      // Set home screen as the initial screen of the app
      home: HomeScreen(), // Remove 'const' here
    );
  }
}
