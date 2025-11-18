import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/create_booking_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/data/model/Item_type.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/ui/bookings/create_booking/components/basic_form_booking_view.dart';
import 'package:ticket_app/ui/widgets/custom_checkbox.dart';
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
          Visibility(
            visible: controller.createReservation.value.serviceType == 0,
            child: ItemCount(
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
          ),
          Visibility(
            visible: controller.createReservation.value.serviceType == 1,
            child: Column(
              children: [
                CustomDropdown<ItemType, int>(
                  items: controller.items,
                  onChanged: (x) => controller.onChangeItem(x),
                  labelText: 'Item',
                  selectedItem: controller.createReservation.value.items,
                  showSearchBox: false,
                  valueProperty: "Id_Item",
                  labelProperty: "Id_Item",
                  labelBuilder: (item) {
                    return '${item!["Description"]}';
                  },
                ),
                gapH16,
                ItemCount(
                  labelText: 'Quantity',
                  decimalPlaces: 0,
                  initialValue:
                      controller.createReservation.value.quantity ?? 1,
                  minValue: 1,
                  maxValue: 10,
                  step: 1,
                  onChanged: (x) {
                    controller.onChangedItemsCount(x);
                  },
                ),
                gapH16,
                DottedBorder(
                  child: SizedBox(
                    height: 50.sp,
                    width: 70.sp,
                    child: Padding(
                      padding: EdgeInsets.all(2.sp),
                      child: GestureDetector(
                        onTap: () => controller.pickPhoto(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            controller.createReservation.value.photo != null
                                ? Obx(() => Image.memory(
                                    base64Decode(controller
                                        .createReservation.value.photo!),
                                    height: 45.sp,
                                    width: 70.sp))
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                        CustomTheme.primaryLightColor,
                                    child: Icon(
                                      Icons.add_photo_alternate,
                                      size: 50,
                                      color: CustomTheme.white,
                                    ),
                                  ),
                            if (controller.createReservation.value.photo ==
                                null)
                              Text(
                                'Press to add image',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey.shade700),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                gapH16,
                CustomTextField(
                    keyboard: TextInputType.streetAddress,
                    labelText: 'Description',
                    maxLength: 250,
                    controller: TextEditingController(
                        text: controller.createReservation.value.description),
                    onChanged: controller.onDescription),
              ],
            ),
          ),
          gapH16,
          BasicFormBookingView(
            title: 'From',
            activeState: controller.active.value,
            addressLine1: controller.addressLine1From,
            addressLine2: '',
            idState: controller.createReservation.value.fromSate?.idState,
            zipCode: controller.createReservation.value.fromZipCode,
            states: controller.states,
            zipCodes:controller.zipcodesFrom ,
            onChangedAddressLine1: (x) {
              controller.onFromChangedAddressLine1(x);
            },
            onChangedAddressLine2: (x) {
              controller.onFromChangedAddressLine2(x);
            },
            onChangedState: (x) async {
              await controller.onChangeFromState(x);
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
            disableAddress: controller.disableAddress.value ,
            cleanCustomerAddress: () => controller.cleanCustomerAddressFrom(),
          ),
          gapH20,
          BasicFormBookingView(
            title: 'To',
             zipCodes:controller.zipcodesTo ,
            addressLine1: controller.toAddressLine1,
            addressLine2: '',
            idState: controller.createReservation.value.toState?.idState,
            zipCode: controller.createReservation.value.toZipCode,
            states: controller.states,
            activeState: controller.active.value,
            onChangedAddressLine1: (x) {
              controller.onToChangedAddressLine1(x);
            },
            onChangedAddressLine2: (x) {
              controller.onToChangedAddressLine2(x);
            },
            onChangedState: (x) async {
              await controller.onChangeToState(x);
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
            disableAddress: controller.disableAddressTo.value|| (!controller.disableAddressTo.value && !controller.fromValueComplete()),
            cleanCustomerAddress: () => controller.cleanCustomerAddressTo(),
          ),
          gapH12,
          Visibility(
            visible: controller.createReservation.value.comment?.isNotEmpty?? false,
            child: CustomCheckbox(
              label: controller.createReservation.value.comment,
              value: controller.additional.value,
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w600),
              labelToLeft: true,
              onChanged:  (x) {
                      controller.onChangeAdditional(x ?? false);
                    },
            ),
          ),
          gapH12,
          Visibility(
            visible: controller.createReservation.value.serviceType == 0,
            child: ItemCount(
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
          ),
               gapH16,
           Row(
             children: [
               Text(
                'Amount:',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      
                    ),),
                    Spacer(),
                       Padding(
                         padding:  EdgeInsets.symmetric(horizontal:  10.0.sp),
                         child: Text(
                                          controller.formatMoney(controller.totalAmount.value),
                                         style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                               fontWeight: FontWeight.w600,
                                               color: Colors.redAccent
                                               
                                             ),),
                       ),
             ],
           ),
        ],
      ),
    ));
  }
}
