import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ticket_app/data/model/filter_data.dart';
import 'package:ticket_app/data/model/forgot_password.dart';
import 'package:ticket_app/data/model/home_viewmodel.dart';
import 'package:ticket_app/data/service/api_service.dart';

class ForgotPasswordController extends GetxController
    with StateMixin<HomeViewModel> {
  final ApiService apiService = Get.find<ApiService>();
  var activeStep = 0.obs;
  var code = '';
  var verificationCode = '';
  var forgotPasswordModel = ForgotPassword().obs;
  ForgotPasswordController() {
    change(null, status: RxStatus.success());
  }
  backStep() {
    if (activeStep.value == 0) {
      Get.back();
    }
    activeStep.value--;
  }

  Future nextStep() async {
    if (activeStep.value == 0) {
      if (forgotPasswordModel.value.email?.isEmpty??true) {
        Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please enter your email address'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
        return;
      }
      await sendCode();
    }
    if (activeStep.value == 1) {
      var error = '';
      if (code.isEmpty) {
        error = 'Please enter the verification code';
      } else if (verificationCode.isEmpty) {
        error = 'Please send the verification code first';
      } else if (code != verificationCode) {
        error = 'Invalid verification code';
      }

      if (error.isNotEmpty) {
        Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
        return;
      }
    }
    activeStep.value++;
    if (activeStep.value == 1) {
      sendCode();
      return;
    }
    if (activeStep.value == 2) {
      await resetPassword();
      return;
    }
  }

  void onChangeEmail(String p1) {
    forgotPasswordModel.update((val) {
      val!.email = p1;
    });
  }

  void onChangeCode(String p1) {
    code = p1;
  }

  Future<void> resetPassword() async {
    try {
      EasyLoading.show(status: 'loading...');
      var response = await apiService.changePassword(
          forgotPasswordModel.value.email!, forgotPasswordModel.value.password!);
      EasyLoading.dismiss();
      if (response != null) {
        await Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content: const Text('Password reset successfully'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
        Get.offNamed('/login');
      } else {
        EasyLoading.dismiss();
        Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content:
              const Text('Unable to complete the operation, please try again'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
      }
    } catch (e) {
      EasyLoading.dismiss();

      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content:
            const Text('Unable to complete the operation, please try again'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
    }
  }

  Future<void> sendCode() async {
    try {
      EasyLoading.show(status: 'loading...');

      var response = await apiService.sendCode(forgotPasswordModel.value.email!);
      EasyLoading.dismiss();
      if (response != null) {
        verificationCode = response;
        activeStep.value++;
      } else {
        EasyLoading.dismiss();
        Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content:
              const Text('Unable to complete the operation, please try again'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
      }
    } catch (e) {
      EasyLoading.dismiss();

      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content:
            const Text('Unable to complete the operation, please try again'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
    }
  }
}
