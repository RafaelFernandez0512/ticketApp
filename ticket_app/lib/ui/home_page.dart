import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/home_controller.dart';
import 'package:ticket_app/controller/login_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/ui/reservations/my_bookings_page.dart';
import 'package:ticket_app/ui/reservations/travels_page.dart';
import 'package:ticket_app/ui/setting/settings_page.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/Authentication/components/login_form.dart';
import 'package:ticket_app/utils/gaps.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: CustomTheme.lightTheme,
      home: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: TravelsPage(),
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Travels",
            ),
          ),
          PersistentTabConfig(
            screen: MyBookingsPage(),
            item: ItemConfig(
              icon: Icon(Icons.message),
              title: "My Bookings",
            ),
          ),
          PersistentTabConfig(
            screen: SettingsPage(),
            item: ItemConfig(
              icon: Icon(Icons.settings),
              title: "Settings",
            ),
          ),
        ],
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
