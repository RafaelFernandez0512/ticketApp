import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/my_bookings_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/ui/reservations/my_reservation/my_ticket_reservation_view.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/utils.dart';

class MyBookingsPage extends GetView<MyBookingsController> {
  @override
  final MyBookingsController controller;
  MyBookingsPage({super.key, required this.controller});
  Map<int, String> headers = {
    0: 'Travels',
    1: 'Services',
  };
  Map<int, IconData> icons = {
    0: Icons.directions_bus_filled_sharp,
    1: Icons.directions_bus_filled_sharp,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reservations',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      body: GetBuilder<MyBookingsController>(
        init: controller,
        builder: (_) {
          return SafeArea(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Column(
                    children: [
                      EasyInfiniteDateTimeLine(
                        selectionMode: const SelectionMode.autoCenter(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 50)),
                        focusDate: controller.selectedDate?.value,
                        lastDate: DateTime.now().add(const Duration(days: 300)),
                        onDateChange: (selectedDate) {
                          controller.onChangeDate(selectedDate);
                        },
                        headerBuilder: (context, date) {
                          return Column(
                            children: [
                              gapH12,
                              Text(
                                formatDateName(date.toString()),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              gapH12
                            ],
                          );
                        },
                        dayProps: const EasyDayProps(
                          // You must specify the width in this case.
                          width: 64.0,
                          // The height is not required in this case.
                          height: 64.0,
                        ),
                        itemBuilder: (
                          BuildContext context,
                          DateTime date,
                          bool isSelected,
                          VoidCallback onTap,
                        ) {
                          return InkResponse(
                            // You can use `InkResponse` to make your widget clickable.
                            // The `onTap` callback responsible for triggering the `onDateChange`
                            // callback and animating to the selected date if the `selectionMode` is
                            // SelectionMode.autoCenter() or SelectionMode.alwaysFirst().
                            onTap: onTap,
                            child: CircleAvatar(
                              // use `isSelected` to specify whether the widget is selected or not.
                              backgroundColor: isSelected
                                  ? CustomTheme.primaryLightColor
                                  : CustomTheme.primaryLightColor
                                      .withOpacity(0.1),
                              radius: 32.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : null,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      EasyDateFormatter.shortDayName(
                                          date, "en_US"),
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      controller.obx(
                        (state) => Expanded(
                          child: ListView.builder(
                            itemCount: state!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.onTap(index);
                                },
                                child: MyTicketReservationView(
                                  ticket: state[index],
                                  onTapPayment: () async {
                                    await controller.onPayment(
                                        context, state[index]);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        onLoading: const CircularProgressIndicator(),
                      )
                    ],
                  )));
        },
      ),
    );
  }
}
