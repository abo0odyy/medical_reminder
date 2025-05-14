// screens/medication_form_screen.dart
// This file contains the form for adding or editing medication reminders
// It allows users to input medication details and set reminder times

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/medication.dart';

class MedicationFormScreen extends StatefulWidget {
  // Optional medication for editing (null for adding new)
  // If provided, the form will be pre-filled with this medication's data
  final Medication? medication;

  // Constructor with key parameter for widget identification
  const MedicationFormScreen({super.key, this.medication});

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends State<MedicationFormScreen> {
  // Form key for validation - used to check if form inputs are valid
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers for the form fields - manage the text input
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();
  
  // List of reminder times for this medication
  List<DateTime> _reminderTimes = [];
  
  // UUID generator for creating unique IDs for new medications
  final _uuid = Uuid();
  
  // Flag to determine if we're editing an existing medication or adding a new one
  bool get _isEditing => widget.medication != null;

  @override
  void initState() {
    super.initState();
    
    // If editing, populate form with existing medication data
    if (_isEditing) {
      _nameController.text = widget.medication!.name;
      _dosageController.text = widget.medication!.dosage;
      _notesController.text = widget.medication!.notes;
      _reminderTimes = List.from(widget.medication!.reminderTimes);
    } else {
      // Add a default reminder time for new medications (8:00 AM)
      _reminderTimes.add(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        8, // 8:00 AM default
        0,
      ));
    }
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    // This prevents memory leaks
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Add a new reminder time
  // This is called when the user taps "Add Another Reminder Time"
  void _addReminderTime() {
    setState(() {
      // Add a new time 1 hour after the last one
      final lastTime = _reminderTimes.last;
      _reminderTimes.add(
        DateTime(
          lastTime.year,
          lastTime.month,
          lastTime.day,
          (lastTime.hour + 1) % 24, // Wrap around to 0 if hour would be 24
          lastTime.minute,
        ),
      );
    });
  }

  // Remove a reminder time
  // This is called when the user taps the delete button on a reminder time
  void _removeReminderTime(int index) {
    setState(() {
      if (_reminderTimes.length > 1) {
        // Remove the time at the specified index
        _reminderTimes.removeAt(index);
      } else {
        // Show error if trying to remove the last reminder
        // At least one reminder time is required
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('At least one reminder time is required'),
          ),
        );
      }
    });
  }

  // Show time picker to select reminder time
  // This is called when the user taps the clock icon on a reminder time
  Future<void> _selectTime(int index) async {
    // Create a TimeOfDay object from the current reminder time
    final TimeOfDay initialTime = TimeOfDay(
      hour: _reminderTimes[index].hour,
      minute: _reminderTimes[index].minute,
    );
    
    // Show the time picker dialog
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    
    // If user selected a time (didn't cancel)
    if (pickedTime != null) {
      setState(() {
        // Update the reminder time with the new hour and minute
        _reminderTimes[index] = DateTime(
          _reminderTimes[index].year,
          _reminderTimes[index].month,
          _reminderTimes[index].day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  // Format time for display in a readable format
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Save the medication
  // This is called when the user taps the "Add Medication" or "Update Medication" button
  void _saveMedication() {
    // Validate form to ensure all required fields are filled
    if (_formKey.currentState!.validate()) {
      // Create a medication object from the form data
      final medication = _isEditing
          // If editing, create a copy of the existing medication with updated values
          ? widget.medication!.copyWith(
              name: _nameController.text,
              dosage: _dosageController.text,
              reminderTimes: _reminderTimes,
              notes: _notesController.text,
            )
          // If adding new, create a new medication with a unique ID
          : Medication(
              id: _uuid.v4(), // Generate a unique ID
              name: _nameController.text,
              dosage: _dosageController.text,
              reminderTimes: _reminderTimes,
              notes: _notesController.text,
            );
      
      // Return the medication to the previous screen (HomeScreen)
      Navigator.pop(context, medication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top of the screen
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Medication' : 'Add Medication'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      
      // Main content area with a form
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Medication name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Medication Name',
                border: OutlineInputBorder(),
              ),
              // Validation to ensure name is not empty
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter medication name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Dosage field
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: 'Dosage (e.g., 1 pill, 5ml)',
                border: OutlineInputBorder(),
              ),
              // Validation to ensure dosage is not empty
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter dosage';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Reminder times section header
            const Text(
              'Reminder Times',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // List of reminder times
            ListView.builder(
              shrinkWrap: true, // Allow the list to be inside another scrollable widget
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling for this list
              itemCount: _reminderTimes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Reminder ${index + 1}'),
                    subtitle: Text(_formatTime(_reminderTimes[index])),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Button to edit the time
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _selectTime(index),
                        ),
                        // Button to delete the time
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeReminderTime(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Button to add another reminder time
            TextButton.icon(
              onPressed: _addReminderTime,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Reminder Time'),
            ),
            const SizedBox(height: 16),
            
            // Notes field (optional)
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3, // Allow multiple lines for notes
            ),
            const SizedBox(height: 24),
            
            // Save button
            ElevatedButton(
              onPressed: _saveMedication,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                _isEditing ? 'Update Medication' : 'Add Medication',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
