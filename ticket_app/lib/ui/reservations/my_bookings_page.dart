import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ticket_app/controller/my_reservations_controller.dart';
import 'package:ticket_app/controller/reservations_controller.dart';
import 'package:ticket_app/ui/widgets/custom_bottom_segmented_control.dart';
import 'package:ticket_app/ui/widgets/custom_bottom_segmented_item.dart';
import 'package:ticket_app/utils/gaps.dart';

class MyBookingsPage extends StatelessWidget {
  final MyReservationsController controller =
      Get.find<MyReservationsController>();
  MyBookingsPage({super.key});
  Map<String, String> headers = {
    '0': 'Travels',
    '1': 'Services',
  };
  Map<String, IconData> icons = {
    '0': Icons.directions_bus_filled_sharp,
    '1': Icons.speed,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  CustomBottomSegmentedControl<String>(
                    children: headers.map((key, e) => MapEntry(
                        key,
                        CustomBottomSegmentedControlItem(
                          icon:null,
                          text: e,
                          isSelected: true,
                        ))),
                    onValueChanged: (x) => {},
                  )
                ],
              ))),
    );
  }
}
