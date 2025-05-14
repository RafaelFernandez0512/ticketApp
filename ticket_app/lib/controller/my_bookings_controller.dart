import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/ui/reservations/payment_sheet_modal.dart';

class MyBookingsController extends GetxController
    with StateMixin<List<Reservation>> {
  final ApiService apiService = Get.find<ApiService>();
  Rx<DateTime>? selectedDate;
  var serviceType = 0.obs;
  @override
  void onInit() {
    super.onInit();
    serviceType = 0.obs;
    selectedDate = null;
  }

  onChangeType(int? type) async {
    serviceType.value = type!;
    await fetch();
  }

  Future<void> fetch() async {
    change([], status: RxStatus.loading());
    try {
      var data = await apiService
          .getReservations(selectedDate?.value ?? DateTime.now());
      if (selectedDate != null && data.isNotEmpty) {
        selectedDate = data.firstOrNull!.departureDate!.obs;
      } else {
        selectedDate = DateTime.now().obs;
      }

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
    if (DateTime.now().isAfter(reservation.departureDate!)) {
      Get.showSnackbar(
        const GetSnackBar(
          title: "Payment Not Allowed",
          message: "Payments are only allowed before the departure date.",
          duration: const Duration(seconds: 3),
          backgroundColor: CupertinoColors.systemRed,
        ),
      );
      return;
    }
    var value = await PaymentSheetModal.showModal(
      context,
      reservation,
    );
    if (value) {
      await fetch();
    }
  }
}
