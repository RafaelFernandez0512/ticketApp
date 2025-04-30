import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/create_booking_controller.dart';
import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/customer_address.dart';
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
          FromOrToReservationForm(
            title: 'From',
            activeState: controller.active.value,
            addressLine1: controller.createReservation.value.fromAddressLine1,
            addressLine2: controller.createReservation.value.fromAddressLine2,
            idState: controller.createReservation.value.fromSate?.idState,
            idtown: controller.createReservation.value.fromTown?.idTown,
            zipCode: controller.createReservation.value.fromZipCode,
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
          ),
          gapH20,
          FromOrToReservationForm(
            title: 'To',
            addressLine1: controller.createReservation.value.toAddressLine1,
            addressLine2: controller.createReservation.value.toAddressLine2,
            idState: controller.createReservation.value.toState?.idState,
            idtown: controller.createReservation.value.toTown?.idTown,
            zipCode: controller.createReservation.value.toZipCode,
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
  final int? idtown;
  final String title;
  final int? idCustomerAddress;
  final List<StateModel> states;
  final List<Town> towns;
  final List<City> cities;
  final List<CustomerAddress> customerAddress;
  final String? zipCode;
  final int? city;
  final bool? activeState;
  final Function(String) onChangedAddressLine1;
  final Function(String) onChangedAddressLine2;
  final Function(StateModel?) onChangedState;
  final Function(Town?) onChangedTown;
  final Function(String) onChangedZipCode;
  final Function(CustomerAddress?) onChangedCustomerAddress;
  final bool disableAddress;

  final Function(City?) onChangedCity;

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
    required this.city,
    required this.cities,
    required this.onChangedCity,
    required this.idCustomerAddress,
    required this.customerAddress,
    required this.onChangedCustomerAddress,
    this.activeState = true,
    this.disableAddress = false,
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
              CustomDropdown<StateModel, String?>(
                items: states,
                onChanged: (x) async {
                  await onChangedState(
                      states.where((y) => y.idState == x).firstOrNull);
                },
                labelText: 'State',
                enabled: activeState ?? true,
                selectedItem: states
                    .where((x) => x.idState == idState)
                    .firstOrNull
                    ?.idState,
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_State",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
              CustomDropdown<City, int?>(
                items: cities,
                onChanged: (x) async {
                  await onChangedCity(
                      cities.where((y) => y.idCity == x).firstOrNull);
                },
                labelText: 'City',
                selectedItem:
                    cities.where((x) => x.idCity == city).firstOrNull?.idCity,
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_City",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
              CustomDropdown<Town, int?>(
                items: towns,
                onChanged: (x) {
                  onChangedTown(towns.where((y) => y.idTown == x).firstOrNull);
                },
                selectedItem: towns.isEmpty
                    ? towns.where((x) => x.idTown == idtown).firstOrNull?.idTown
                    : null,
                labelText: 'Town',
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_Town",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
              CustomDropdown<CustomerAddress, int?>(
                items: customerAddress,
                onChanged: (x) {
                  onChangedCustomerAddress(customerAddress
                      .where((y) => y.idCustomerAddress == x)
                      .firstOrNull);
                },
                labelText: 'Customer address',
                selectedItem: customerAddress
                    .where((x) => x.idCustomerAddress == idCustomerAddress)
                    .firstOrNull
                    ?.idCustomerAddress,
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_CustomerAddress",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
              CustomTextField(
                  readOnly: disableAddress,
                  initialValue: addressLine1,
                  keyboard: TextInputType.streetAddress,
                  labelText: 'Address Line 1',
                  onChanged: onChangedAddressLine1),
              CustomTextField(
                  readOnly: disableAddress,
                  initialValue: addressLine2,
                  keyboard: TextInputType.streetAddress,
                  labelText: 'Address Line 2',
                  onChanged: onChangedAddressLine2),
              CustomTextField(
                labelText: 'Zip Code',
                maxLength: 5,
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
