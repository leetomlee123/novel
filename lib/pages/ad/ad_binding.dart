import 'package:get/get.dart';
import 'ad_controller.dart';

class AdBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<AdController>(() => AdController());
    }
}
