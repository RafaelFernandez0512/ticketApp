import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:ticket_app/controller/home_controller.dart';
import 'package:ticket_app/controller/my_bookings_controller.dart';
import 'package:ticket_app/controller/reservations_controller.dart';
import 'package:ticket_app/controller/settings_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/ui/bookings/my_bookings/my_bookings_page.dart';
import 'package:ticket_app/ui/bookings/travels/travels_page.dart';
import 'package:ticket_app/ui/settings/settings_page.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});
  var travelController = Get.find<TravelsController>();
  var reservationController = Get.find<MyBookingsController>();
  var settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: CustomTheme.lightTheme,
      home: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: TravelsPage(
              controller: travelController,
            ),
            item: ItemConfig(
                icon: Icon(Icons.home),
                title: "Travels",
                activeForegroundColor: Colors.white),
          ),
          PersistentTabConfig(
            screen: MyBookingsPage(
              controller: reservationController,
            ),
            item: ItemConfig(
                activeColorSecondary: Colors.white,
                icon: Icon(Icons.message),
                title: "My Bookings",
                activeForegroundColor: Colors.white),
          ),
          PersistentTabConfig(
            screen: SettingsPage(
              controller: settingsController,
            ),
            item: ItemConfig(
                icon: Icon(Icons.settings),
                title: "Settings",
                activeForegroundColor: Colors.white),
          ),
        ],
        onTabChanged: (index) async {
          await Future.delayed(Duration.zero, () async {
            if (index == 0) {
              await travelController.onSearch();
            } else if (index == 1) {
              reservationController.selectedDate = DateTime.now().obs;
              await reservationController.fetch();
            } else if (index == 2) {
              await settingsController.loadData();
            }
          });
        },
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        ),
      ),
    );
  }
}
