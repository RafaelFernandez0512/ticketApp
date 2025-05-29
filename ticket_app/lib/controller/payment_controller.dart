import 'package:fluent_validation/models/validation_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ticket_app/data/model/payment.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/model/session.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/utils/notification_type.dart';

class PaymentController extends GetxController {
  ApiService _apiService = Get.find<ApiService>();

  Future<bool> onSubmit(
      Reservation reservation, String description, String reference) async {
    EasyLoading.show(status: 'Loading...');

    var customerId = Get.find<SessionService>().getSession()?.customerId;

    var payment = Payment(
            customer: customerId,
            reservationNumber: reservation.serviceType == 0
                ? reservation.reservationNumber
                : 0,
            membership: 0,
            service: reservation.serviceType == 1
                ? reservation.reservationNumber
                : 0,
            paymentMethod: "CC",
            subtotal: reservation.amount ?? 0,
            discount: 0,
            total: reservation.amount ?? 0,
            description: description,
            reference: reference,
            paymentDate: DateTime.now())
        .obs;
    var response = await _apiService.payment(payment.value);

    if (response != null) {
   
      Get.snackbar('Success',
          'Payment processed successfully. Your ticket was sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: notificationTypeColors[NotificationType.success],
          colorText: Colors.white);
      EasyLoading.dismiss();
      return true;
    } else {
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: Text('Payment failed. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
      EasyLoading.dismiss();
      return false;
    }
  }
}
