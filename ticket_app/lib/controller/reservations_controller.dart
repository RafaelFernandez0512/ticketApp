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
  void onInit() {
    super.onInit();
    fetch();
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
    await fetch();
  }

  onSearch() async {
    try {
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

  tapTravel(Travel travel) {
    var id = Get.find<SessionService>().getSession()?.customerId;
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
        customerId: id!);
    Get.toNamed(Routes.CREATE_BOOKING, arguments: create);
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());
      var travels = await apiService.getTravel();
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

  onChangeType(int? x) {
    serviceType.value = x!;
  }
}
