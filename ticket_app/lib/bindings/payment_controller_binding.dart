import 'package:get/get.dart';
import 'package:ticket_app/controller/payment_web_controller.dart';

class PaymentControllerBinding implements Bindings {
  @override
  void dependencies() {
   Get.lazyPut <PaymentWebController>(()=> PaymentWebController());
      

  }
}