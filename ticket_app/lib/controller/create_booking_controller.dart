//create controller for create booking
import 'package:get/get.dart';
import 'package:ticket_app/data/model/travel.dart';
import 'package:ticket_app/data/service/api_service.dart';

class CreateBookingController extends GetxController with StateMixin {
  final ApiService apiService = Get.find<ApiService>();
  var activeStep = 0.obs;

  Travel? travel;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
  }

  Future<void> createBooking() async {}
}
