import 'package:novel/pages/Index/Index_view.dart';
import 'package:novel/pages/find_password/find_password_binding.dart';
import 'package:novel/pages/find_password/find_password_view.dart';
import 'package:novel/pages/home/home.binding.dart';
import 'package:novel/pages/home/home_view.dart';
import 'package:novel/pages/login/login_binding.dart';
import 'package:novel/pages/login/login_view.dart';
import 'package:novel/pages/movie/movie_binding.dart';
import 'package:novel/pages/movie/movie_view.dart';
import 'package:novel/pages/notfound/notfound_view.dart';
import 'package:novel/pages/proxy/proxy_view.dart';
import 'package:novel/pages/register/register_binding.dart';
import 'package:novel/pages/register/register_controller.dart';
import 'package:novel/pages/register/register_view.dart';
import 'package:novel/pages/shelf/shelf_binding.dart';
import 'package:novel/pages/shelf/shelf_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.Index;

  static final routes = [
    GetPage(
      name: AppRoutes.Index,
      page: () => IndexPage(),
    ),
    GetPage(
      name: AppRoutes.Login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.Register,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.FindPassword,
      page: () => FindPasswordPage(),
      binding: FindPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.Home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.Shelf,
      page: () => ShelfPage(),
      binding: ShelfBinding(),
    ),
    
    GetPage(
        name: AppRoutes.Movie,
        page: () => MoviePage(),
        binding: MovieBinding(),
        children: [
  
        ]),
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
