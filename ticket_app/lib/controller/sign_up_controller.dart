import 'package:fluent_validation/models/validation_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/data/model/register.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/utils/Validators/user_register_validator.dart';

class SignUpController extends GetxController with StateMixin {
  var activeStep = 0.obs;
  var userRegister = UserRegister().obs;
  final ApiService apiService = Get.find<ApiService>();
  SignUpController() {
    change(null, status: RxStatus.success());
  }

  onChangeAddressLine1(String p1) {
    userRegister.update((val) {
      val!.addressLine1 = p1;
    });
  }

  onChangeAddressLine2(String p1) {
    userRegister.update((val) {
      val!.addressLine2 = p1;
    });
  }

  void onChangeState(String? p1) {
    userRegister.update((val) {
      val!.state = p1;
    });
  }

  void onChangeTown(String? p1) {
    userRegister.update((val) {
      val!.town = p1;
    });
  }

  onChangeZipCode(String p1) {
    userRegister.update((val) {
      val!.zipCode = p1;
    });
  }

  Future nextStep() async {
    if (activeStep.value == 0) {
      if (!validUser()) {
        return;
      }
    }

    if (activeStep.value == 1) {
      if (!validUserAddress()) {
        return;
      }
      await register();
      return;
    }
    activeStep.value++;
  }

  Future<void> register() async {
    try {
      change(null, status: RxStatus.loading());
      var response = await apiService.createCustomer(
          UserRegister.mapUserRegisterToCustomer(userRegister.value));
      change(null, status: RxStatus.success());
      if (response != null) {
        Get.offNamed('/home');
      } else {
        change(null, status: RxStatus.error());
        Get.dialog(AlertDialog(
          title: const Text('Error'),
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
      Get.dialog(AlertDialog(
        title: const Text('Error'),
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

  bool validUser() {
    final UserRegisterValidator userValidator = UserRegisterValidator();
    final ValidationResult validationResult =
        userValidator.validate(userRegister.value);

    if (validationResult.hasError) {
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: Text(validationResult.errors
            .map((x) => '${x.key} ${x.message}')
            .join('\n')),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
      return false;
    } else {
      return true;
    }
  }

  bool validUserAddress() {
    final UserRegisterAddressValidator userValidator =
        UserRegisterAddressValidator();
    final ValidationResult validationResult =
        userValidator.validate(userRegister.value);

    if (validationResult.hasError) {
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: Text(validationResult.errors
            .map((x) => '${x.key} ${x.message}')
            .join('\n')),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
      return false;
    } else {
      return true;
    }
  }

  backStep() {
    if (activeStep.value == 0) {
      Get.back();
    }
    activeStep.value--;
  }

  onChangeLastName(String p1) {
    userRegister.update((val) {
      val!.lastName = p1;
    });
  }

  onChangeEmail(String p1) {
    userRegister.update((val) {
      val!.email = p1;
    });
  }

  onChangeFirstName(String p1) {
    userRegister.update((val) {
      val!.firsName = p1;
    });
  }

  onChangePhoneNumber(String p1) {
    userRegister.update((val) {
      val!.phoneNumber = p1;
    });
  }

  onChangePassword(String p1) {
    userRegister.update((val) {
      val!.password = p1;
    });
  }

  onChangeConfirmPassword(String p1) {
    userRegister.update((val) {
      val!.confirmPassword = p1;
    });
  }
}
