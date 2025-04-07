import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/create_booking_controller.dart';
import 'package:ticket_app/data/model/travel.dart';

class CreateBookingPage extends GetView<CreateBookingController> {
  const CreateBookingPage({super.key});
  @override
  Widget build(BuildContext context) {
    final Travel travel = Get.arguments as Travel;
    controller.travel = travel;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Booking'),
        ),
        body: GetBuilder<CreateBookingController>(
          builder: (_) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
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
                            customStep:
                                Icon(Icons.airport_shuttle, color: Colors.red),
                            title: 'Confirmation',
                          ),
                        ]),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
