import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_binding.dart';
import 'package:novel/pages/listen/listen_view.dart';
import 'package:novel/pages/listen_dtail/listen_dtail_binding.dart';
import 'package:novel/pages/listen_dtail/listen_dtail_view.dart';
import 'package:novel/pages/notfound/notfound_view.dart';
import 'package:novel/pages/proxy/proxy_view.dart';


import '../pages/search/search_binding.dart';
import '../pages/search/search_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.listen;

  static final routes = [
    GetPage(
      name: AppRoutes.listen,
      page: () => ListenPage(),
      binding: ListenBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => SearchPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () =>ListenDtailPage(),
      binding: ListenDtailBinding(),
    )
  ];

  static final unknownRoute = GetPage(
    name: AppRoutes.NotFound,
    page: () => NotfoundPage(),
  );

  static final proxyRoute = GetPage(
    name: AppRoutes.Proxy,
    page: () => ProxyPage(),
  );
}
