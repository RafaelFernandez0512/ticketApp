import 'package:get/get.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/home_viewmodel.dart';
import 'package:ticket_app/data/service/api_service.dart';

class CreateCustomerAddressController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  var customerAddressModel = CustomerAddress().obs;

  Future<void> removeAddress(int id) async {
    await apiService.removeAddress(id);
  }

  Future<void> addOrUpdate() async {
    if (customerAddressModel.value.idCustomerAddress == 0) {
      await apiService.createCustomerAddress(customerAddressModel.value);
    } else {
      await apiService.updateCustomerAddress(customerAddressModel.value);
    }
  }

  onChangeAddressLine1(String p1) {
    customerAddressModel.update((val) {
      val!.addressLine1 = p1;
    });
  }

  onChangeAddressLine2(String p1) {
    customerAddressModel.update((val) {
      val!.addressLine2 = p1;
    });
  }

  void onChangeState(String? p1) {}

  void onChangeTown(int? p1) {}

  onChangeZipCode(String p1) {
    customerAddressModel.update((val) {
      val!.zipCode = p1;
    });
  }
}
