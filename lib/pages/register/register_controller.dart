import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/register/register_model.dart';
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
    Get.focusScope!.requestFocus(FocusNode());

    if (key.currentState!.validate()) {
      dynamic res = await UserAPI().register(registerModel);
      if (res['code'] != 200) {
        Get.snackbar("消息", res['msg'], snackPosition: SnackPosition.BOTTOM);
      } else {
        await Future.delayed(Duration(seconds: 1));
        Get.back();
      }
    }
  }
}
