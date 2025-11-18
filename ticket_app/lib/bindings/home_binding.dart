import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:ticket_app/controller/home_controller.dart';
import 'package:ticket_app/controller/my_bookings_controller.dart';
import 'package:ticket_app/controller/payment_controller.dart';
import 'package:ticket_app/controller/reservations_controller.dart';
import 'package:ticket_app/controller/settings_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MyBookingsController>(() => MyBookingsController());
    Get.lazyPut<TravelsController>(() => TravelsController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<Stripe>(() => Stripe.instance);
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}
