import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/create_booking_controller.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/service_type.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/ui/widgets/custom_datepicker.dart';
import 'package:ticket_app/ui/widgets/custom_dropdown.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';
import 'package:ticket_app/ui/widgets/item_count.dart';
import 'package:ticket_app/utils/gaps.dart';

class ReservationForm extends StatelessWidget {
  final CreateBookingController controller;
  const ReservationForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(
      () => Column(
        children: [
          CustomDropdown<ServiceType, int>(
            items: controller.service,
            onChanged: (x) => controller.onChangeServiceType(x!),
            labelText: 'Service',
            selectedItem: controller.createReservation.value.serviceType,
            showSearchBox: false,
            valueProperty: "id",
            labelProperty: "Name",
            labelBuilder: (item) {
              return '${item!["Name"]}';
            },
          ),
          gapH12,
          Row(
            children: [
              Expanded(
                child: CustomDatePicker(
                    finalDefaultValue: controller.createReservation.value.date,
                    labelText: 'Date',
                    onChanged: (x) {
                      controller.onChangedDate(x);
                    }),
              ),
              gapW12,
              Expanded(
                child: CustomDropdown<Schedule, String>(
                  items: controller.schedule,
                  onChanged: (x) => controller.onChangeHour(x!),
                  labelText: 'Time',
                  selectedItem: controller.createReservation.value.hour,
                  showSearchBox: false,
                  valueProperty: "hour",
                  labelProperty: "Hour",
                  labelBuilder: (item) {
                    return '${item!["Hour"]}';
                  },
                ),
              ),
            ],
          ),
          gapH12,
          ItemCount(
            labelText: 'Passengers',
            decimalPlaces: 0,
            initialValue:
                controller.createReservation.value.passengerCount ?? 0,
            minValue: 0,
            maxValue: 10,
            step: 1,
            onChanged: (x) {
              controller.onChangedPassengerCount(x);
            },
          ),
          gapH12,
          FromOrToReservationForm(
            title: 'From',
            addressLine1: controller.createReservation.value.fromAddressLine1,
            addressLine2: controller.createReservation.value.fromAddressLine2,
            idState: controller.createReservation.value.idFromSate,
            idtown: controller.createReservation.value.idFromTown,
            zipCode: controller.createReservation.value.fromZipCode,
            states: controller.states,
            towns: controller.towns,
            onChangedAddressLine1: (x) {
              controller.onFromChangedAddressLine1(x);
            },
            onChangedAddressLine2: (x) {
              controller.onFromChangedAddressLine2(x);
            },
            onChangedState: (x) {
              controller.onChangeFromState(x);
            },
            onChangedTown: (x) {
              controller.onFromTown(x);
            },
            onChangedZipCode: (x) {
              controller.onToZipCode(x);
            },
          ),
          gapH20,
          FromOrToReservationForm(
            title: 'To',
            addressLine1: controller.createReservation.value.toAddressLine1,
            addressLine2: controller.createReservation.value.toAddressLine2,
            idState: controller.createReservation.value.idToSate,
            idtown: controller.createReservation.value.idToTown,
            zipCode: controller.createReservation.value.toZipCode,
            states: controller.states,
            towns: controller.towns,
            onChangedAddressLine1: (x) {
              controller.onToChangedAddressLine1(x);
            },
            onChangedAddressLine2: (x) {
              controller.onToChangedAddressLine2(x);
            },
            onChangedState: (x) {
              controller.onChangeToState(x);
            },
            onChangedTown: (x) {
              controller.onToTown(x);
            },
            onChangedZipCode: (x) {
              controller.onToZipCode(x);
            },
          ),
          gapH12,
          ItemCount(
            labelText: 'Bags',
            initialValue: controller.createReservation.value.bagsCount ?? 0,
            decimalPlaces: 0,
            minValue: 0,
            maxValue: 10,
            step: 1,
            onChanged: (x) {
              controller.onChangedBagsCount(x);
            },
          ),
        ],
      ),
    ));
  }
}

class FromOrToReservationForm extends StatelessWidget {
  final String? addressLine1;
  final String? addressLine2;
  final String? idState;
  final String? idtown;
  final String title;
  final List<StateModel> states;
  final List<Town> towns;
  final String? zipCode;
  final Function(String) onChangedAddressLine1;
  final Function(String) onChangedAddressLine2;
  final Function(String?) onChangedState;
  final Function(String?) onChangedTown;
  final Function(String) onChangedZipCode;

  const FromOrToReservationForm({
    super.key,
    required this.title,
    required this.addressLine1,
    required this.addressLine2,
    required this.idState,
    required this.idtown,
    required this.states,
    required this.towns,
    required this.onChangedAddressLine1,
    required this.onChangedAddressLine2,
    required this.onChangedState,
    required this.onChangedTown,
    required this.onChangedZipCode,
    required this.zipCode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 10,
            children: [
              CustomDropdown<StateModel, String>(
                items: states,
                onChanged: onChangedState,
                labelText: 'State',
                selectedItem:
                    states.where((x) => x.name == idState).firstOrNull?.idState,
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_State",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
              CustomDropdown<Town, String>(
                items: towns,
                onChanged: onChangedTown,
                selectedItem:
                    towns.where((x) => x.name == idtown).firstOrNull?.idTown,
                labelText: 'Town',
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_Town",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
              CustomDropdown<StateModel, String>(
                items: states,
                onChanged: onChangedState,
                labelText: 'Customer address',
                selectedItem:
                    states.where((x) => x.name == idState).firstOrNull?.idState,
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_State",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
              CustomTextField(
                  initialValue: addressLine1,
                  keyboard: TextInputType.streetAddress,
                  labelText: 'Address Line 1',
                  onChanged: onChangedAddressLine1),
              CustomTextField(
                  initialValue: addressLine2,
                  keyboard: TextInputType.streetAddress,
                  labelText: 'Address Line 2',
                  onChanged: onChangedAddressLine2),
              CustomTextField(
                labelText: 'Zip Code',
                onChanged: onChangedZipCode,
                initialValue: zipCode,
              ),
            ],
          ),
        ),
        Positioned(
            top: -10, // para superponerlo encima del borde
            right: 16,
            child: Container(
              color: Colors
                  .white, // el fondo debe coincidir con el fondo del cuadro
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
              ),
            )),
      ],
    );
  }
}
