import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/data/model/session.dart';

class AppSettings {
 static SharedPreferences? _prefs =SharedPreferences.getInstance() as SharedPreferences?;

  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'user';

  static Future<void> setIsLoggedIn(bool value) async {

    await _prefs!.setBool(_isLoggedInKey, value);
  }
  static Future<bool> getIsLoggedIn() async {
    return _prefs!.getBool(_isLoggedInKey) ?? false;
  }
  static Future<void> setSession(Session value) async {
    await _prefs!.setString(_userIdKey, jsonEncode(value.toJson()));
  }
  static Future<Session?> getSession() async {
    String? jsonString = _prefs!.getString(_userIdKey);
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return Session.fromJson(jsonMap);
    }
    return null;
  }
  static Future<void> clearSession() async {
    await _prefs!.remove(_userIdKey);
  }
}