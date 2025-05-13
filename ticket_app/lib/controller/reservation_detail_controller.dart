import 'package:get/get.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/service/api_service.dart';

class ReservationDetailController extends GetxController
    with StateMixin<String?> {
  final ApiService apiService = Get.find<ApiService>();
  Rx<DateTime>? selectedDate;
  var serviceType = 0.obs;
  Reservation? reservation;
  @override
  void onInit() async {
    super.onInit();
    reservation = Get.arguments;
    selectedDate = DateTime.now().obs;
    serviceType = 0.obs;
    fetch();
  }

  Future<void> fetch() async {
    var payment =
        reservation?.payment.where((x) => x.reference != null).firstOrNull;
    if (payment != null) {
      change('', status: RxStatus.loading());
      try {
        var data = await apiService.getReservationPdf(
            'TicketTravel', payment.idPayment!);
        change(data, status: RxStatus.success());
      } catch (e) {
        change('', status: RxStatus.error(e.toString()));
      }
    }
  }
}
