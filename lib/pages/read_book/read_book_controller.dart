import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get/get.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';

enum LOAD_STATUS { LOADING, FAILED, FINISH }

class ReadBookController extends FullLifeCycleController with FullLifeCycle {
  Book? book;
  Rx<LOAD_STATUS> loadStatus = LOAD_STATUS.LOADING.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    book = Get.find<HomeController>().getBookById(Get.arguments['id']);
    Future.delayed(
        Duration(seconds: 3), () => loadStatus.value = LOAD_STATUS.FINISH);
    FlutterStatusbarManager.setFullscreen(true);
  }

  @override
  void onReady() {}

  @override
  void onClose() async {
    FlutterStatusbarManager.setFullscreen(false);
  }

  saveState() {}

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    print("挂起");
  }

  @override
  void onResumed() {
    print("恢复");
  }
}
