import 'package:get/get.dart';
import 'shelf_controller.dart';

class ShelfBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<ShelfController>(() => ShelfController());
    }
}
