// services/notification_service.dart
// This file provides services for scheduling and managing medication reminders
// It handles the creation and scheduling of notifications for medication reminders

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/medication.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  // Singleton instance - ensures only one instance of this service exists
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Notification plugin instance that handles platform-specific notification functionality
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? _customRingtonePath;

  // Initialize notification service
  Future<void> initialize() async {
    // Initialize timezone data for scheduling notifications at specific times
    tz_data.initializeTimeZones();

    // Initialize notification settings for Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize notification settings for iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings for all platforms
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the notifications plugin with the settings
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification tapped: ${response.payload}');
      },
    );

    // Load custom ringtone path from shared preferences
    final prefs = await SharedPreferences.getInstance();
    _customRingtonePath = prefs.getString('custom_ringtone');
  }

  // Add this method to request notification permissions
  Future<void> requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // Pick a custom ringtone
  Future<void> pickRingtone() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      _customRingtonePath = result.files.single.path;
      print('Selected ringtone: $_customRingtonePath');

      // Save the ringtone path in shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('custom_ringtone', _customRingtonePath!);
    }
  }

  // Schedule a notification for a specific medication reminder
  Future<void> scheduleMedicationReminder(
    Medication medication,
    DateTime reminderTime,
  ) async {
    final int notificationId = medication.id.hashCode + reminderTime.hashCode;

    final androidDetails = AndroidNotificationDetails(
      'medication_reminder_channel',
      'Medication Reminders',
      channelDescription: 'Notifications for medication reminders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      sound: _customRingtonePath != null
          ? RawResourceAndroidNotificationSound(
              _customRingtonePath!.split('/').last.split('.').first,
            )
          : null, // Use custom ringtone if available
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound:
          'custom_ringtone.aiff', // Ensure the sound file is in the correct format for iOS
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      'Medication Reminder',
      'Time to take ${medication.dosage} of ${medication.name}',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: medication.id,
    );
  }

  // Schedule all reminders for a medication
  Future<void> scheduleAllReminders(Medication medication) async {
    for (final reminderTime in medication.reminderTimes) {
      if (reminderTime.isAfter(DateTime.now())) {
        await scheduleMedicationReminder(medication, reminderTime);
      }
    }
  }

  // Cancel all notifications for a medication
  Future<void> cancelMedicationReminders(String medicationId) async {
    await _notificationsPlugin.cancelAll();
  }

  // Schedule a generic notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
      sound: _customRingtonePath != null
          ? RawResourceAndroidNotificationSound(
              _customRingtonePath!.split('/').last.split('.').first,
            )
          : null, // Use custom ringtone if available
    );

    const iosDetails = DarwinNotificationDetails(
      sound:
          'custom_ringtone.aiff', // Ensure the sound file is in the correct format for iOS
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
