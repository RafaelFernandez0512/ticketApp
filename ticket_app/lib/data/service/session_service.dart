import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/data/model/session.dart';
// Importa el modelo

class SessionService extends GetxService {
  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
  final _sessionKey = 'session'; // Clave para guardar la sesión

  // Método para guardar la sesión en caché
  Future<void> saveSession(Session session) async {
    await sharedPreferences.setString(
        _sessionKey, jsonEncode(session.toJson()));
  }

  // Método para obtener la sesión desde el caché
  Session? getSession() {
    final sessionData = sharedPreferences.getString(_sessionKey);
    if (sessionData != null) {
      return Session.fromJson(jsonDecode(sessionData));
    }
    return null;
  }

  // Método para eliminar la sesión
  Future<void> clearSession() async {
    await sharedPreferences.remove(_sessionKey);
  }

  // Verificar si hay una sesión activa
  bool isLoggedIn() {
    final session = getSession();
    if (session != null) {
      return !session.isSessionExpired();
    }
    return false;
  }
}
