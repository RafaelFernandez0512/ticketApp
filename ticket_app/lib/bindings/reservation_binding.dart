
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:ticket_app/controller/reservation_detail_controller.dart';

class ReservationDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReservationDetailController>(() => ReservationDetailController());

  }
}
