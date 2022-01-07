import 'package:get/get.dart';
import 'listen_controller.dart';

class ListenBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<ListenController>(() => ListenController());
    }
}
