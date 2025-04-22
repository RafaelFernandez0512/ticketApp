import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ticket_app/controller/splash_controller.dart';
import 'package:ticket_app/utils/gaps.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (_) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/logodoortodoor.png'),
              width: 200,
              height: 200,
            ),
            gapH20,
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 2.5,
            ),
          ],
        ),
      );
    });
  }
}
