import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:novel/pages/book_detail/book_detail_model.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/services/book.dart';

class BookDetailController extends GetxController {
  Rx<BookDetailModel> bookDetailModel = BookDetailModel().obs;
  RxBool inShelf = false.obs;
  HomeController _homeController = Get.find<HomeController>();
  Book? _book;

  @override
  void onInit() {
    BookApi().detail(Get.arguments['bookId']).then((value) {
      bookDetailModel.value = value;
      inShelf.value = _homeController.shelf
          .map((element) => element.id)
          .toList()
          .contains(value.id);
      _book = Book(
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
    });
    super.onInit();
  }

  modifyShelf() async {
    await _homeController.modifyShelf(_book!);
    inShelf.value = !inShelf.value;
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
