import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:get/get.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexController>(() => IndexController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
