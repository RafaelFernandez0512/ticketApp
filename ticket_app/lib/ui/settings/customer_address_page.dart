import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/controller/customer_address_controller.dart';
import 'package:ticket_app/ui/settings/create_customer_address_modal_sheet.dart';
import 'package:ticket_app/utils/gaps.dart';

class CustomerAddressPage extends GetView<CustomerAddressController> {
  const CustomerAddressPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Customer Address',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              await CreateCustomerModalSheet.showModal(context, null);
            },
          ),
        ],
      ),
      body: GetBuilder<CustomerAddressController>(
        builder: (_) {
          return SafeArea(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: controller.obx(
                    (state) => Expanded(
                      child: ListView.builder(
                        itemCount: state!.length,
                        itemBuilder: (context, index) {
                          var customerAddress = state[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          customerAddress.fullAddress ?? '')),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          var value =
                                              await CreateCustomerModalSheet
                                                  .showModal(
                                                      context, customerAddress);
                                          if (value ?? false) {
                                            await controller.fetch();
                                          }
                                        },
                                      ),
                                      gapW16,
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          controller.delete(state[index]);
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                    onLoading: const Center(child: CircularProgressIndicator()),
                  )));
        },
      ),
    );
  }
}
