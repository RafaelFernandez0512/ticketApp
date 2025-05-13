import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import 'package:ticket_app/controller/splash_controller.dart';
import 'package:ticket_app/data/service/payment_service.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<PaymentService>(() => PaymentService());
    Get.lazyPut<Stripe>(() => Stripe.instance);
  }
}
