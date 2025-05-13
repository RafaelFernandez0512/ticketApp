import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/data/model/customer.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';
import 'package:ticket_app/utils/gaps.dart';

class EditProfileController extends GetxController with StateMixin<Customer?> {
  Rx<Customer?>? customerRx;
  var apiService = Get.find<ApiService>();
  @override
  void onInit() async {
    super.onInit();
    change(null, status: RxStatus.loading());
    await loadData();
  }

  loadData() async {
    change(null, status: RxStatus.loading());
    var username = Get.find<SessionService>().getSession()?.username;
    var customer = await apiService.getCustomer(username ?? '');
    customerRx = customer?.obs;
    change(customer, status: RxStatus.success());
  }

  Future<void> getPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final base64String = base64Encode(bytes);
      customerRx?.update((val) {
        val!.photo = base64String;
      });
    }
  }

  save() async {
    if (customerRx?.value != null) {
      var customer = customerRx?.value;
      await apiService.updateCustomer(customer!);
      Get.back();
    }
  }

  deleteAccount() async {
    Get.dialog(
      AlertDialog(
        title: const Center(child: Text('Confirm Delete Account')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your username and password to confirm.'),
            CustomTextField(
              labelText: 'Username',
              onChanged: (value) {
                customerRx?.value?.email =
                    value; // Asume que el email es el username
              },
            ),
            gapH16,
            CustomTextField(
              labelText: 'Password',
              obscureText: true,
              onChanged: (value) {
                customerRx?.value?.password = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Cierra el diálogo sin hacer nada
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final username = customerRx?.value?.email;
              final password = customerRx?.value?.password;

              if (username != null && password != null) {
                var auth = await Get.find<AuthService>()
                    .authenticate(username, password);
                if (auth == '' || auth.isEmpty) {
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
                final success =
                    await apiService.deleteAccount(username, password);
                if (success) {
                  Get.back(); // Cierra el diálogo
                  Get.showSnackbar(const GetSnackBar(
                    title: 'Account Deleted',
                    message: 'Your account has been successfully deleted.',
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.green,
                  ));
                  Get.offAllNamed(
                      '/login'); // Redirige al usuario a la pantalla de inicio de sesión
                } else {
                  Get.showSnackbar(const GetSnackBar(
                    title: 'Error',
                    message: 'Failed to delete account. Please try again.',
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  ));
                }
              } else {
                Get.showSnackbar(const GetSnackBar(
                  title: 'Error',
                  message: 'Username and password are required.',
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void onChangeName(String name) {
    customerRx?.value?.firstName = name;
  }

  void onChangeMiddleName(String middleName) {
    customerRx?.value?.middleName = middleName;
  }

  void onChangeLastName(String lastName) {
    customerRx?.value?.lastName = lastName;
  }

  void onChangePhone(String phone) {
    customerRx?.value?.phoneNumber = phone;
  }

  void onChangeAddressLine1(String addressLine1) {
    customerRx?.value?.addressLine1 = addressLine1;
  }

  void onChangeAddressLine2(String addressLine2) {
    customerRx?.value?.addressLine2 = addressLine2;
  }
}
