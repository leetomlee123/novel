import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get/get.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';

class ReadBookController extends GetxController {
  final Book book = Get.find<HomeController>().getBookById(Get.arguments['id']);

  @override
  Future<void> onInit() async {
    super.onInit();

    FlutterStatusbarManager.setFullscreen(true);
  }

  @override
  void onReady() {}

  @override
  Future<void> onClose() async {
    FlutterStatusbarManager.setFullscreen(false);
  }
}
