import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/payment_controller.dart';
import 'package:ticket_app/utils/gaps.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String? secretClient;
  final int? reservationNumber;
  final double? amount;
  final int? serviceType;

  const PaymentSuccessPage({
    super.key,
    this.secretClient,
    this.reservationNumber,
    this.amount,
    this.serviceType,
  });

  // Helpers de parseo seguros
  int _toInt(dynamic v, [int def = 0]) {
    if (v == null) return def;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? def;
  }

  double _toDouble(dynamic v, [double def = 0]) {
    if (v == null) return def;
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? def;
  }

  String _toString(dynamic v, [String def = '']) {
    if (v == null) return def;
    return v.toString();
  }

  Map<String, dynamic> _mergedParams() {
    final map = <String, dynamic>{};

    // 1) Query params en Web (GetX los expone como strings)
    map.addAll(Get.parameters);

    // 2) Arguments en navegación móvil/escritorio
    if (Get.arguments is Map) {
      map.addAll(Get.arguments);
    }

    // 3) Props del constructor como fallback
    if (secretClient != null) map['secretClient'] = secretClient;
    if (reservationNumber != null) map['reservationNumber'] = reservationNumber;
    if (amount != null) map['amount'] = amount;
    if (serviceType != null) map['serviceType'] = serviceType;

    return map;
  }

  @override
  Widget build(BuildContext context) {
    final params = _mergedParams();

    final String secret = _toString(params['secretClient']);
    final int reservation = _toInt(params['reservationNumber']);
    final double amt = _toDouble(params['amount']);
    final int svcType = _toInt(params['serviceType']);

    final String description =
        'Payment for reservation number: $reservation';

    final future = Get.find<PaymentController>().onSubmitWeb(
      reservation,
      amt,
      svcType,
      description,
      secret,
    );

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 72, color: Colors.red),
                  gapH12,
                  Text(
                    'There was a problem processing your payment.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  gapH8,
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  gapH20,
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed('/home'),
                    child: const Text('Close'),
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 100, color: Colors.green),
                gapH20,
                const Text('Your payment was successful!',
                    style: TextStyle(fontSize: 24)),
                gapH20,
                ElevatedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
