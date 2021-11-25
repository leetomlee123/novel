import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get/get.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';

enum LOAD_STATUS { LOADING, FAILED, FINISH }

class ReadBookController extends GetxController {
  Book? book;
  Rx<LOAD_STATUS> loadStatus = LOAD_STATUS.LOADING.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    book = Get.find<HomeController>().getBookById(Get.arguments['id']);
    Future.delayed(
        Duration(seconds: 3), () => loadStatus.value = LOAD_STATUS.FAILED);
    FlutterStatusbarManager.setFullscreen(true);
  }

  @override
  void onReady() {}

  @override
  Future<void> onClose() async {
    FlutterStatusbarManager.setFullscreen(false);
  }
}
