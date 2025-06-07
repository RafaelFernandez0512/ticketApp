import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ticket_app/controller/home_controller.dart';
import 'package:ticket_app/controller/my_bookings_controller.dart';
import 'package:ticket_app/controller/reservations_controller.dart';
import 'package:ticket_app/controller/settings_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/ui/home_page_mobile.dart';
import 'package:ticket_app/ui/home_page_web.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});
  final travelController = Get.find<TravelsController>();
  final reservationController = Get.find<MyBookingsController>();
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
     var web = kIsWeb;
    return MaterialApp(
      title: '',
      theme: CustomTheme.lightTheme,
      home:  kIsWeb? HomePageWeb(controller: controller,) :HomePageMobile(controller: controller,) );
  }
}
