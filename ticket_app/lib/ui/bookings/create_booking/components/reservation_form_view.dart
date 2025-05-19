import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/create_booking_controller.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/ui/bookings/create_booking/components/basic_form_booking_view.dart';
import 'package:ticket_app/ui/widgets/custom_datepicker.dart';
import 'package:ticket_app/ui/widgets/custom_dropdown.dart';
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
          Row(
            children: [
              Expanded(
                child: CustomDatePicker(
                    finalDefaultValue: controller.createReservation.value.date,
                    labelText: 'Date',
                    enabled: controller.active.value,
                    onChanged: (x) {
                      controller.onChangedDate(x);
                    }),
              ),
              gapW12,
              Expanded(
                child: CustomDropdown<Schedule, String>(
                  items: controller.schedule,
                  enabled: false,
                  onChanged: (x) => controller.onChangeHour(controller.schedule
                      .where((y) => y.hour == x)
                      .firstOrNull),
                  labelText: 'Time',
                  selectedItem: controller.createReservation.value.hour?.hour,
                  showSearchBox: false,
                  valueProperty: "Hour",
                  labelProperty: "Hour",
                  labelBuilder: (item) {
                    return '${item!["Hour"]}';
                  },
                ),
              ),
            ],
          ),
          gapH16,
          ItemCount(
            labelText: 'Passengers',
            decimalPlaces: 0,
            initialValue:
                controller.createReservation.value.passengerCount ?? 1,
            minValue: 1,
            maxValue: 10,
            step: 1,
            onChanged: (x) {
              controller.onChangedPassengerCount(x);
            },
          ),
          gapH16,
          BasicFormBookingView(
            title: 'From',
            activeState: controller.active.value,
            addressLine1: controller.addressLine1From,
            addressLine2: controller.addressLine2From,
            idState: controller.createReservation.value.fromSate?.idState,
            idtown: controller.createReservation.value.fromTown?.idTown,
            zipCode: controller.fromZipCode,
            states: controller.states,
            towns: controller.townsFrom,
            onChangedAddressLine1: (x) {
              controller.onFromChangedAddressLine1(x);
            },
            onChangedAddressLine2: (x) {
              controller.onFromChangedAddressLine2(x);
            },
            onChangedState: (x) async {
              await controller.onChangeFromState(x);
            },
            onChangedTown: (x) {
              controller.onFromTown(x);
            },
            onChangedZipCode: (x) {
              controller.onFromZipCode(x);
            },
            onChangedCity: (x) async {
              await controller.onChangeFromCity(x);
            },
            cities: controller.citiesFrom,
            city: controller.createReservation.value.fromCity?.idCity,
            customerAddress: controller.customerAddressFrom,
            idCustomerAddress:
                controller.createReservation.value.idCustomerAddress,
            onChangedCustomerAddress: (x) {
              controller.onFromCustomerAddress(x);
            },
            disableAddress: controller.disableAddress.value,
            cleanCustomerAddress: () => controller.cleanCustomerAddressFrom(),
          ),
          gapH20,
          BasicFormBookingView(
            title: 'To',
            addressLine1: controller.toAddressLine1,
            addressLine2: controller.toAddressLine2,
            idState: controller.createReservation.value.toState?.idState,
            idtown: controller.createReservation.value.toTown?.idTown,
            zipCode: controller.toZipCode,
            states: controller.states,
            activeState: controller.active.value,
            towns: controller.townsTo,
            onChangedAddressLine1: (x) {
              controller.onToChangedAddressLine1(x);
            },
            onChangedAddressLine2: (x) {
              controller.onToChangedAddressLine2(x);
            },
            onChangedState: (x) async {
              await controller.onChangeToState(x);
            },
            onChangedTown: (x) {
              controller.onToTown(x);
            },
            onChangedZipCode: (x) {
              controller.onToZipCode(x);
            },
            cities: controller.citiesTo,
            onChangedCity: (x) async {
              await controller.onChangeToCity(x);
            },
            city: controller.createReservation.value.toCity?.idCity,
            customerAddress: controller.customerAddressTo,
            idCustomerAddress:
                controller.createReservation.value.idCustomerAddressTo,
            onChangedCustomerAddress: (x) {
              controller.onToCustomerAddress(x);
            },
            disableAddress: controller.disableAddressTo.value,
            cleanCustomerAddress: () => controller.cleanCustomerAddressTo(),
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


