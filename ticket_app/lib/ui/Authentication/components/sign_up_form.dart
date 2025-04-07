import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/sign_up_controller.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/ui/widgets/custom_dropdown.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';

class RegisterClientForm extends StatelessWidget {
  SignUpController controller;
  RegisterClientForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        spacing: 20,
        children: [
          CustomTextField(
              labelText: 'First Name',
              initialValue: controller.userRegister.value.firsName,
              onChanged: (p) {
                controller.onChangeFirstName(p);
              }),
          CustomTextField(
              initialValue: controller.userRegister.value.lastName,
              labelText: 'Last Name',
              onChanged: controller.onChangeLastName),
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
          CustomTextField(
            initialValue: controller.userRegister.value.password,
            labelText: 'Password',
            obscureText: true,
            onChanged: controller.onChangePassword,
          ),
          CustomTextField(
            initialValue: controller.userRegister.value.confirmPassword,
            labelText: 'Confirm Password',
            onChanged: controller.onChangeConfirmPassword,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}

class RegisterAddressForm extends StatelessWidget {
  Function(String)? onChangedAddressLine1;
  Function(String)? onChangedAddressLine2;
  ValueChanged<String?>? onChangedState;
  ValueChanged<String?>? onChangedTown;
  ValueChanged<String?>? onChangedCity;
  Function(String)? onChangedZipCode;
  String addressLine1 = '';
  String addressLine2 = '';
  String state = '';
  String town = '';
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
      this.town = ''});
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
                      ?.where((x) => x.name == state)
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
              future: apiService.getTown(),
              builder: (context, data) {
                if (data.data == null) {
                  return Container();
                }
                return CustomDropdown<Town, String>(
                  items: data.data?.toList() ?? [],
                  onChanged: onChangedTown,
                  selectedItem: data.data
                      ?.where((x) => x.name == town)
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
