import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Local storage service using shared_preferences
class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String operations
  Future<void> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw 'Failed to set string: $e';
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw 'Failed to get string: $e';
    }
  }

  // Boolean operations
  Future<void> setBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw 'Failed to set boolean: $e';
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw 'Failed to get boolean: $e';
    }
  }

  // Integer operations
  Future<void> setInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw 'Failed to set integer: $e';
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw 'Failed to get integer: $e';
    }
  }

  // List operations
  Future<void> setStringList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
    } catch (e) {
      throw 'Failed to set string list: $e';
    }
  }

  List<String> getStringList(String key) {
    try {
      return _prefs.getStringList(key) ?? [];
    } catch (e) {
      throw 'Failed to get string list: $e';
    }
  }

  // JSON operations
  Future<void> setJson(String key, Map<String, dynamic> value) async {
    try {
      await _prefs.setString(key, jsonEncode(value));
    } catch (e) {
      throw 'Failed to set JSON: $e';
    }
  }

  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw 'Failed to get JSON: $e';
    }
  }

  // Remove operations
  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw 'Failed to remove key: $e';
    }
  }

  /// Clear all data
  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw 'Failed to clear storage: $e';
    }
  }

  /// Check if key exists
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }
}
