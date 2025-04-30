import 'package:get/get.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/routes/app_pages.dart';

class MyBookingsController extends GetxController
    with StateMixin<List<Reservation>> {
  final ApiService apiService = Get.find<ApiService>();

  var serviceType = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  onChangeType(int? type) async {
    serviceType.value = type!;
    await fetch();
  }

  Future<void> fetch() async {
    change([], status: RxStatus.loading());
    try {
      var data = await apiService.getReservations();
      change(data, status: RxStatus.success());
    } catch (e) {
      change([], status: RxStatus.error(e.toString()));
    }
  }

  onTap(int index) {
    var data = state?[index];
    if (data != null) {
      Get.toNamed(Routes.MY_BOOKING_DETAIL, arguments: data);
    }
  }
}
