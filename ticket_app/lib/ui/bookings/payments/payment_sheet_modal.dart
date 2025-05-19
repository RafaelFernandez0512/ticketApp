import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/payment_controller.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/service/payment_service.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/notification_type.dart';

class PaymentSheetModal {
  static var _stripe = Get.find<Stripe>();
  static Future<String> _initPaymentSheet(
      BuildContext context, Reservation reservation) async {
    try {
      // 1. create payment intent on the server
      // 2. initialize the payment sheet
      final data = await Get.find<PaymentService>().createPaymentIntent(
          name: reservation.customer?.fullName ?? '',
          address: reservation.addressLine1From,
          zipcode: reservation.zipCodeFrom ?? '',
          city: reservation.cityFrom?.name ?? '',
          state: reservation.stateFrom?.name ?? '',
          country: 'US',
          currency: 'usd',
          description:
              'Payment for reservation number: ${reservation.reservationNumber}',
          amount: reservation.amount ?? 0);

      // 2. initialize the payment sheet
      await _stripe.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Enable custom flow
          customFlow: true,

          // Main params
          merchantDisplayName: 'Door to Door',
          paymentIntentClientSecret: data['client_secret'],
          customerId: data['customer'],
          // Extra options
          style: ThemeMode.light,
        ),
      );
      return data['id'].toString();
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

  static Future<bool> showModal(
      BuildContext context, Reservation reservation) async {
    EasyLoading.show(status: 'Loading...');
    var id = await _initPaymentSheet(context, reservation);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (id.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to payment sheet. Please try again.'),
        ),
      );
      return false;
    }
    EasyLoading.dismiss();
    try {
      // 3. display the payment sheet.
      await _stripe.presentPaymentSheet();
      await _stripe.confirmPaymentSheetPayment();
      if (context.mounted) {
        await Get.find<PaymentController>().onSubmit(
            reservation,
            'Payment for reservation number: ${reservation.reservationNumber}',
            id);
      }
      return true;
    } on Exception catch (e) {
      if (e is StripeException) {
        if (context.mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('${e.error.localizedMessage}'),
            ),
          );
          return false;
        } else {
          if (context.mounted) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Unforeseen error: $e'),
              ),
            );
            return false;
          }
        }
      }
    }
    return false;
  }
}
