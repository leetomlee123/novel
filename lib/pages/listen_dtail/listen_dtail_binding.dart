import 'package:get/get.dart';
import 'listen_dtail_controller.dart';

class ListenDtailBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<ListenDtailController>(() => ListenDtailController());
    }
}
