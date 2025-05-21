import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/controller/login_controller.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/ui/Authentication/login_mobile.dart';
import 'package:ticket_app/ui/Authentication/login_web.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/ui/Authentication/components/login_form.dart';
import 'package:ticket_app/ui/widgets/background.dart';
import 'package:ticket_app/ui/widgets/response.dart';
import 'package:ticket_app/ui/widgets/responsive_widget.dart';
import 'package:ticket_app/utils/constants.dart';
import 'package:ticket_app/utils/gaps.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var web = kIsWeb;
    if(kIsWeb){
return  LoginWeb();
    }

          return  LoginMobile();

  }
}
