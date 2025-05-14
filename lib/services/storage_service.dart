// services/storage_service.dart
// This file provides a generic service for handling data persistence
// It abstracts the details of saving and loading data from the device storage

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Singleton instance - ensures only one instance of this service exists
  // This pattern is useful for services that should be accessed from multiple places
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Save data to SharedPreferences
  // This method handles different data types and stores them appropriately
  Future<bool> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Handle different data types with appropriate storage methods
    if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is int) {
      return await prefs.setInt(key, value);
    } else if (value is double) {
      return await prefs.setDouble(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    } else if (value is List<String>) {
      return await prefs.setStringList(key, value);
    } else {
      // For complex objects like our Medication class, convert to JSON string
      final jsonString = jsonEncode(value);
      return await prefs.setString(key, jsonString);
    }
  }

  // Load data from SharedPreferences
  // This retrieves data stored with the given key
  Future<dynamic> loadData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  // Load JSON data and decode it
  // This is specifically for retrieving complex objects stored as JSON
  Future<dynamic> loadJsonData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    
    return null;
  }

  // Remove data from SharedPreferences
  // This deletes the data associated with the given key
  Future<bool> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  // Clear all data from SharedPreferences
  // This removes all data stored by the app - use with caution!
  Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
