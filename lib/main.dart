import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/common/langs/translation_service.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/listen/listen_view.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/router/router_observer.dart';

import 'pages/listen/listen_binding.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'novel',
      // theme: ThemeData(
      //   fontFamily: 'Georgia',
      // ),
      home: ListenPage(),
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
      initialBinding: ListenBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      unknownRoute: AppPages.unknownRoute,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: Global.analytics),
        RouterObserver(),
      ],
      builder: BotToastInit(),
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
    );
  }

}
