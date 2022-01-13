import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/pages/book_search/book_search_model.dart';
import 'package:novel/services/book.dart';
import 'package:sp_util/sp_util.dart';

class BookSearchController extends GetxController {
  int page = 0;
  RxBool isFinish = false.obs;
  RxList books = List<SearchBookModel>.empty().obs;
  RxList<HotBookModel> hotRank = List<HotBookModel>.empty().obs;
  TextEditingController textEditingController = TextEditingController();
  RxList<String> history = List<String>.empty().obs;

  String get query => textEditingController.text;

  int get count => books.length;

  @override
  void onInit() {
    super.onInit();
    getHistory();
    getHotRank();
  }

  getHistory() {
    history.addAll(SpUtil.getStringList(ReadSetting.searchHistory)!);
  }

  getHotRank() async {
    hotRank.value = await BookApi().hotRank();
  }

  historyItemSearch(String v) async {
    textEditingController.text = v;
    await search(v);
  }

  Future<bool> loadMore() async {
    var bks = await BookApi().search(query, page += 1);
    if (bks.isEmpty) {
      isFinish.value = true;
      return false;
    } else {
      if (page == 1) {
        addHistory(textEditingController.text);
      }
      Get.focusScope!.unfocus();
      books.addAll(bks);
      return true;
    }
  }

  addHistory(String v) {
    history.removeWhere((element) => element == v);
    history.insert(0, v);
    if (history.length > 12) {
      history.value = history.sublist(0, 12);
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    textEditingController.text = "";
    books.clear();
    SpUtil.putStringList(ReadSetting.searchHistory, history);
  }

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

  clearHistory() {
    history.clear();
    SpUtil.remove(ReadSetting.searchHistory);
  }
}
