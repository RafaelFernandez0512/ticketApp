import 'package:get/get.dart';
import 'package:ticket_app/data/service/api_service.dart';

class MyReservationsController extends GetxController with StateMixin {
  final ApiService apiService = Get.find<ApiService>();
  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {}
}
