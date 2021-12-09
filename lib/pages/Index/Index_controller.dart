import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/Index/NavigationIconView.dart';
import 'package:novel/pages/app_menu/app_menu_view.dart';
import 'package:novel/pages/book_city/book_city_view.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_view.dart';
import 'package:novel/pages/login/login_model.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/utils/database_provider.dart';

class IndexController extends GetxController with SingleGetTickerProviderMixin {
  // 是否展示欢迎页
  var isloadWelcomePage = false.obs;
  RxInt index = 0.obs;
  RxBool darkModel = Get.isDarkMode.obs;
  RxBool showBottom = true.obs;
  List<NavigationIconView>? navigationViews;
  final userProfileModel = Global.profile.obs;
  List<Widget>? pageList;
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
    navigationViews = <NavigationIconView>[
      NavigationIconView(iconData: Icons.book_sharp, title: "书架", vsync: this),
      NavigationIconView(
          iconData: Icons.all_inclusive, title: "书城", vsync: this),
      NavigationIconView(iconData: Icons.person, title: "个人中心", vsync: this),
    ];

    pageList = [HomePage(), BookCityPage(), AppMenuPage()];
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
