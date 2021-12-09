import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novel/pages/find_password/find_password_model.dart';
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
    Get.focusScope!.unfocus();

    if (key.currentState!.validate()) {
      dynamic res = await UserAPI().modifyPassword(findPass);
      if (res['code'] != 200) {
        BotToast.showText(text:res['msg']);
      } else {
        await Future.delayed(Duration(seconds: 1));
        Get.back();
      }
    }
  }
}
