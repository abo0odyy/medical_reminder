// screens/home_screen.dart
// This file contains the main home screen of the medical reminder app
// This is the first screen users see when opening the app

import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../services/medication_service.dart';
import '../services/notification_service.dart';
import 'medication_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  final MedicationService _medicationService = MedicationService();

  bool _permissionsGranted = false; // Track if permissions are granted
  List<Medication> _medications = []; // List of medications

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _notificationService.initialize();
  }

  Future<void> _initializeApp() async {
    // Request permissions on app start
    await _notificationService.requestPermissions();
    setState(() {
      _permissionsGranted = true; // Update state after permissions are granted
    });

    // Load medications after permissions are granted
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    // Load medications from the service
    final medications = await _medicationService.getMedications();
    setState(() {
      _medications = medications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Reminder'),
      ),
      body: _permissionsGranted
          ? _buildMainContent() // Show main content if permissions are granted
          : Center(
              child:
                  CircularProgressIndicator(), // Show a loading indicator while waiting for permissions
            ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _medications.length,
            itemBuilder: (context, index) {
              final medication = _medications[index];
              return ListTile(
                title: Text(medication.name),
                subtitle: Text('Dosage: ${medication.dosage}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to the medication form screen to edit
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicationFormScreen(
                          medication: medication,
                        ),
                      ),
                    ).then((_) =>
                        _loadMedications()); // Reload medications after editing
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the medication form screen to add a new medication
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicationFormScreen(),
                ),
              ).then(
                  (_) => _loadMedications()); // Reload medications after adding
            },
            child: Text('Add Medication'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              await _notificationService.pickRingtone();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ringtone selected successfully!')),
              );
            },
            child: Text('Choose Ringtone'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              await _notificationService.scheduleNotification(
                id: 1,
                title: 'Medication Reminder',
                body: 'Time to take your medication!',
                scheduledDate: DateTime.now().add(Duration(seconds: 10)),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notification scheduled!')),
              );
            },
            child: Text('Schedule Notification'),
          ),
        ),
      ],
    );
  }
}
