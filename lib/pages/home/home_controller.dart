import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:common_utils/common_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/services/book.dart';
import 'package:novel/utils/database_provider.dart';
import 'package:sp_util/sp_util.dart';

class HomeController extends GetxController {
  //阅读页背景图片
  Map<int, ui.Image>? bgImages = Map();
  Map<String, ui.Picture> widgets = Map();
  RxList<Book> shelf = RxList<Book>();
  RxList pickList = List<int>.empty().obs;
  IndexController indexController = Get.find<IndexController>();
  //书架显示风格
  RxBool coverLayout = false.obs;

  //管理书架
  RxBool manageShelf = false.obs;

  //全选
  RxBool pickAll = false.obs;

  @override
  void onInit() {
    ever(manageShelf, (_) {
      indexController.showBottom.value = !manageShelf.value;
    });

    coverLayout.value = Global.setting!.isListCover ?? false;

    initShelf();
    initReadPageImages();

    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  initReadPageImages() async {
    for (int i = 0; i < 7; i++) {
      ByteData data = await rootBundle.load("images/${ReadSetting.bgImgs[i]}");
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: Screen.width.ceil(), targetHeight: Screen.height.ceil());
      ui.FrameInfo fi = await codec.getNextFrame();
      bgImages!.putIfAbsent(i, () => fi.image);
    }
    //预加载阅读页
    loadReadPage();
  }

  initShelf() async {
    shelf.value = await DataBaseProvider.dbProvider.getBooks();
    updateShelf();
  }

  getBookById(String id) {
    return shelf.where((element) => id == element.id).first;
  }

  updateShelf() async {
    // bool hasUpdate = false;
    if (!(Global.profile!.token!.isNotEmpty && shelf.isNotEmpty)) return;
    var books = await BookApi().shelf();
    if (shelf.isEmpty) {
      shelf.value = books;
      return;
    }
    List<Book> booksTemp = List.empty(growable: true);

    for (Book value in shelf) {
      var bks = books.where((element) => value.id == element.id);
      if (bks.isEmpty) {
        booksTemp.add(value);
        continue;
      }
      Book where = bks.first;
      //有更新
      if (where.lastChapter != value.lastChapter) {
        // hasUpdate = true;
        value.newChapter = 1;
        value.uTime = where.uTime;
        value.lastChapter = where.lastChapter;
        value.img = where.img;
        DataBaseProvider.dbProvider.updBook(value);
      }
      booksTemp.add(value);
    }
    shelf.value = booksTemp;
    // update();
    // if (hasUpdate) update();
  }

  menuAction(var value) {
    if (value == "书架整理") {
      manage();
    } else {
      coverLayout.toggle();
      Global.setting!.isListCover = coverLayout.value;
      SpUtil.putObject(ReadSetting.settingKey, Global.setting!.toJson());
    }
  }

  pickAction() {
    pickAll.toggle();
    pickList.clear();

    if (pickAll.value) {
      for (int i = 0; i < shelf.length; i++) {
        pickList.add(i);
      }
    }
  }

  manage() {
    pickList.clear();
    pickAll.value = false;
    manageShelf.toggle();
  }

  deleteBooks() {
    var bks = pickList.map((element) => shelf.elementAt(element)).toList();
    for (var bk in bks) {
      modifyShelf(bk);
    }
    pickList.clear();
  }

  tapAction(int i) {
    print(i);
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
      shelf.sort((o1, o2) => o2.sortTime!.compareTo(o1.sortTime!.toInt()));
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
      await BookApi().modifyShelf(id!, 'add');
    }
  }

  //
  loadReadPage() {
    SpUtil.getKeys()!.forEach((key) {
      if (key.startsWith("pages")) {}
    });

    //   shelf.forEach((book) async {
    //     var id = book.id;
    //     List<ChapterProto> cps =
    //         await DataBaseProvider.dbProvider.getChapters(id);

    //     if (cps.isNotEmpty) {
    //       var key = book.id.toString() +
    //           book.chapterIdx.toString() +
    //           book.pageIdx.toString();
    //       bool? darkModel = Global.setting!.isDark;
    //       var bgImage;
    //       if (darkModel!) {
    //         bgImage = bgImages![ReadSetting.bgImgs.length - 1];
    //       } else {
    //         bgImage = bgImages![Global.setting!.bgIndex ?? 0];
    //       }
    //       var electricQuantity = await Battery().batteryLevel / 100;

    //        var pages = 'pages_${book.id}_${book.chapterIdx}';
    //           var pageData = LocalStorage().getJSON(key);

    //   if (pageData != null) {
    //        ReadPage readPage = ReadPage();
    //     readPage.pages =
    //         pageData.map((e) => TextPage.fromJson(e)).toList().cast<TextPage>();
    //     LocalStorage().remove(key);
    //   }
    //       widgets.putIfAbsent(
    //           key,
    //           () => TextComposition.drawContent(
    //                 readPage,
    //                 book.pageIdx,
    //                 Global.setting!.isDark,
    //                 Global.setting,
    //                 bgImage,
    //                 electricQuantity,
    //               ));
    //     }}
    //   });
  }
}
