import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/edit_profile_controller.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
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
                          CustomTextField(
                              initialValue:
                                  controller.customerRx?.value?.phoneNumber,
                              labelText: 'Phone',
                              onChanged: controller.onChangePhone),
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
