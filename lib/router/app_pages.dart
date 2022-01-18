import 'package:get/get.dart';
import 'package:novel/pages/Index/Index_view.dart';
import 'package:novel/pages/ad/ad_binding.dart';
import 'package:novel/pages/ad/ad_view.dart';
import 'package:novel/pages/book_detail/book_detail_binding.dart';
import 'package:novel/pages/book_detail/book_detail_view.dart';
import 'package:novel/pages/book_menu/book_menu_binding.dart';
import 'package:novel/pages/book_menu/book_menu_view.dart';
import 'package:novel/pages/book_search/book_search_binding.dart';
import 'package:novel/pages/book_search/book_search_view.dart';
import 'package:novel/pages/find_password/find_password_binding.dart';
import 'package:novel/pages/find_password/find_password_view.dart';
import 'package:novel/pages/font_set/font_set_binding.dart';
import 'package:novel/pages/font_set/font_set_view.dart';
import 'package:novel/pages/home/home.binding.dart';
import 'package:novel/pages/home/home_view.dart';
import 'package:novel/pages/listen/listen_binding.dart';
import 'package:novel/pages/listen/listen_view.dart';
import 'package:novel/pages/login/login_binding.dart';
import 'package:novel/pages/login/login_view.dart';
import 'package:novel/pages/notfound/notfound_view.dart';
import 'package:novel/pages/proxy/proxy_view.dart';
import 'package:novel/pages/read_book/read_book_binding.dart';
import 'package:novel/pages/read_book/read_book_view.dart';
import 'package:novel/pages/register/register_binding.dart';
import 'package:novel/pages/register/register_view.dart';
import 'package:novel/pages/shelf/shelf_binding.dart';
import 'package:novel/pages/shelf/shelf_view.dart';

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
      name: AppRoutes.ReadBook,
      page: () => ReadBookPage(),
      binding: ReadBookBinding(),
    ),
    GetPage(
      name: AppRoutes.SearchBook,
      page: () => BookSearchPage(),
      binding: BookSearchBinding(),
    ),
    GetPage(
      name: AppRoutes.BookDetail,
      page: () => BookDetailPage(),
      binding: BookDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.BookMenu,
      page: () => BookMenuPage(),
      binding: BookMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.FontSet,
      page: () => FontSetPage(),
      binding: FontSetBinding(),
    ),
    GetPage(
      name: AppRoutes.listen,
      page: () => ListenPage(),
      binding: ListenBinding(),
    ),
    GetPage(
      name: AppRoutes.Ad,
      page: () => AdPage(),
      binding: AdBinding(),
    ),
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
