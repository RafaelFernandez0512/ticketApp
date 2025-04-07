import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/utils/constants.dart';

void main() async {
  await initServices();
  runApp(Sizer(
    builder: (p0, p1, p2) => GetMaterialApp(
      getPages: AppPages.pages,
      theme: CustomTheme.lightTheme,
    ),
  ));
}

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  var sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut<SharedPreferences>(() => sharedPreferences);
  Get.lazyPut<SessionService>(() => SessionService());
  Get.lazyPut<AuthService>(() => AuthService(urlApi));
  Get.lazyPut<ApiService>(() => ApiService(urlApi));
}
