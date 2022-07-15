import 'package:get/get.dart';
import 'qr_controller.dart';

class QrBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<QrController>(() => QrController());
    }
}
