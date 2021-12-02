import 'package:get/get.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/read_book/read_book_controller.dart';


class BookMenuController extends GetxController {
  //menu
  final readBookController = Get.find<ReadBookController>();
 
  Rx<ReadSetting?> setting = Global.setting.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
