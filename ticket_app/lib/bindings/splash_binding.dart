import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:ticket_app/controller/login_controller.dart';
import 'package:ticket_app/controller/sign_up_controller.dart';
import 'package:ticket_app/controller/splash_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
