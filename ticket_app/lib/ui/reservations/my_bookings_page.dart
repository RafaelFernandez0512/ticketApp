import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/my_bookings_controller.dart';
import 'package:ticket_app/ui/reservations/my_reservation/my_ticket_reservation_view.dart';

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
                      EasyTheme(
                        data: EasyTheme.of(context).copyWith(
                          timelineOptions: const TimelineOptions(
                            height: 64.0,
                          ),
                          currentDayForegroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              // return the background color of the selected current day
                              return Colors.white;
                            }
                            // return the background color of the normal current day
                            return Colors.black;
                          }),
                          currentDayShape:
                              const WidgetStatePropertyAll(CircleBorder()),
                          dayShape:
                              const WidgetStatePropertyAll(CircleBorder()),
                          dayBorder: WidgetStatePropertyAll(
                            BorderSide(
                              color: Colors.teal.shade50,
                            ),
                          ),
                        ),
                        child: EasyDateTimeLinePicker(
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 90)),
                          lastDate: DateTime(2030, 3, 18),
                          currentDate: controller.selectedDate?.value,
                          focusedDate: DateTime.now(),
                          onDateChange: (selectedDate) async {
                            await controller.onChangeDate(selectedDate);
                          },
                        ),
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
