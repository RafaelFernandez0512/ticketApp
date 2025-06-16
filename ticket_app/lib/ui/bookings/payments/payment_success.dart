import 'dart:html' as web;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/payment_controller.dart';
import 'package:ticket_app/data/service/payment_service.dart';
import 'package:ticket_app/utils/gaps.dart';

class PaymentSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final uri = Uri.parse(web.window.location.href);
    final params = uri.queryParameters;

    final secretclient = params['secretClient'] ?? '';
    final reservationNumber = int.parse(params['reservationNumber'] ?? '0');
   final amount = params['amount'] ?? '';
    final serviceType = params['serviceType'];
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Get.find<PaymentController>().onSubmitWeb(reservationNumber, double.tryParse(amount) ?? 0, int.parse(serviceType ?? '0'), 'Payment for reservation number: $reservationNumber', secretclient),
          builder: (context, data) => data==null || (data.isBlank??true)?  const CircularProgressIndicator(): Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
             const Icon(Icons.check_circle, size: 100, color: Colors.green),
             gapH20,
             const Text('Your payment was successful!',
                  style: TextStyle(fontSize: 24)),
               gapH20,
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/home'); // Navigate to home page
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}

