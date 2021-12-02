import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储-单例模式
class LocalStorage {
  static LocalStorage _instance = new LocalStorage._();

  factory LocalStorage() => _instance;
  static late SharedPreferences _prefs;

  LocalStorage._();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _prefs.setString(key, jsonString);
  }

  dynamic getJSON(String key) {
    String? jsonString = _prefs.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  List<String> getKeys() {
    return _prefs.getKeys().toList();
  }

  Future<bool> setBool(String key, bool val) {
    return _prefs.setBool(key, val);
  }

  bool getBool(String key) {
    bool? val = _prefs.getBool(key);
    return val == null ? false : val;
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }
}
