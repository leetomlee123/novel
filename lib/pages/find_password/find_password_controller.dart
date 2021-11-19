import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novel/pages/find_password/find_password_model.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/services/services.dart';

class FindPasswordController extends GetxController {
  final findPass = FindPasswordModel();

  var key = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  resetPass() async {
    Get.focusScope!.requestFocus(FocusNode());

    if (key.currentState!.validate()) {
      dynamic res = await UserAPI().modifyPassword(findPass);
      if (res['code'] != 200) {
        Get.snackbar("消息", res['msg'], snackPosition: SnackPosition.BOTTOM);
      } else {
        await Future.delayed(Duration(seconds: 1));
        Get.back();
      }
    }
  }
}
