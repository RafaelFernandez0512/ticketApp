import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/sign_up_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/ui/widgets/custom_datepicker.dart';
import 'package:ticket_app/ui/widgets/custom_dropdown.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';
import 'package:ticket_app/utils/gaps.dart';

class RegisterClientForm extends StatelessWidget {
  SignUpController controller;
  RegisterClientForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: 20,
        children: [
          Obx(() => GestureDetector(
                onTap: controller.getPhoto,
                child: controller.userRegister.value.photo != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(
                            base64Decode(controller.userRegister.value.photo!)),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: CustomTheme.primaryLightColor,
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                          color: CustomTheme.white,
                        ),
                      ),
              )),
          gapH12,
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                    labelText: 'First Name',
                    maxLength: 150,
                    initialValue: controller.userRegister.value.firsName,
                    onChanged: (p) {
                      controller.onChangeFirstName(p);
                    }),
              ),
              gapW16,
              Expanded(
                child: CustomTextField(
                    labelText: 'Middle Name',
                    maxLength: 150,
                    initialValue: controller.userRegister.value.middleName,
                    onChanged: (p) {
                      controller.onChangeMiddleName(p);
                    }),
              ),
            ],
          ),
          CustomTextField(
              initialValue: controller.userRegister.value.lastName,
              labelText: 'Last Name',
              maxLength: 150,
              onChanged: controller.onChangeLastName),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gender',
                style: TextStyle(
                    fontSize: 16, color: CustomTheme.primaryLightColor),
              ),
              Obx(() => Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: RadioListTile<String>(
                          title: Text(
                            'Male',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: 'M',
                          groupValue: controller.userRegister.value.gender,
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
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: 'F',
                          groupValue: controller.userRegister.value.gender,
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
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: 'O',
                          groupValue: controller.userRegister.value.gender,
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
              finalDefaultValue: controller.userRegister.value.birthday,
              onChanged: controller.onChangeDateOfBirth)),
          CustomTextField(
              initialValue: controller.userRegister.value.phoneNumber,
              keyboard: TextInputType.phone,
              labelText: 'Phone Number',
              maxLength: 12,
              onChanged: controller.onChangePhoneNumber),
          CustomTextField(
              initialValue: controller.userRegister.value.email,
              keyboard: TextInputType.emailAddress,
              labelText: 'Email (Username)',
              maxLength: 100,
              onChanged: controller.onChangeEmail),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  initialValue: controller.userRegister.value.password,
                  labelText: 'Password',
                  maxLength: 100,
                  obscureText: true,
                  onChanged: controller.onChangePassword,
                ),
              ),
              gapW16,
              Expanded(
                child: CustomTextField(
                  initialValue: controller.userRegister.value.confirmPassword,
                  labelText: 'Confirm Password',
                  maxLength: 100,
                  onChanged: controller.onChangeConfirmPassword,
                  obscureText: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class RegisterAddressForm extends StatelessWidget {
  Function(String)? onChangedAddressLine1;
  Function(String)? onChangedAddressLine2;
  ValueChanged<String?>? onChangedState;
  ValueChanged<int?>? onChangedTown;
  ValueChanged<int?>? onChangedCity;
  Function(String)? onChangedZipCode;
  String addressLine1 = '';
  String addressLine2 = '';
  String state = '';
  int city;
  int town;
  String zipCode = '';

  RegisterAddressForm(
      {super.key,
      this.onChangedAddressLine1,
      this.onChangedAddressLine2,
      this.onChangedState,
      this.onChangedCity,
      this.onChangedTown,
      this.onChangedZipCode,
      this.addressLine1 = '',
      this.addressLine2 = '',
      this.state = '',
      this.city = 0,
      this.town = 0});
  var apiService = Get.find<ApiService>();
  @override
  Widget build(
    BuildContext context,
  ) {
    return Form(
      child: Column(
        spacing: 20,
        children: [
          FutureBuilder(
              future: apiService.getStates(),
              builder: (context, data) {
                return CustomDropdown<StateModel, String>(
                  items: data.data?.toList() ?? [],
                  onChanged: onChangedState,
                  labelText: 'State',
                  selectedItem: data.data
                      ?.where((x) => x.idState == state)
                      .firstOrNull
                      ?.idState,
                  showSearchBox: true,
                  textEditingController: TextEditingController(),
                  valueProperty: "Id_State",
                  labelProperty: "Name",
                  labelBuilder: (item) {
                    return '${item!["Name"]}';
                  },
                );
              }),
          FutureBuilder(
              future: state.isEmpty
                  ? Future.value(List<City>.empty())
                  : apiService.getCity(state),
              builder: (context, data) {
                return CustomDropdown<City, int>(
                  items: data.data?.toList() ?? [],
                  onChanged: onChangedCity,
                  selectedItem: data.data
                      ?.where((x) => x.idCity == city)
                      .firstOrNull
                      ?.idCity,
                  labelText: 'County (City)',
                  showSearchBox: true,
                  textEditingController: TextEditingController(),
                  valueProperty: "Id_City",
                  labelProperty: "Name",
                  labelBuilder: (item) {
                    return '${item!["Name"]}';
                  },
                );
              }),
          FutureBuilder(
              future: city > 0
                  ? apiService.getTown(city)
                  : Future.value(List<Town>.empty()),
              builder: (context, data) {
                return CustomDropdown<Town, int>(
                  items: data.data?.toList() ?? [],
                  onChanged: onChangedTown,
                  selectedItem: data.data
                      ?.where((x) => x.idTown == town)
                      .firstOrNull
                      ?.idTown,
                  labelText: 'Town (Neighborhood)',
                  showSearchBox: true,
                  textEditingController: TextEditingController(),
                  valueProperty: "Id_Town",
                  labelProperty: "Name",
                  labelBuilder: (item) {
                    return '${item!["Name"]}';
                  },
                );
              }),
          CustomTextField(
              initialValue: addressLine1,
              keyboard: TextInputType.streetAddress,
              labelText: 'Address Line 1',
              maxLength: 250,
              onChanged: onChangedAddressLine1),
          CustomTextField(
              initialValue: addressLine2,
              keyboard: TextInputType.streetAddress,
              labelText: 'Address Line 2',
              maxLength: 250,
              onChanged: onChangedAddressLine2),
          CustomTextField(
            labelText: 'Zip Code',
            onChanged: onChangedZipCode,
            maxLength: 5,
            initialValue: zipCode,
          ),
        ],
      ),
    );
  }
}
