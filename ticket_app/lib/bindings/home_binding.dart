import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:ticket_app/controller/home_controller.dart';
import 'package:ticket_app/controller/my_reservations_controller.dart';
import 'package:ticket_app/controller/reservations_controller.dart';
import 'package:ticket_app/controller/settings_controller.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/utils/constants.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MyReservationsController>(() => MyReservationsController());
    Get.lazyPut<TravelsController>(() => TravelsController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<ApiService>(() => ApiService(urlApi));
  }
}
