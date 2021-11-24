import 'package:get/get.dart';
import 'book_chapters_controller.dart';

class BookChaptersBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<BookChaptersController>(() => BookChaptersController());
    }
}
