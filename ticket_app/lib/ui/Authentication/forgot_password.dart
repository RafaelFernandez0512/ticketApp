import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/forgot_password_controller.dart';
import 'package:ticket_app/ui/Authentication/verification_code.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/notification_type.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(child: GetBuilder<ForgotPasswordController>(builder: (_) {
        return SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: controller.obx(
            (state) {
              return Obx(() => Column(
                    children: [
                      gapH12,
                      Column(
                        children: [
                          EasyStepper(
                              lineStyle: LineStyle(lineLength: 35.sp),
                              activeStep: controller.activeStep.value,
                              showLoadingAnimation: false,
                              stepShape: StepShape.rRectangle,
                              finishedStepBackgroundColor: Color(0xfFF5733),
                              steps: const [
                                EasyStep(
                                  customStep:
                                      Icon(Icons.person, color: Colors.red),
                                  title: 'Email',
                                ),
                                EasyStep(
                                  customStep:
                                      Icon(Icons.verified, color: Colors.red),
                                  title: 'Verification',
                                ),
                                EasyStep(
                                  customStep:
                                      Icon(Icons.directions, color: Colors.red),
                                  title: 'Change Password',
                                ),
                              ]),
                          _buildStepContent(controller.activeStep.value),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: controller.activeStep.value != 0,
                                child: CustomButton(
                                  onPressed: () => controller.backStep(),
                                  label: controller.activeStep.value == 0
                                      ? 'Cancel'
                                      : 'Back',
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  type: NotificationType.error,
                                  iconAlignment: IconAlignment.start,
                                ),
                              ),
                              gapW16,
                              CustomButton(
                                onPressed: () async =>
                                    await controller.nextStep(),
                                label: controller.activeStep.value == 2
                                    ? 'Confirm'
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
          ),
        ));
      })),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return Column(
          children: [
            CustomTextField(
              labelText: 'Email',
              initialValue: controller.forgotPasswordModel.value.email,
              onChanged: (text) => {controller.onChangeEmail(text)},
            ),
            gapH30
          ],
        );
      case 1:
        return Column(
          children: [
            VerificationCode(
              username: controller.forgotPasswordModel.value.email!,
              onCompleted: (s) => controller.onChangeCode(s),
              verificationCode: controller.verificationCode,
              resendCode: () async {
                await controller.sendCode();
              },
            ),
            gapH30
          ],
        );

      case 2:
        return Column(
          children: [
            gapH20,
            CustomTextField(
              labelText: 'Password',
              onChanged: (text) => {controller.onChangeEmail(text)},
            ),
            gapH20,
            CustomTextField(
              labelText: 'Confirm Password',
              onChanged: (text) => {controller.onChangeEmail(text)},
            ),
            gapH30,
          ],
        );
      default:
        return Container();
    }
  }
}
