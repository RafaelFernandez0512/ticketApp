import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/home_viewmodel.dart';
import 'package:ticket_app/data/service/api_service.dart';

class CreateCustomerAddressController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  var customerAddressModel = CustomerAddress().obs;
  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {}
  Future<void> removeAddress(String id) async {
    await apiService.removeAddress(id);
  }

 Future<void> addOrUpdate() async{

  
  }
}
