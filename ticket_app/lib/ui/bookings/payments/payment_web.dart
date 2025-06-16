import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/payment_web_controller.dart';
import 'package:ticket_app/data/model/reservation.dart';




String getReturnUrl(Reservation reservation){
  Get.back(result: reservation);
  return'';
} 

Future<void> pay(Reservation reservation) async {
  await WebStripe.instance.confirmPaymentElement(
    ConfirmPaymentElementOptions(
      confirmParams: ConfirmPaymentParams(return_url: getReturnUrl(reservation)),
    ),
  );
}
class PaymentWeb extends GetView<PaymentWebController> {
  const PaymentWeb({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment for ${controller.reservation?.serviceType == 0 ? 'Travel' : 'Service'}',
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body:  Center(
            child: SizedBox(
              width: kIsWeb ? MediaQuery.of(context).size.width * 0.3 : MediaQuery.of(context).size.width,
              child: GetBuilder<PaymentWebController>(
                builder: (_) {
                 return controller.obx(
                    (state) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            PaymentElement(
                              autofocus: true,
                              enablePostalCode: true,
                              onCardChanged: (_) {},
                              clientSecret: state.toString(),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await pay(controller.reservation!);
                              },
                              icon: const Icon(Icons.payment),
                              label: const Text("Pay"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                    ),
                    onLoading: const Center(child: CircularProgressIndicator()),
                    onError: (error) => Center(child: Text("Error: $error")),
                  );
                }
              ),
            ),
          )
  
    );
  }

  
}