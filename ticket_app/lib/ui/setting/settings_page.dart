import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.find<SettingsController>();
  SettingsPage({super.key});

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                // Foto de perfil circular
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // URL de la foto de perfil
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'John Doe', // Nombre del usuario
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'johndoe@example.com', // Email del usuario
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),

                // Opciones de configuración

                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    // Navegar a la pantalla de edición de perfil
                    Get.toNamed('/edit-profile');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  onTap: () {
                    // Navegar a la pantalla de cambio de contraseña
                    Get.toNamed('/change-password');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Credit Cards'),
                  onTap: () {
                    // Navegar a la pantalla de tarjetas de crédito
                    Get.toNamed('/credit-cards');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  onTap: () {
                    // Lógica para cerrar sesión
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Log Out'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Cerrar sesión y navegar a la pantalla de inicio de sesión
                              Get.offAllNamed('/login');
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
          ),
        ),
      ),
    );
  }
}
