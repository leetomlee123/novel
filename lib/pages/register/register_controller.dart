import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/register/register_model.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/services/user.dart';

class RegisterController extends GetxController {
  final registerModel = RegisterModel();

  var key = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  register() async {
   Get.focusScope!.unfocus();

    if (key.currentState!.validate()) {
      dynamic res = await UserAPI().register(registerModel);
      if (res['code'] != 200) {
      BotToast.showText(text:res['msg']);
      } else {
        await Future.delayed(Duration(seconds: 1));
        Get.offNamed(AppRoutes.Login);
      }
    }
  }
}
