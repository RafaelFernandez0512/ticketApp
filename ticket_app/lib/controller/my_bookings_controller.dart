import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/ui/bookings/payments/payment_sheet_modal.dart';

class MyBookingsController extends GetxController
    with StateMixin<List<Reservation>> {
  late final EasyInfiniteDateTimelineController controllerPicker;
  final ApiService apiService = Get.find<ApiService>();
  Rx<DateTime>? selectedDate;
  var serviceType = 0.obs;
  @override
  void onInit() {
    super.onInit();
    selectedDate ??= DateTime.now().obs;
    controllerPicker = EasyInfiniteDateTimelineController();
    serviceType = 0.obs;
  }

  onChangeType(int? type) async {
    serviceType.value = type!;
    await fetch();
  }

  Future<void> fetch() async {
    controllerPicker.animateToFocusDate();
    change([], status: RxStatus.loading());
    try {
      var data = serviceType.value == 0
          ? await apiService.getReservations(selectedDate?.value)
          : await apiService.getService(selectedDate?.value);

      change(data, status: RxStatus.success());
    } catch (e) {
      change([], status: RxStatus.error(e.toString()));
    }
  }

  onChangeDate(DateTime date) async {
    selectedDate = date.obs;
    await fetch();
  }

  onTap(int index) {
    var data = state?[index];

    if (data != null && data.payment.any((x) => x.reference != null)) {
      Get.toNamed(Routes.RESERVATION_DETAIL, arguments: data);
    }
  }

  onPayment(BuildContext context, Reservation reservation) async {
    var value = await PaymentSheetModal.showModal(
      context,
      reservation,
    );
    if (value) {
      await fetch();
    }
  }
}
