import 'package:get/get.dart';
import 'book_menu_controller.dart';

class BookMenuBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<BookMenuController>(() => BookMenuController());
    }
}
