import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/routes/app_pages.dart';

class LoginController extends GetxController with StateMixin {
  var username = ''.obs;
  var password = ''.obs;
  final AuthService apiService = Get.find<AuthService>();
  LoginController() {
    change(null, status: RxStatus.success());
  }
  onChangeUserName(String value) {
    username.value = value;
  }

  onChangePassword(String value) {
    password.value = value;
  }

  Future<void> login() async {
    try {
      if (username.isNotEmpty && password.isNotEmpty) {
        // Guardar credenciales en caché
        change(null, status: RxStatus.loading());
        var token =
            await apiService.authenticate(username.value, password.value);
        if (token.isEmpty) {
          change(null, status: RxStatus.success());
          await Get.dialog(
            AlertDialog(
              title: const Text('Alert'),
              content: const Text('Username/Password incorrect'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(), // Cierra el diálogo
                  child: const Text('Close'),
                ),
              ],
            ),
          );
          return;
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username', username.value);
        await prefs.setString('password', password.value);
        await prefs.setBool('isLogged', true);
        change(null, status: RxStatus.success());
        Get.offNamed(Routes.HOME);
      }
    } catch (e) {
      change(null, status: RxStatus.success());
      await Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Unable to complete the operation, please try again. '),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Cierra el diálogo
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
