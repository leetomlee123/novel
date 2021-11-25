import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/services/book.dart';
import 'package:novel/utils/database_provider.dart';

class HomeController extends GetxController {
  RxList shelf = List<Book>.empty().obs;
  RxList pickList = List<int>.empty().obs;

  //书架显示风格
  RxBool coverLayout = false.obs;

  //管理书架
  RxBool manageShelf = false.obs;

  //全选
  RxBool pickAll = false.obs;

  @override
  void onInit() {
    initShelf();
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  initShelf() async {
    shelf.value = await DataBaseProvider.dbProvider.getBooks();
    updateShelf();
  }

  getBookById(String id) {
    return shelf.where((element) => id == element.id).first;
  }

  updateShelf() async {
    bool hasUpdate = false;
    var books = await BookApi().shelf();
    if (shelf.isEmpty) {
      shelf.value = books;
      return;
    }
    for (Book value in shelf) {
      Book where = books.where((element) => value.id == element.id).first;
      //有更新
      if (where.lastChapter != value.lastChapter) {
        hasUpdate = true;
        value.newChapter = 1;
        value.uTime = where.uTime;
        value.lastChapter = where.lastChapter;
        value.img = where.img;
        DataBaseProvider.dbProvider.updBook(value);
      }
    }
    if (hasUpdate) update();
  }

  menuAction(var value) {
    if (value == "书架整理") {
      manage();
    } else {
      coverLayout.value = !coverLayout.value;
    }
  }

  pickAction() {
    pickAll.value = !pickAll.value;

    if (pickAll.value) {
      for (int i = 0; i < shelf.length; i++) {
        pickList.add(i);
      }
    } else {
      pickList.clear();
    }
  }

  manage() {
    pickList.clear();
    pickAll.value = false;
    manageShelf.value = !manageShelf.value;
  }

  deleteBooks() {
    for (var value in pickList) {
      modifyShelf(shelf[value]);
    }
    pickList.clear();
  }

  tapAction(int i) {
    //整理书架点击动作
    if (manageShelf.value) {
      if (pickList.contains(i)) {
        pickList.remove(i);
      } else {
        pickList.add(i);
      }
    } else {
      //阅读动作
      Book elementAt = shelf[i];
      elementAt.newChapter = 0;
      elementAt.sortTime = DateUtil.getNowDateMs();
      DataBaseProvider.dbProvider.updBook(elementAt);
      Get.toNamed(AppRoutes.ReadBook, arguments: {"id": elementAt.id});
      shelf.sort((o1, o2) => o2.sortTime.compareTo(o1.sortTime));
    }
  }

  modifyShelf(Book book) async {
    var action =
        shelf.map((f) => f.id).toList().contains(book.id ?? "") ? 'del' : 'add';
    if (action == "add") {
      shelf.insert(0, book);
      await DataBaseProvider.dbProvider.addBooks([book]);
    } else if (action == "del") {
      for (var i = 0; i < shelf.length; i++) {
        if (shelf[i].id == book.id) {
          DataBaseProvider.dbProvider.clearBooksById(book.id ?? "");
          shelf.removeAt(i);
        }
      }
      // delLocalCache([book.Id]);
      // SpUtil.remove(book.Id);
      // SpUtil.getKeys().forEach((element) {
      //   if (element.startsWith(book.Id + "pages")) {
      //     SpUtil.remove(element);
      //   }
      // });
    }
    if (Global.isOfflineLogin) {
      BookApi().modifyShelf(book.id ?? "", action);
    }
  }

  syncBooks2Cloud() async {
    for (var value in shelf) {
      var id = value.id;
      await BookApi().modifyShelf(id, 'add');
    }
  }
}
