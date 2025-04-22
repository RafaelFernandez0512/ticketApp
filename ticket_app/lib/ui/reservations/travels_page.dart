import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ticket_app/controller/reservations_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/travel.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/ui/reservations/ticket_view.dart';
import 'package:ticket_app/ui/widgets/custom_bottom_segmented_control.dart';
import 'package:ticket_app/ui/widgets/custom_bottom_segmented_item.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/widgets/custom_datepicker.dart';
import 'package:ticket_app/ui/widgets/custom_dropdown.dart';
import 'package:ticket_app/ui/widgets/week_day_segmented_control.dart';
import 'package:ticket_app/utils/gaps.dart';

class TravelsPage extends StatelessWidget {
  final TravelsController controller = Get.find<TravelsController>();
  TravelsPage({super.key});
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
        title: Text('Reservations',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: controller.fetch(),
            builder: (context, snapshot) {
              return SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Obx(
                        () => Column(
                          children: [
                            CustomBottomSegmentedControl<int>(
                              children: headers.map((key, e) => MapEntry(
                                  key,
                                  CustomBottomSegmentedControlItem(
                                    icon: icons[key]!,
                                    text: e,
                                    isSelected:
                                        key == controller.serviceType.value,
                                  ))),
                              onValueChanged: (x) =>
                                  {controller.onChangeType(x)},
                            ),
                            gapH20,
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3))
                                  ]),
                              child: Column(
                                children: [
                                  gapH12,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: CustomDropdown<StateModel,
                                              String>(
                                            items: controller.states.toList(),
                                            onChanged:
                                                controller.onChangedFromState,
                                            labelText: 'From State',
                                            selectedItem: controller.states
                                                .where((x) =>
                                                    x.idState ==
                                                    controller.from?.idState)
                                                .firstOrNull
                                                ?.idState,
                                            showSearchBox: true,
                                            textEditingController:
                                                TextEditingController(),
                                            valueProperty: "Id_State",
                                            labelProperty: "Name",
                                            labelBuilder: (item) {
                                              return '${item!["Name"]}';
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        const Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Icon(Icons.arrow_forward),
                                        ),
                                        const SizedBox(
                                            width:
                                                3), // Espaciado entre los dos dropdowns
                                        Expanded(
                                          child: CustomDropdown<StateModel,
                                              String>(
                                            items: controller.states.toList(),
                                            onChanged:
                                                controller.onChangedToState,
                                            labelText: 'To State',
                                            selectedItem: controller.states
                                                .where((x) =>
                                                    x.name ==
                                                    controller.to?.name)
                                                .firstOrNull
                                                ?.idState,
                                            showSearchBox: true,
                                            textEditingController:
                                                TextEditingController(),
                                            valueProperty: "Id_State",
                                            labelProperty: "Name",
                                            labelBuilder: (item) {
                                              return '${item!["Name"]}';
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  gapH16,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: CustomDatePicker(
                                        finalDefaultValue:
                                            controller.selectedDate?.value,
                                        labelText: 'Date',
                                        onChanged: (x) {
                                          controller.onChangedDate(x);
                                        }),
                                  ),
                                  gapH16,
                                  CustomButton(
                                    label: 'Search',
                                    icon: Icon(Icons.search),
                                    onPressed: controller.onSearch,
                                  )
                                ],
                              ),
                            ),
                            gapH20,
                            controller.obx(
                                (state) => Column(
                                      children: (state as List<Travel>?)
                                              ?.map((x) => GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes.CREATE_BOOKING,
                                                          arguments: x);
                                                    },
                                                    child: TicketView(
                                                        ticket: x.toTicket()),
                                                  ))
                                              .toList() ??
                                          [],
                                    ),
                                onLoading: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircularProgressIndicator(),
                                          gapW16,
                                          Text(
                                            'Loading...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                onEmpty: Center(
                                  child: Text('No Reservations Found'),
                                ),
                                onError: (error) => Center(
                                        child: Text(
                                      error ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    )))
                          ],
                        ),
                      )));
            }),
      ),
    );
  }
}
