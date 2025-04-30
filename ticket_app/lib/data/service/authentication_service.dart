import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/data/model/session.dart';
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/utils/constants.dart';

class AuthService extends GetxService {
  final String baseUrl;
  var sessionService = Get.find<SessionService>();

  AuthService(this.baseUrl);
  Future<String> authenticate(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/Authentication/Authenticate');
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'Username': username, 'Password': password}),
        )
        .timeout(
            const Duration(seconds: 120)); // Aplicar timeout de 10 segundo;

    if (response.statusCode == 200) {
      sessionService.saveSession(Session(
          username: username,
          password: password,
          token: response.body,
          expirationDate: DateTime.now().add(const Duration(hours: 1)),
          refreshToken: response.body));
      return response.body; // Token de autenticación
    } else {
      return '';
    }
  }

  Future<String> temporalToken() async {
    try {
      final url = Uri.parse('$baseUrl/api/Authentication/Authenticate');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'Username': USERNAME_TEMPORAL, 'Password': PASSWORD_TEMPORAL}),
      );

      if (response.statusCode == 200) {
        sessionService.saveSession(Session(
            expirationTemporalTokenDate:
                DateTime.now().add(const Duration(hours: 1)),
            refreshToken: response.body));
        return response.body; // Token de autenticación
      } else {
        throw Exception('Error en  obteniendo token: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Error en  obteniendo token:');
  }
}
