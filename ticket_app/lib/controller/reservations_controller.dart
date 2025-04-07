import 'package:get/get.dart';
import 'package:ticket_app/data/service/api_service.dart';

class TravelsController extends GetxController with StateMixin {
  final ApiService apiService = Get.find<ApiService>();
  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      change(null, status: RxStatus.loading());
      var travels = await apiService.getTravel();
      if (travels.isEmpty) {
        change(null, status: RxStatus.empty());
        return;
      }
      change(travels, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }
}
