// models/medication.dart
// This file defines the Medication model class which represents a medication reminder
// It contains all the data structure needed to store and manage medication information

class Medication {
  // Unique identifier for the medication
  // This is used to identify each medication for updating and deleting
  final String id;

  // Name of the medication (e.g., "Aspirin", "Vitamin D")
  final String name;

  // Dosage information (e.g., "1 pill", "5ml", etc.)
  // This tells the user how much medication to take
  final String dosage;

  // List of reminder times
  final List<DateTime> reminderTimes;

  // Additional notes
  final String notes;

  // Constructor to create a new Medication object
  // The 'required' keyword means these parameters must be provided
  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.reminderTimes,
    required this.notes,
  });

  // Convert a map to a Medication object
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as String,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      reminderTimes: (map['reminderTimes'] as List<dynamic>)
          .map((time) => DateTime.parse(time as String))
          .toList(),
      notes: map['notes'] as String,
    );
  }

  // Convert a Medication object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'reminderTimes':
          reminderTimes.map((time) => time.toIso8601String()).toList(),
      'notes': notes,
    };
  }

  // Create a copy of the Medication object with updated fields
  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    List<DateTime>? reminderTimes,
    String? notes,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      notes: notes ?? this.notes,
    );
  }
}
