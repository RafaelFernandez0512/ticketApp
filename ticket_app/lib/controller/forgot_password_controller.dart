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
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController
    with StateMixin<HomeViewModel> {
  final ApiService apiService = Get.find<ApiService>();
  var activeStep = 0.obs;
  var code = '';
  var verificationCode = '';
  var password = ''.obs;
  var requiredCurrentPassword = false.obs;
  var forgotPasswordModel = ForgotPassword().obs;
  ForgotPasswordController() {
    change(null, status: RxStatus.success());
  }
  bool islogged = false;
  @override
  void onInit() async {
    super.onInit();
    var email = Get.find<SessionService>().getSession()?.username;
    if (email != null) {
      islogged = true;
      requiredCurrentPassword = true.obs;
      forgotPasswordModel.update((val) {
        val!.email = email;
      });
    }
  }

  backStep() {
    var email = Get.find<SessionService>().getSession()?.username;
    if (activeStep.value == 0) {
      Get.back();
    }
    activeStep.value--;
  }

  Future nextStep() async {
    if (activeStep.value == 0) {
      if (forgotPasswordModel.value.email?.isEmpty ?? true) {
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

      if (requiredCurrentPassword.value) {
        var currentPassword = Get.find<SessionService>().getSession()?.password;
        if (password.value != currentPassword) {
          Get.dialog(AlertDialog(
            title: const Text('Alert'),
            content: const Text('Current password is incorrect'),
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

    if (activeStep.value == 2) {
      var errorMessage = '';
      if (forgotPasswordModel.value.password?.isEmpty ?? true) {
        errorMessage = 'Please enter your new password';
      } else if (forgotPasswordModel.value.confirmPassword?.isEmpty ?? true) {
        errorMessage = 'Please confirm your new password';
      } else if (forgotPasswordModel.value.password !=
          forgotPasswordModel.value.confirmPassword) {
        errorMessage = 'Passwords do not match';
      }
      if (errorMessage.isNotEmpty) {
        Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
        return;
      }
      await resetPassword();
      return;
    }
    activeStep.value++;
  }

  void onChangeEmail(String p1) {
    forgotPasswordModel.update((val) {
      val!.email = p1;
    });
  }

  void onPassword(String p1) {
    password.value = p1;
  }

  void onChangeCode(String p1) {
    code = p1;
  }

  Future<void> resetPassword() async {
    try {
      EasyLoading.show(status: 'loading...');
      var response = await apiService.changePassword(
          forgotPasswordModel.value.email!,
          forgotPasswordModel.value.password!);
      EasyLoading.dismiss();
      if (response != null && response) {
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
        if (islogged) {
          Get.back();
          //snackbar
          Get.snackbar('Success', 'Password reset successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } else {
          Get.offNamed(Routes.LOGIN);
        }
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

      var response =
          await apiService.sendCode(forgotPasswordModel.value.email!);
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

  onchangePassword(String text) {
    password.value = text;
    forgotPasswordModel.update((val) {
      val!.password = text;
    });
  }

  onchangeConfirmPassword(String text) {
    forgotPasswordModel.update((val) {
      val!.confirmPassword = text;
    });
  }
}
