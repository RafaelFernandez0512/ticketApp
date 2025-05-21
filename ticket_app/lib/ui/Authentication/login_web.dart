import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/login_controller.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/Authentication/components/login_form.dart';
import 'package:ticket_app/utils/gaps.dart';

class LoginWeb extends GetView<LoginController> {
  const LoginWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: GetBuilder<LoginController>(builder: (_) {
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: controller.obx((state) {
                return Column(
                  children: [
                    gapH16,
                    SizedBox(
                      child: Image.asset('assets/logodoortodoor.png'),
                      height: 40.sp,
                    ),
                    gapH20,
                    gapH12,
                    SizedBox(
                      width: 60.sp,
                      child: LoginForm(
                        controller: controller,
                      ),
                    ),
                    gapH12,
                    SizedBox(
                          width: 60.sp,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                            child: Text('Forgot Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w900,
                                    )),
                          ),
                        ],
                      ),
                    ),
                    gapH20,
                    CustomButton(
                      onPressed: () => controller.login(),
                      label: 'Log in',
                      icon: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                    ),
                    gapH12,
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.SIGNUP);
                      },
                      child: Text("Sign Up",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              )),
                    )
                  ],
                );
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
          ),
        );
      })),
    );
  }
}
