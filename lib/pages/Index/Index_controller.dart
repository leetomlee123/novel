import 'package:get/get.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/login/login_model.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/utils/database_provider.dart';

class IndexController extends GetxController {
  // 是否展示欢迎页
  var isloadWelcomePage = true.obs;

  final userProfileModel = Global.profile.obs;

  toLogin() {
    if (userProfileModel.value!.token!.isEmpty) {
      Get.toNamed(AppRoutes.Login);
    }
  }

//退出登录
  dropAccountOut() {
    Global.profile = UserProfileModel(token: "");
    userProfileModel.value = Global.profile;
    DataBaseProvider.dbProvider.clearBooks();
    Get.find<HomeController>().shelf.clear();
    Global.saveProfile(Global.profile!);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    startCountdownTimer();
  }

  @override
  void onClose() {}

  // 展示欢迎页，倒计时1.5秒之后进入应用
  Future startCountdownTimer() async {
    await Future.delayed(Duration(milliseconds: 1), () {
      isloadWelcomePage.value = false;
    });
  }
}
