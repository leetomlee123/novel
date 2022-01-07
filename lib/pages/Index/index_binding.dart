import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/pages/book_city/book_city_controller.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexController>(() => IndexController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BookCityController>(() => BookCityController());
    Get.lazyPut<ListenController>(() => ListenController());
  }
}
