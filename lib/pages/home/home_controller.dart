import 'package:get/get.dart';
import 'package:novel/pages/home/home_model.dart';

class HomeController extends GetxController {
  RxList shelf = List<ShelfModel>.empty().obs;

  var cover = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  freshShelf() {}
}
