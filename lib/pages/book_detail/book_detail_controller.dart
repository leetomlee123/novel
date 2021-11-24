import 'package:get/get.dart';
import 'package:novel/pages/book_detail/book_detail_model.dart';
import 'package:novel/services/book.dart';

class BookDetailController extends GetxController {
  Rx<BookDetailModel> bookDetailModel = BookDetailModel().obs;

  @override
  void onInit() {
    BookApi()
        .detail(Get.arguments['bookId'])
        .then((value) => bookDetailModel.value = value);
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
