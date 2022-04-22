import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
      theme: ThemeData(
        backgroundColor: Color.fromARGB(255, 5, 66, 116),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 5, 66, 116)),
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline2: TextStyle(
              fontSize: 32.0, fontWeight: FontWeight.w400, color: Colors.white),
          headline3: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.w400, color: Colors.white),
          headline4: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.w400, color: Colors.white),
          headline6: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w200, color: Colors.white),
          bodyText1: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w200,
          ),
        ),
        fontFamily: 'Georgia',
      ),
      home: ListenPage(),
      initialBinding: ListenBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      unknownRoute: AppPages.unknownRoute,
      navigatorObservers: [
        RouterObserver(),
        FirebaseAnalyticsObserver(analytics: Global.analytics)
      ],
      builder: BotToastInit(),
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
    );
  }
}
