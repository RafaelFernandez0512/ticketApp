import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ticket_app/bindings/create_booking_binding.dart';
import 'package:ticket_app/bindings/forgot_password_binding.dart';
import 'package:ticket_app/bindings/home_binding.dart';
import 'package:ticket_app/bindings/login_binding.dart';
import 'package:ticket_app/bindings/sign_up_binding.dart';
import 'package:ticket_app/bindings/splash_binding.dart';
import 'package:ticket_app/controller/home_controller.dart';
import 'package:ticket_app/controller/splash_controller.dart';
import 'package:ticket_app/ui/Authentication/forgot_password.dart';
import 'package:ticket_app/ui/Authentication/sign_up_page.dart';
import 'package:ticket_app/ui/Authentication/login_page.dart';
import 'package:ticket_app/ui/home_page.dart';
import 'package:ticket_app/ui/reservations/create_booking_page.dart';
import 'package:ticket_app/ui/splash_page.dart';

part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
        name: Routes.LOGIN,
        page: () => const LoginPage(),
        binding: LoginBinding()),
    GetPage(
        name: Routes.HOME,
        page: () => const HomePage(),
        binding: HomeBinding()),
    GetPage(
        name: Routes.SIGNUP,
        page: () => const SignUpPage(),
        binding: SignUpBinding()),
    GetPage(
        name: Routes.CREATE_BOOKING,
        page: () => const CreateBookingPage(),
        binding: CreateBookingBinding()),
    GetPage(
        name: Routes.FORGOT_PASSWORD,
        page: () => const ForgotPasswordPage(),
        binding: ForgotPasswordBinding()),
    GetPage(
        name: Routes.SPLASH,
        page: () => const SplashPage(),
        binding: SplashBinding()),
  ];
}
