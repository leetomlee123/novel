import 'package:get/get.dart';
import 'find_password_controller.dart';

class FindPasswordBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<FindPasswordController>(() => FindPasswordController());
    }
}
