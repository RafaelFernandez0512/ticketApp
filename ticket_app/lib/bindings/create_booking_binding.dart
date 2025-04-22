import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:ticket_app/controller/create_booking_controller.dart';

class CreateBookingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateBookingController>(() => CreateBookingController());

  }
}
