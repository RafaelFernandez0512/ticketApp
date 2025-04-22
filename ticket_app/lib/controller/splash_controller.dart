import 'package:get/get.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/data/service/session_service.dart';

import '../routes/app_pages.dart';

class SplashController extends GetxController with StateMixin {
  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () async {
      var user = Get.find<SessionService>().getSession();
      var isLogged = Get.find<SessionService>().isLoggedIn();
      if (isLogged && user != null) {
        var auth = await Get.find<AuthService>()
            .authenticate(user.username ?? "", user.password ?? "");
        if (auth.isNotEmpty) {
          Get.offAllNamed(Routes.HOME);
          return;
        }
      }
      Get.offAllNamed(Routes.LOGIN);
    });
  }
}
