import 'package:get/get.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/home_viewmodel.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/routes/app_pages.dart';

class CustomerAddressController extends GetxController
    with StateMixin<List<CustomerAddress>> {
  final ApiService apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    change(null, status: RxStatus.loading());
    //var customerAddressList = await apiService.getCustomerAddress();
    //change(customerAddressList, status: RxStatus.success());
  }


  addOrUpdate(CustomerAddress? customerAddress) {
    //navigate
    Get.toNamed(Routes.CREATE_ADDRESS, arguments: customerAddress);
  }

  Future<void> delete(CustomerAddress state) async {
       await apiService.removeAddress(state.idCustomerAddress!);
     await  fetch();
  }
}
