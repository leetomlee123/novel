import 'package:get/get.dart';
import 'font_set_controller.dart';

class FontSetBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<FontSetController>(() => FontSetController());
    }
}
