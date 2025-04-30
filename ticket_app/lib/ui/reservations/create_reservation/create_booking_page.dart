import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/create_booking_controller.dart';
import 'package:ticket_app/data/model/travel.dart';
import 'package:ticket_app/ui/reservations/create_reservation/confirmation_ticket_view.dart';
import 'package:ticket_app/ui/reservations/create_reservation/reservation_form.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/notification_type.dart';

class CreateBookingPage extends GetView<CreateBookingController> {
  const CreateBookingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: GetBuilder<CreateBookingController>(
          builder: (_) {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Obx(
                () => Column(
                  children: [
                    EasyStepper(
                        lineStyle: LineStyle(lineLength: 50.sp),
                        activeStep: controller.activeStep.value,
                        showLoadingAnimation: false,
                        stepShape: StepShape.rRectangle,
                        steps: const [
                          EasyStep(
                            customStep:
                                Icon(Icons.departure_board, color: Colors.red),
                            title: 'Reservation',
                          ),
                          EasyStep(
                            customStep: Icon(Icons.check, color: Colors.red),
                            title: 'Confirmation',
                          ),
                        ]),
                    _buildStepContent(controller.activeStep.value),
                  ],
                ),
              ),
            ));
          },
        ));
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return Column(
          children: [
            ReservationForm(
              controller: controller,
            ),
            gapH30,
            CustomButton(
                type: NotificationType.success,
                label: 'Checkout',
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.nextStep();
                }),
          ],
        );
      case 1:
        return Column(
          children: [
            const Text('Booking Confirmation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            gapH16,
            ConfirmationTicketView(ticket: controller.createReservation.value),
            gapH20,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    type: NotificationType.normal,
                    label: 'Back',
                    iconAlignment: IconAlignment.start,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      controller.backStep();
                    },
                  ),
                ),
                gapW20,
                Expanded(
                  child: CustomButton(
                      type: NotificationType.success,
                      label: 'Confirm',
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      onPressed: controller.nextStep),
                ),
              ],
            )
          ],
        );
      default:
        return Container();
    }
  }
}
