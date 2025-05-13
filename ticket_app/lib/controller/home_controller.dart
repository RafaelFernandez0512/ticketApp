import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ticket_app/data/model/filter_data.dart';
import 'package:ticket_app/data/model/home_viewmodel.dart';
import 'package:ticket_app/data/service/api_service.dart';

class HomeController extends GetxController with StateMixin<HomeViewModel> {
  final ApiService apiService = Get.find<ApiService>();

  final filterData = Rx<FilterData>(FilterData(date: DateTime.now()));
  @override
  void onInit() {
    super.onInit();
  }


}
