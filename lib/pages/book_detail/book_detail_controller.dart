import 'package:common_utils/common_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/pages/book_detail/book_detail_model.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/services/book.dart';

class BookDetailController extends GetxController with StateMixin {
  Rx<BookDetailModel> bookDetailModel = BookDetailModel().obs;
  RxBool inShelf = false.obs;
  HomeController _homeController = Get.find<HomeController>();
  Book? book;
  RxBool ok = false.obs;

  @override
  void onInit() {
    getDetail(Get.arguments['bookId']);

    super.onInit();
  }

  getDetail(String bookId) async {
    ok.value = false;
    var value = await BookApi().detail(bookId);
    bookDetailModel.value = value;

    book = Book(
        id: value.id,
        name: value.name,
        cName: value.cName,
        rate: value.rate,
        sortTime: DateUtil.getNowDateMs(),
        author: value.author,
        uTime: value.lastTime,
        desc: value.desc,
        bookStatus: value.bookStatus,
        img: value.img,
        lastChapter: value.lastChapter);
    inShelf.value = _homeController.shelf
        .map((element) => element.id)
        .toList()
        .contains(bookDetailModel.value.id);
    ok.toggle();
  }

  modifyShelf() async {
    await _homeController.modifyShelf(book!);
    inShelf.toggle();
  }

  @override
  void onReady() {
    SystemChrome.setSystemUIOverlayStyle(
        Get.isDarkMode ? ReadSetting.light : ReadSetting.dark);
  }

  @override
  void onClose() {
    SystemChrome.setSystemUIOverlayStyle(
        Get.isDarkMode ? ReadSetting.light : ReadSetting.dark);
  }
}
