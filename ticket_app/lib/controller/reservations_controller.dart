import 'package:get/get.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/routes/app_pages.dart';

class TravelsController extends GetxController with StateMixin {
  final ApiService apiService = Get.find<ApiService>();
  var states = <StateModel>[].obs;
  StateModel? to;
  StateModel? from;
  Rx<DateTime>? selectedDate;
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
    from = states.firstWhere((element) => element.idState == idstate);
  }

  onChangedToState(String? idstate) {
    to = states.firstWhere((element) => element.idState == idstate);
  }

  onChangedDate(DateTime? date) {
    selectedDate = date!.obs;
  }

  onSearch() {
    Get.toNamed(Routes.CREATE_BOOKING, arguments:CreateReservation(
      idFromSate: from?.idState,
      idToSate: to?.idState,
      date: selectedDate?.value,
      serviceType: serviceType.value,
    ));
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
