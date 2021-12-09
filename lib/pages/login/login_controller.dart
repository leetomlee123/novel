import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/login/login_model.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/services/services.dart';
import 'package:novel/utils/database_provider.dart';

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
    Get.focusScope!.unfocus();

    if (key.currentState!.validate()) {
      UserProfileModel _userProfileModel =
          await UserAPI().login(userProfileModel);
      _userProfileModel.username = userProfileModel!.username;
      userProfileModel = _userProfileModel;
      Global.saveProfile(userProfileModel!);
      Get.find<IndexController>().userProfileModel.value = userProfileModel;
      var data = await BookApi().shelf();
      DataBaseProvider.dbProvider.addBooks(data);
      Get.find<HomeController>().shelf.value = data;
      Get.offNamed(AppRoutes.Index);
    }
  }

  googleLogin() {
    BotToast.showText(
      text: "not support yet",
    );
  }

  githubLogin() {
    BotToast.showText(
      text: "not support yet",
    );
  }
}
