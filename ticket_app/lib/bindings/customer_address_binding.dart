import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:ticket_app/controller/create_customer_address_controller.dart';
import 'package:ticket_app/controller/customer_address_controller.dart';
import 'package:ticket_app/controller/edit_profile_controller.dart';

class CustomerAddressBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CustomerAddressController>(CustomerAddressController());
    Get.put<CreateCustomerAddressController>( CreateCustomerAddressController());
  }
}
class EditProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<EditProfileController>(EditProfileController());
  }
}
