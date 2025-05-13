import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/travel.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/routes/app_pages.dart';

class TravelsController extends GetxController with StateMixin {
  final ApiService apiService = Get.find<ApiService>();
  var states = <StateModel>[].obs;
  Rx<StateModel?>? to;
  Rx<StateModel?>? from;
  Rx<DateTime?>? selectedDate;
  var serviceType = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    onSearch();
    //fetch();
  }

  Future<void> getStates() async {
    var states = await apiService.getStates();
    this.states.value = states;
  }

  onChangedFromState(String? idstate) {
    from = states.firstWhere((element) => element.idState == idstate).obs;
  }

  onChangedToState(String? idstate) {
    to = states.firstWhere((element) => element.idState == idstate).obs;
  }

  void onChangedDate(DateTime? date) {
    selectedDate = date!.obs;
    update();
  }

  clear() async {
    from = null.obs;
    to = null.obs;
    selectedDate = null.obs;
    change(List<Travel>.empty, status: RxStatus.success());
  }

  onSearch() async {
    try {
      if (from == null || to == null || selectedDate == null) {
        await getStates();
        change(List<Travel>.empty, status: RxStatus.success());

        return;
      }
      change(null, status: RxStatus.loading());
      var travels = await apiService.getFilteredTravel(
        from!.value!.idState,
        to!.value!.idState,
        selectedDate!.value!,
      );
      if (travels.isEmpty) {
        change(null, status: RxStatus.empty());
        return;
      }
      await getStates();
      change(travels, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  tapTravel(Travel travel) async {
    EasyLoading.show(status: 'Loading...');
    var id = Get.find<SessionService>().getSession()?.customerId;
    var message = await apiService.validReservation(travel.travelNumber, id!);
    if (message != null && message.isNotEmpty) {
      EasyLoading.dismiss();
      await Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ));

      return;
    }
    final configurations = await apiService.configurations(['HoraLimiteViaje']);
    final horaLimiteConfig = configurations
        .where((config) => config.idConfiguracion == 'HoraLimiteViaje')
        .firstOrNull;

    var available = apiService.isTravelAvailable(travel, horaLimiteConfig);
    if (!available) {
      await Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: const Text('The trip is not available for booking.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ));
      EasyLoading.dismiss();

      return;
    }
    EasyLoading.dismiss();

    var create = CreateReservation(
        serviceType: serviceType.value,
        fromSate: travel.stateFrom,
        toState: travel.stateTo,
        fromCity: travel.cityFrom,
        toCity: travel.cityTo,
        fromTown: travel.townFrom,
        toTown: travel.townTo,
        date: travel.departureDate,
        travel: travel,
        customerId: id);
    Get.toNamed(Routes.CREATE_BOOKING, arguments: create);
  }

  onChangeType(int? x) {
    serviceType.value = x!;
  }
}
