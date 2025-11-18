import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/data/service/payment_service.dart';
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/utils/constants.dart';

void main() async {
  await initServices();
  runApp(Sizer(builder: (p0, p1, p2) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el label de debug

      getPages: AppPages.pages,
      theme: CustomTheme.lightTheme,
      builder: EasyLoading.init(), // Inicializa EasyLoading aquí
    );
  }));
}

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  var sharedPreferences = await SharedPreferences.getInstance();
  Stripe.merchantIdentifier = 'merchant.flutter.DoorToDoor';
  Get.put<Stripe>(Stripe.instance, permanent: true);
  Get.put<SharedPreferences>(sharedPreferences, permanent: true);
  Get.lazyPut<SessionService>(() => SessionService());
  Get.put<AuthService>(AuthService(urlApi),permanent: true);
  Get.put<ApiService>( ApiService(urlApi),permanent: true);
     Get.put<PaymentService>( PaymentService(),permanent: true);
}
