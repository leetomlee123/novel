import 'package:get/get.dart';
import 'package:novel/pages/book_search/book_search_model.dart';
import 'package:novel/services/book.dart';

class BookSearchController extends GetxController {
  int page = 1;
  bool isFinish = true;
  RxList books = List<SearchBookModel>.empty().obs;

  int get count => books.length;

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> loadMore() async {
    var bks = await BookApi().search("", page += 1);
    if (bks.isEmpty) {
      return false;
    } else {
      books.addAll(bks);
      return true;
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
