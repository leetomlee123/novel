import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get/get.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';

class ReadBookController extends GetxController {
   Book book = Book().obs();

  @override
  Future<void> onInit() async {
    super.onInit();
    book=Get.find<HomeController>().getBookById(Get.arguments['id']);
    print(book.id);

    FlutterStatusbarManager.setFullscreen(true);
  }

  @override
  void onReady() {}

  @override
  Future<void> onClose() async {
    FlutterStatusbarManager.setFullscreen(false);
  }
}
