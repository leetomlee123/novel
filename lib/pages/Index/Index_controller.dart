import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/Index/NavigationIconView.dart';
import 'package:novel/pages/app_menu/app_menu_view.dart';
import 'package:novel/pages/book_chapters/chapter.pbserver.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/pages/home/home_view.dart';
import 'package:novel/pages/listen/listen_view.dart';
import 'package:novel/pages/login/login_model.dart';
import 'package:novel/pages/read_book/read_book_controller.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/utils/chapter_parse.dart';
import 'package:novel/utils/database_provider.dart';
import 'package:sp_util/sp_util.dart';

class IndexController extends GetxController
    with GetTickerProviderStateMixin {
  // 是否展示欢迎页
  var isloadWelcomePage = false.obs;
  RxInt index = 0.obs;
  RxBool darkModel = Get.isDarkMode.obs;
  RxBool showBottom = true.obs;
  Set<String> cacheKey = Set();
  List<NavigationIconView>? navigationViews;
  final userProfileModel = Global.profile.obs;
  int i = 0;
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
    DataBaseProvider.dbProvider.clearChapters();
    Get.find<HomeController>().shelf.clear();
    SpUtil.getKeys()!.forEach((element) {
      if (element.startsWith("pages")) {
        SpUtil.remove(element);
      }
    });
    Global.saveProfile(Global.profile!);
  }

  @override
  void onInit() {
    navigationViews = <NavigationIconView>[
      NavigationIconView(iconData: Icons.book_sharp, title: "书架", vsync: this),
      NavigationIconView(
          iconData: Icons.graphic_eq_outlined, title: "聚听", vsync: this),
      NavigationIconView(iconData: Icons.person, title: "我", vsync: this),
    ];

    pageList = [HomePage(), ListenPage(), AppMenuPage()];
    super.onInit();
  }

  @override
  void onReady() {
    startCountdownTimer();
  }

  toggleModel() {
    darkModel.value = !darkModel.value;
    Get.changeTheme(!darkModel.value ? ThemeData.light() : ThemeData.dark());
    Get.forceAppUpdate();
    Global.setting!.isDark = darkModel.value;
    Global.setting!.persistence();
    Get.find<HomeController>().widgets.clear();
    SystemChrome.setSystemUIOverlayStyle(
        darkModel.value ? ReadSetting.light : ReadSetting.dark);
  }

  @override
  void onClose() {}

  // 展示欢迎页，倒计时1.5秒之后进入应用
  Future startCountdownTimer() async {
    await Future.delayed(Duration(milliseconds: 1), () {
      isloadWelcomePage.value = false;
    });
  }

  //chapters cache
  cacheChapters(Book book, List<ChapterProto> chapters, int idx) async {
    if (cacheKey.contains(book.id)) {
      Get.log('already down ${book.id}');
      return;
    }
    cacheKey.add(book.id ?? "");
    book.cacheChapterContent = "1";
    DataBaseProvider.dbProvider.updBook(book);

    // List<DownChapter> cps = List.empty(growable: true);
    for (var i = idx; i < chapters.length; i++) {
      var cp = chapters[i];
      if (cp.hasContent != "2") {
        // cps.add(DownChapter(
        //   idx: i,
        //   chapterId: chapters[i].chapterId,
        // ));
        // if (cps.length % downCommitLen == 0) {
        //   cps = await compute(downChapter, cps);
        //   cps.forEach((element) {
        //     chapters[element.idx ?? 0].hasContent = "2";
        //   });
        //   DataBaseProvider.dbProvider.downContent(cps);
        //   cps.clear();
        // }
        try {
          final content =
              await ChapterParseUtil().getChapterCotent(cp.chapterId);
          await DataBaseProvider.dbProvider
              .updateContent(cp.chapterId, content);

          Get.log('cache ${book.name} $i');
          Get.log(Get.currentRoute);
          if (Get.currentRoute == AppRoutes.ReadBook)
            Get.find<ReadBookController>().chapters[i].hasContent = '2';
        } catch (e) {
          Get.log(e.toString());
        }
      }
    }
    BotToast.showText(text: '${book.name}下载成功...');
  }
}
