import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/data/service/session_service.dart';
import '../routes/app_pages.dart';

class SplashController extends GetxController with StateMixin {
  ApiService apiService = Get.find<ApiService>();
  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        await loadData();
        var user = Get.find<SessionService>().getSession();
      
        if (user!=null && !user.isSessionExpired()) {
          var auth = await Get.find<AuthService>()
              .authenticate(user.username ?? "", user.password ?? "");
             
          if (auth.isNotEmpty) {
            await Get.find<ApiService>().getCustomer(user.username!);
   await loadData(); 
            Get.offAllNamed(Routes.HOME);
            return;
          } else {
            if (user.username?.isNotEmpty ?? false) {
              await Get.find<SharedPreferences>().clear();
                 await loadData(); 
              
            }
          }
        }
        Get.offAllNamed(Routes.LOGIN);
      } catch (e) {
        Get.snackbar(
          'Error',
          '$e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  Future<bool> loadData() async {
    var configurations = await apiService.configurations(['Publishablekey']);
    if (configurations.isEmpty) {
      return false;
    }
    Stripe.publishableKey = configurations
            .where((x) => x.idConfiguracion == 'Publishablekey')
            .first
            .descripcion ??
        '';
    Stripe.merchantIdentifier = 'merchant.flutter.DoorToDoor';

    final Stripe stripe = Get.find<Stripe>();
    await stripe.applySettings();
    return true;
  }
}
