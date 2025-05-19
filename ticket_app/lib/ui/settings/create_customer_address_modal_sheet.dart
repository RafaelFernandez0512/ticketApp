import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/create_customer_address_controller.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/ui/Authentication/components/sign_up_form.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/notification_type.dart';

class CreateCustomerModalSheet {
  static Future<bool?> showModal(
      BuildContext context, CustomerAddress? customerAddress,
      {bool payLater = false}) {
    var controller = Get.find<CreateCustomerAddressController>();
    controller.customerAddressModel.value =
        customerAddress ?? CustomerAddress();
    return showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                gapW20,
                Expanded(
                  child: Text(
                      customerAddress != null
                          ? "Edit Address"
                          : "Create Address",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700, fontSize: 22)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                )
              ],
            ),
            const Divider(),
            RegisterAddressForm(),
            gapH20,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    type: NotificationType.success,
                   
                    label: "Save",
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
