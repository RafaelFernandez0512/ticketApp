
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:ticket_app/controller/booking_pdf_controller.dart';
import 'package:ticket_app/controller/payment_controller.dart';

class BookingPdfPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingPdfPageController>(() => BookingPdfPageController());

  }
}
class SuccessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());

  }
}
