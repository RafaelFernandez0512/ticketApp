import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:ticket_app/data/model/customer.dart';
import 'package:ticket_app/data/model/home_viewmodel.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/session_service.dart';

class SettingsController extends GetxController with StateMixin {
  final ApiService apiService = Get.find<ApiService>();
  var name = ''.obs;
  var email = ''.obs;
  Rx<Uint8List>? photo;
  loadData() async {
    await fetch();
  }

  Future<void> fetch() async {
    var username = Get.find<SessionService>().getSession()?.username;
    var customer = await apiService.getCustomer(username ?? '');
    name = (customer?.fullName ?? '').obs;
    email = (customer?.email ?? '').obs;
    try {
      if (customer?.photo != null) {
        photo = base64Decode(customer!.photo!).obs;
      }
    } catch (e) {
      photo = null;
    }
    if (customer != null) {
      change(customer, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.error('Error loading data'));
    }
  }
}
