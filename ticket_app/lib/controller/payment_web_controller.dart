

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/service/payment_service.dart';

class PaymentWebController extends GetxController with StateMixin<String> {
  // This controller can be used to manage payment-related logic for web applications.
  // Currently, it does not have any specific methods or properties.
  // You can add methods to handle payment processing, validation, etc. as needed.

  @override
  void onInit() {
    super.onInit();
    // Initialization logic can go here if needed.
    change('', status: RxStatus.loading());
   Future.delayed(const Duration(seconds: 2),() async {
      await load();
    } );
  }
  Reservation? reservation = null;
  // Add any additional methods or properties related to payment processing here.

  Future<void> load() async {
      change('', status: RxStatus.loading());
     reservation = Get.arguments as Reservation;
    var value = await _initPayment(Get.context!, reservation!);
    reservation!.reference = value;
      change(value, status: RxStatus.success());
  }
   Future<String> _initPayment( 
      BuildContext context, Reservation reservation) async {
    try {
      var description = reservation.serviceType == 0
          ? 'Payment for reservation number: ${reservation.reservationNumber}'
          : 'Payment for service number: ${reservation.reservationNumber}';
      final data = await Get.find<PaymentService>().createPaymentIntent(
          name: reservation.customer?.fullName ?? '',
          address: reservation.addressLine1From,
          zipcode: reservation.zipCodeFrom ?? '',
          city: reservation.cityFrom?.name ?? '',
          state: reservation.stateFrom?.name ?? '',
          country: 'US',
          currency: 'usd',
          description: description,
          amount: reservation.amount ?? 0);
          reservation.reference = data['reference'].toString();
      return data['client_secret'].toString();
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: e.toString(),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error, color: Colors.white),
        ),
      );
      return '';
    }

  }
}
