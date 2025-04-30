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
          GestureDetector(
            onTap: controller.getPhoto,
            child: controller.userRegister.value.photo != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        FileImage(File(controller.userRegister.value.photo!)),
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
          ),
          gapH12,
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                    labelText: 'First Name',
                    initialValue: controller.userRegister.value.firsName,
                    onChanged: (p) {
                      controller.onChangeFirstName(p);
                    }),
              ),
              gapW16,
              Expanded(
                child: CustomTextField(
                    labelText: 'Middle Name',
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
              onChanged: controller.onChangeLastName),
          CustomDatePicker(
              labelText: 'Date of Birth',
              finalDefaultValue: controller.userRegister.value.birthday,
              onChanged: controller.onChangeDateOfBirth),
          CustomTextField(
              initialValue: controller.userRegister.value.email,
              keyboard: TextInputType.emailAddress,
              labelText: 'Email',
              onChanged: controller.onChangeEmail),
          CustomTextField(
              initialValue: controller.userRegister.value.phoneNumber,
              keyboard: TextInputType.phone,
              labelText: 'Phone Number',
              onChanged: controller.onChangePhoneNumber),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  initialValue: controller.userRegister.value.password,
                  labelText: 'Password',
                  obscureText: true,
                  onChanged: controller.onChangePassword,
                ),
              ),
              gapW16,
              Expanded(
                child: CustomTextField(
                  initialValue: controller.userRegister.value.confirmPassword,
                  labelText: 'Confirm Password',
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
                if (data.data == null) {
                  return Container();
                }
                return CustomDropdown<City, int>(
                  items: data.data?.toList() ?? [],
                  onChanged: onChangedCity,
                  selectedItem: data.data
                      ?.where((x) => x.idCity == city)
                      .firstOrNull
                      ?.idCity,
                  labelText: 'City',
                  showSearchBox: true,
                  textEditingController: TextEditingController(),
                  valueProperty: "idCity",
                  labelProperty: "Name",
                  labelBuilder: (item) {
                    return '${item!["Name"]}';
                  },
                );
              }),
          FutureBuilder(
              future: city > 0
                  ? Future.value(List<Town>.empty())
                  : apiService.getTowns(),
              builder: (context, data) {
                if (data.data == null) {
                  return Container();
                }
                return CustomDropdown<Town, int>(
                  items: data.data?.toList() ?? [],
                  onChanged: onChangedTown,
                  selectedItem: data.data
                      ?.where((x) => x.idTown == town)
                      .firstOrNull
                      ?.idTown,
                  labelText: 'Town',
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
            labelText: 'Zip Code',
            onChanged: onChangedZipCode,
            initialValue: zipCode,
          ),
        ],
      ),
    );
  }
}
