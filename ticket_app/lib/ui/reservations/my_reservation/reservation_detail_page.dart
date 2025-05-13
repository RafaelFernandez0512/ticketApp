import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/reservation_detail_controller.dart';
import 'package:ticket_app/ui/widgets/pdf_viewer_from_base_64.dart';

class ReservationDetailPage extends GetView<ReservationDetailController> {
  const ReservationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Reservation Detail : ${controller.reservation?.reservationNumber}',
              style: Theme.of(context).appBarTheme.titleTextStyle),
          centerTitle: true,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: GetBuilder<ReservationDetailController>(builder: (_) {
          return controller.obx((state) {
            return controller.state != null && controller.state!.isNotEmpty
                ? PDFViewerFromBase64(base64PDF: state!)
                : const Center(child: Text('No PDF available'));
          }, onLoading: const Center(child: CircularProgressIndicator()));
        }));
  }
}
