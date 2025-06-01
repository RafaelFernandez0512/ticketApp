import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/controller/settings_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/request_pernission.dart';

class SettingsPage extends GetView<SettingsController> {
  @override
  final SettingsController controller;
  const SettingsPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder(
              init: controller,
              builder: (_) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      // Foto de perfil circular
                      Center(
                        child: controller.photo?.value != null
                            ? Obx(
                                () => CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      MemoryImage(controller.photo!.value),
                                ),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: CustomTheme.primaryLightColor,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: CustomTheme.white,
                                ),
                              ),
                      ),
                      gapH16,
                      Obx(() => Text(
                            controller.name.value, // Nombre del usuario
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                      gapH12,
                      Obx(() => Text(
                            controller.email.value, // Email del usuario
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                      const SizedBox(height: 32),

                      // Opciones de configuración
                      Visibility(
                        visible: controller.showScanner.value??false,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.qr_code),
                              title: const Text('Scan Ticket'),
                              subtitle: const Text(
                                  'Scan a ticket to check its payment status.'),
                              onTap: () async {
                                // Navegar a la pantalla de edición de perfil
                                if (!await checkCameraPermission()) {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Text(
                                          'Camera Permission Required'),
                                      content: const Text(
                                          'This feature needs access to your camera to scan QR codes. Please grant camera permission in your device settings.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }
                                await Get.toNamed(Routes.QR_PAGE);
                              },
                            ),
                            const Divider(),
                          ],
                        ),
                      ),

                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit Profile'),
                        onTap: () {
                          // Navegar a la pantalla de edición de perfil
                          Get.toNamed(Routes.EDIT_PROFILE);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('Change Password'),
                        onTap: () {
                          // Navegar a la pantalla de cambio de contraseña
                          Get.toNamed(Routes.FORGOT_PASSWORD);
                        },
                      ),

                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: const Text('Log Out'),
                        textColor: Colors.red,
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                                color: Colors.red, fontWeight: FontWeight.w700),
                        onTap: () {
                          // Lógica para cerrar sesión
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Log Out'),
                              content: const Text(
                                  'Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await Get.find<SharedPreferences>().clear();
                                    await Get.offAllNamed('/login');
                                  },
                                  child: const Text('Log Out'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
