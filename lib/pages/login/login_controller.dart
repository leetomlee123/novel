import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/login/login_model.dart';
import 'package:novel/services/services.dart';

class LoginController extends GetxController {
  UserProfileModel? userProfileModel = UserProfileModel();
  var key = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  login() async {
    Get.focusScope!.requestFocus(FocusNode());

    if (key.currentState!.validate()) {
      UserProfileModel _userProfileModel =
          await UserAPI().login(userProfileModel);
      _userProfileModel.username = userProfileModel!.username;
      userProfileModel = _userProfileModel;
      Global.saveProfile(userProfileModel!);
      Get.find<IndexController>().userProfileModel.value = userProfileModel;
      var data = await BookApi().shelf();
      Get.find<HomeController>().shelf.value = data;
      Get.back();
      Get.back();
    }
  }

  googleLogin() {
    Get.snackbar("消息", "not support yet", snackPosition: SnackPosition.BOTTOM);
  }

  githubLogin() {
    Get.snackbar("消息", "not support yet", snackPosition: SnackPosition.BOTTOM);
  }
}
