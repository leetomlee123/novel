import 'package:get/get.dart';
import 'book_search_controller.dart';

class BookSearchBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<BookSearchController>(() => BookSearchController());
    }
}
