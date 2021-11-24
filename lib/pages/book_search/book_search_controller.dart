import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/book_search/book_search_model.dart';
import 'package:novel/services/book.dart';

class BookSearchController extends GetxController {
  int page = 0;
  RxBool isFinish = false.obs;
  RxList books = List<SearchBookModel>.empty().obs;
  TextEditingController textEditingController = TextEditingController();

  String get query => textEditingController.text;

  int get count => books.length;

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> loadMore() async {
    print("search");
    var bks = await BookApi().search(query, page += 1);
    if (bks.isEmpty) {
      isFinish.value = true;
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

  search(String v) async {
    page = 0;
    books.clear();
    await loadMore();
  }

  clear() {
    textEditingController.clear();
    page = 0;
    books.clear();
  }

  refreshData() async {
    // books.clear();
    // page = 0;
    // await loadMore();
  }
}
