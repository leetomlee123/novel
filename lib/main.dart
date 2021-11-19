import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:novel/common/langs/translation_service.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/Index/Index_view.dart';
import 'package:novel/pages/Index/index_binding.dart';
import 'package:novel/router/app_pages.dart';
import 'package:get/get.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'novel',
      home: IndexPage(),
      initialBinding: IndexBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      unknownRoute: AppPages.unknownRoute,
      builder: EasyLoading.init(),
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
    );
  }
}
