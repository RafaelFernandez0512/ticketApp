import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/sign_up_controller.dart';
import 'package:ticket_app/ui/Authentication/components/verification_code.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/Authentication/components/sign_up_form.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/notification_type.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            controller.backStep();
          },
        ),
      ),
      body: SafeArea(child: GetBuilder<SignUpController>(builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: controller.obx((state) {
              return Obx(() => Column(
                    children: [
                      gapH12,
                      Column(
                        children: [
                          EasyStepper(
                              lineStyle: LineStyle(lineLength: 50.sp),
                              activeStep: controller.activeStep.value,
                              showLoadingAnimation: false,
                              stepShape: StepShape.rRectangle,
                              finishedStepTextColor: Colors.grey,
                              finishedStepBackgroundColor: Color(0xfFF5733),
                              steps: const [
                                EasyStep(
                                  customStep:
                                      Icon(Icons.person, color: Colors.red),
                                  title: 'Information',
                                ),
                                EasyStep(
                                  customStep:
                                      Icon(Icons.verified, color: Colors.red),
                                  title: 'Verification',
                                ),
                                EasyStep(
                                  customStep:
                                      Icon(Icons.directions, color: Colors.red),
                                  title: 'Address',
                                ),
                              ]),
                          SizedBox(width: kIsWeb? MediaQuery.of(context).size.width*0.3:MediaQuery.of(context).size.width, child:  _buildStepContent(controller.activeStep.value)),

                          gapH16,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              gapW16,
                              CustomButton(
                                onPressed: () async =>
                                    await controller.nextStep(),
                                label: controller.activeStep.value == 2
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
            VerificationCode(
              username: controller.userRegister.value.email ?? '',
              onCompleted: (s) => controller.verifyCode(s),
              verificationCode: controller.verificationCode.value,
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
            RegisterAddressForm(
              onChangedAddressLine1: controller.onChangeAddressLine1,
              onChangedAddressLine2: controller.onChangeAddressLine2,
              onChangedState: controller.onChangeState,
              onChangedTown: controller.onChangeTown,
              onChangedCity: controller.onChangeCity,
              onChangedZipCode: controller.onChangeZipCode,
              state: controller.userRegister.value.state ?? '',
              city: controller.userRegister.value.city ?? 0,
              town: controller.userRegister.value.town ?? 0,
              addressLine1: controller.userRegister.value.addressLine1 ?? '',
              addressLine2: controller.userRegister.value.addressLine2 ?? '',
            ),
            gapH20,
          ],
        );
      default:
        return Container();
    }
  }
}
