import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/edit_profile_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/widgets/custom_datepicker.dart';
import 'package:ticket_app/ui/widgets/custom_dropdown.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/notification_type.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: GetBuilder<EditProfileController>(
            builder: (_) {
              return controller.obx(
                  (state) => SingleChildScrollView(
                        child: Column(spacing: 20, children: [
                          GestureDetector(
                            onTap: controller.getPhoto,
                            child: controller.customerRx?.value?.photo != null
                                ? Obx(
                                    () => CircleAvatar(
                                      radius: 50,
                                      backgroundImage: MemoryImage(base64Decode(
                                          controller
                                              .customerRx!.value!.photo!)),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        CustomTheme.primaryLightColor,
                                    child: Icon(
                                      Icons.add_photo_alternate,
                                      size: 50,
                                      color: CustomTheme.white,
                                    ),
                                  ),
                          ),
                          gapH12,
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                    labelText: 'First Name',
                                    initialValue:
                                        controller.customerRx?.value?.firstName,
                                    onChanged: (p) {
                                      controller.onChangeName(p);
                                    }),
                              ),
                              gapW16,
                              Expanded(
                                child: CustomTextField(
                                    labelText: 'Middle Name',
                                    initialValue: controller
                                        .customerRx?.value?.middleName,
                                    onChanged: (p) {
                                      controller.onChangeMiddleName(p);
                                    }),
                              ),
                            ],
                          ),
                          CustomTextField(
                              initialValue:
                                  controller.customerRx?.value?.lastName,
                              labelText: 'Last Name',
                              onChanged: controller.onChangeLastName),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gender',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: CustomTheme.primaryLightColor),
                              ),
                              Obx(() => Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'Male',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          value: 'M',
                                          groupValue:controller
                                              .customerRx?.value?.gender,
                                          onChanged: (value) {
                                            controller.onChangeGender(value!);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'Female',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          value: 'F',
                                          groupValue:controller
                                              .customerRx?.value?.gender,
                                          onChanged: (value) {
                                            controller.onChangeGender(value!);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: RadioListTile<String>(
                                          title: Text(
                                            'Other',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          value: 'O',
                                          groupValue: controller
                                              .customerRx?.value?.gender,
                                          onChanged: (value) {
                                            controller.onChangeGender(value!);
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          Obx(() => CustomDatePicker(
                              labelText: 'Date of Birth',
                              finalDefaultValue:
                                  controller.customerRx?.value?.birthday,
                              onChanged: controller.onChangeDateOfBirth)),
                          CustomTextField(
                              initialValue:
                                  controller.customerRx?.value?.phoneNumber,
                              labelText: 'Phone',
                              onChanged: controller.onChangePhone),
                          FutureBuilder(
                              future: controller.apiService.getStates(),
                              builder: (context, data) {
                                return CustomDropdown<StateModel, String>(
                                  items: data.data?.toList() ?? [],
                                  onChanged: controller.onChangeState,
                                  labelText: 'State',
                                  selectedItem: data.data
                                      ?.where((x) =>
                                          x.idState ==
                                          controller.customerRx?.value?.state)
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
                                );
                              }),
                          FutureBuilder(
                              future: controller
                                          .customerRx?.value?.state?.isEmpty ??
                                      false
                                  ? Future.value(List<City>.empty())
                                  : controller.apiService.getCity(
                                      controller.customerRx?.value?.state ??
                                          ''),
                              builder: (context, data) {
                                return CustomDropdown<City, int>(
                                  items: data.data?.toList() ?? [],
                                  onChanged: controller.onChangeCity,
                                  selectedItem: data.data
                                      ?.where((x) =>
                                          x.idCity ==
                                          controller.customerRx?.value?.city)
                                      .firstOrNull
                                      ?.idCity,
                                  labelText: 'County (City)',
                                  showSearchBox: true,
                                  textEditingController:
                                      TextEditingController(),
                                  valueProperty: "Id_City",
                                  labelProperty: "Name",
                                  labelBuilder: (item) {
                                    return '${item!["Name"]}';
                                  },
                                );
                              }),
                          FutureBuilder(
                              future: (controller.customerRx?.value?.city ??
                                          0) >
                                      0
                                  ? controller.apiService.getTown(
                                      controller.customerRx?.value?.city ?? 0)
                                  : Future.value(List<Town>.empty()),
                              builder: (context, data) {
                                return CustomDropdown<Town, int>(
                                  items: data.data?.toList() ?? [],
                                  onChanged: controller.onChangeTown,
                                  selectedItem: data.data
                                      ?.where((x) =>
                                          x.idTown ==
                                          controller.customerRx?.value?.town)
                                      .firstOrNull
                                      ?.idTown,
                                  labelText: 'Town (Neighborhood)',
                                  showSearchBox: true,
                                  textEditingController:
                                      TextEditingController(),
                                  valueProperty: "Id_Town",
                                  labelProperty: "Name",
                                  labelBuilder: (item) {
                                    return '${item!["Name"]}';
                                  },
                                );
                              }),
                          CustomTextField(
                              initialValue:
                                  controller.customerRx?.value?.addressLine1,
                              labelText: 'Address Line 1',
                              onChanged: controller.onChangeAddressLine1),
                          CustomTextField(
                              initialValue:
                                  controller.customerRx?.value?.addressLine2,
                              labelText: 'Address Line 2',
                              onChanged: controller.onChangeAddressLine2),
                          CustomTextField(
                            labelText: 'Zip Code',
                            onChanged: controller.onChangeZipCode,
                            maxLength: 5,
                            initialValue: controller.customerRx?.value?.zipCode,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  type: NotificationType.success,
                                  label: 'Save',
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await controller.save();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  type: NotificationType.error,
                                  label: 'Delete Account',
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await controller.deleteAccount();
                                  },
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                  onLoading: const Center(
                    child: CircularProgressIndicator(),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
