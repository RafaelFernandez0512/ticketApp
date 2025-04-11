import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/sign_up_controller.dart';
import 'package:ticket_app/ui/Authentication/verification_code.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/Authentication/components/sign_up_form.dart';
import 'package:ticket_app/utils/gaps.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: GetBuilder<SignUpController>(builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: controller.obx((state) {
              return Obx(() => Column(
                    children: [
                      Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Column(
                        children: [
                          EasyStepper(
                              lineStyle: LineStyle(lineLength: 50.sp),
                              activeStep: controller.activeStep.value,
                              showLoadingAnimation: false,
                              stepShape: StepShape.rRectangle,
                              steps: const [
                                EasyStep(
                                  customStep:
                                      Icon(Icons.person, color: Colors.red),
                                  title: 'Personal Information',
                                ),
                                EasyStep(
                                  customStep:
                                      Icon(Icons.directions, color: Colors.red),
                                  title: 'Address Information',
                                ),
                              ]),
                          _buildStepContent(controller.activeStep.value),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                onPressed: () => controller.backStep(),
                                label: controller.activeStep.value == 0
                                    ? 'Cancel'
                                    : 'Back',
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                iconAlignment: IconAlignment.start,
                              ),
                              gapW16,
                              CustomButton(
                                onPressed: () async =>
                                    await controller.nextStep(),
                                label: controller.activeStep.value == 1
                                    ? 'Register'
                                    : 'Continue',
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ));
            },
                onLoading: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image.asset('assets/logodoortodoor.png'),
                        height: 60.sp,
                      ),
                      gapH20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          gapW16,
                          Text(
                            'Loading...',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        );
      })),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return Column(
          children: [
            RegisterClientForm(controller: controller),
            gapH20,
          ],
        );
         case 1:
        return Column(
          children: [
            VerificationCode(),
            gapH20,
          ],
        );
      case 2:
        return Column(
          children: [
            gapH20,
            RegisterAddressForm(
              onChangedAddressLine1: controller.onChangeAddressLine1,
              onChangedAddressLine2: controller.onChangeAddressLine2,
              onChangedState: controller.onChangeState,
              onChangedTown: controller.onChangeTown,
              onChangedZipCode: controller.onChangeZipCode,
            ),
            gapH20,
          ],
        );
      default:
        return Container();
    }
  }
}
