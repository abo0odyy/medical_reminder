// time_picker_widget.dart
// This file contains a custom time picker widget for selecting reminder times

import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final DateTime time;
  final Function(DateTime) onTimeChanged;
  final Function() onDelete;
  final int index;

  const TimePickerWidget({
    super.key,
    required this.time,
    required this.onTimeChanged,
    required this.onDelete,
    required this.index,
  });

  // Format time for display
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  // Show time picker dialog
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay initialTime = TimeOfDay(
      hour: time.hour,
      minute: time.minute,
    );
    
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      final newTime = DateTime(
        time.year,
        time.month,
        time.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      onTimeChanged(newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _formatTime(time),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _selectTime(context),
              tooltip: 'Edit time',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Remove reminder',
            ),
          ],
        ),
      ),
    );
  }
}
