// services/medication_service.dart
// This file provides services for managing medication reminders with improved persistence
// It handles loading, saving, adding, updating, and deleting medications

import 'dart:convert';
import '../models/medication.dart';
import 'storage_service.dart';

class MedicationService {
  // Key for storing medications in SharedPreferences
  // This is used as the identifier in the local storage
  static const String _storageKey = 'medications';

  // List to store all medications in memory for quick access
  List<Medication> _medications = [
    Medication(
      id: '1',
      name: 'Paracetamol',
      dosage: '500mg',
      reminderTimes: [
        DateTime.now().add(Duration(hours: 1)), // Example reminder time
        DateTime.now().add(Duration(hours: 5)),
      ],
      notes: 'Take after meals',
    ),
    Medication(
      id: '2',
      name: 'Ibuprofen',
      dosage: '200mg',
      reminderTimes: [
        DateTime.now().add(Duration(hours: 2)), // Example reminder time
        DateTime.now().add(Duration(hours: 6)),
      ],
      notes: 'Take with water',
    ),
  ];

  // Storage service for data persistence
  // This handles the actual saving and loading from device storage
  final _storageService = StorageService();

  // Getter to access the medications list from outside the class
  // This provides read-only access to the medications
  List<Medication> get medications => _medications;

  // Load medications from storage when the app starts
  // This retrieves previously saved medications from the device
  Future<void> loadMedications() async {
    try {
      final medicationsJson = await _storageService.loadData(_storageKey);

      if (medicationsJson != null) {
        // Convert the JSON string back to a list of Medication objects
        final List<dynamic> decodedList = jsonDecode(medicationsJson);
        _medications =
            decodedList.map((item) => Medication.fromMap(item)).toList();
      }
    } catch (e) {
      // Initialize with empty list if there's an error
      // This ensures the app doesn't crash if storage is corrupted
      _medications = [];
    }
  }

  // Save medications to storage
  // This persists the current list of medications to the device
  Future<void> saveMedications() async {
    try {
      // Convert the list of Medication objects to a JSON string
      final medicationsJson =
          jsonEncode(_medications.map((med) => med.toMap()).toList());
      await _storageService.saveData(_storageKey, medicationsJson);
    } catch (e) {
      // Handle error silently to prevent app crashes
      // In a production app, you might want to log this error
    }
  }

  // Add a new medication to the list and save it
  Future<void> addMedication(Medication medication) async {
    _medications.add(medication);
    await saveMedications();
  }

  // Update an existing medication in the list and save changes
  Future<void> updateMedication(Medication updatedMedication) async {
    // Find the medication with the matching ID
    final index =
        _medications.indexWhere((med) => med.id == updatedMedication.id);
    if (index != -1) {
      // Replace the old medication with the updated one
      _medications[index] = updatedMedication;
      await saveMedications();
    }
  }

  // Delete a medication from the list and save changes
  Future<void> deleteMedication(String id) async {
    _medications.removeWhere((med) => med.id == id);
    await saveMedications();
  }

  // Get a specific medication by its ID
  Medication? getMedicationById(String id) {
    try {
      return _medications.firstWhere((med) => med.id == id);
    } catch (e) {
      // Return null if the medication is not found
      return null;
    }
  }

  // Get medications sorted by next reminder time
  // This is useful for displaying medications in order of upcoming reminders
  List<Medication> getMedicationsSortedByNextReminder() {
    final now = DateTime.now();
    final sortedMeds = List<Medication>.from(_medications);

    // Sort by the next upcoming reminder time
    sortedMeds.sort((a, b) {
      // Find the next reminder time for medication A that is after now
      final aNextTime = a.reminderTimes
          .where((time) =>
              DateTime(now.year, now.month, now.day, time.hour, time.minute)
                  .isAfter(now))
          .fold<DateTime?>(
              null,
              (prev, time) => prev == null ||
                      DateTime(now.year, now.month, now.day, time.hour,
                              time.minute)
                          .isBefore(prev)
                  ? DateTime(
                      now.year, now.month, now.day, time.hour, time.minute)
                  : prev);

      // Find the next reminder time for medication B that is after now
      final bNextTime = b.reminderTimes
          .where((time) =>
              DateTime(now.year, now.month, now.day, time.hour, time.minute)
                  .isAfter(now))
          .fold<DateTime?>(
              null,
              (prev, time) => prev == null ||
                      DateTime(now.year, now.month, now.day, time.hour,
                              time.minute)
                          .isBefore(prev)
                  ? DateTime(
                      now.year, now.month, now.day, time.hour, time.minute)
                  : prev);

      // If no upcoming reminders today, use the first reminder time
      final aTime = aNextTime ??
          DateTime(now.year, now.month, now.day, a.reminderTimes.first.hour,
              a.reminderTimes.first.minute);
      final bTime = bNextTime ??
          DateTime(now.year, now.month, now.day, b.reminderTimes.first.hour,
              b.reminderTimes.first.minute);

      // Compare the times to determine the sort order
      return aTime.compareTo(bTime);
    });

    return sortedMeds;
  }

  // Fetch all medications
  Future<List<Medication>> getMedications() async {
    // Simulate a delay to mimic a database or API call
    await Future.delayed(Duration(seconds: 1));
    return _medications;
  }
}
