import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:novel/pages/book_detail/book_detail_model.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/services/book.dart';

class BookDetailController extends GetxController with StateMixin {
  Rx<BookDetailModel> bookDetailModel = BookDetailModel().obs;
  RxBool inShelf = false.obs;
  HomeController _homeController = Get.find<HomeController>();
  Book? book;

  @override
  void onInit() {
    getDetail(Get.arguments['bookId']);

    super.onInit();
  }

  getDetail(String bookId) async {
    change(null, status: RxStatus.loading());
    var value = await BookApi().detail(bookId);
    bookDetailModel.value = value;
    inShelf.value = _homeController.shelf
        .map((element) => element.id)
        .toList()
        .contains(bookDetailModel.value.id);
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
    change(null, status: RxStatus.success());
  }

  modifyShelf() async {
    await _homeController.modifyShelf(book!);
    inShelf.value = !inShelf.value;
    print("ddd");
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
