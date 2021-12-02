import 'package:get/get.dart';
import 'package:novel/pages/book_menu/book_menu_controller.dart';

import 'read_book_controller.dart';

class ReadBookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadBookController>(() => ReadBookController());
    Get.lazyPut<BookMenuController>(() => BookMenuController());
  }
}
