import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get/get.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/book_chapters/chapter.pb.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/pages/read_book/read_book_model.dart';
import 'package:novel/services/book.dart';
import 'package:novel/utils/chapter_parse.dart';
import 'package:novel/utils/database_provider.dart';
import 'package:novel/utils/local_storage.dart';
import 'package:novel/utils/text_composition.dart';

enum LOAD_STATUS { LOADING, FAILED, FINISH }

class ReadBookController extends FullLifeCycleController with FullLifeCycle {
  Book? book;
  Rx<LOAD_STATUS> loadStatus = LOAD_STATUS.LOADING.obs;
  RxBool saveReadState = true.obs;
  RxBool inShelf = false.obs;
  RxList chapters = List.empty().obs;
  RxBool showMenu = false.obs;
  Map<int, ui.Image>? bgImage;
  ReadSetting? setting;

  //
  ReadPage? prePage;
  ReadPage? curPage;
  ReadPage? nextPage;
  //
  GlobalKey? canvasKey;
  @override
  void onInit() {
    super.onInit();
    String bookId = Get.arguments['id'].toString();
    if (bookId.isEmpty) {
      book = Book.fromJson(Get.arguments['bookJson']);
    } else {
      book = Get.find<HomeController>().getBookById(bookId);
      inShelf.value = true;
    }
    setting = Get.find<HomeController>().setting;
    bgImage = Get.find<HomeController>().bgImages;
    initData();
    FlutterStatusbarManager.setFullscreen(true);
  }

  initData() async {
    try {
      chapters.value = await DataBaseProvider.dbProvider.getChapters(book!.id);
      if (chapters.isEmpty) {
        //初次打开
        await getReadRecord();
        await getChapter();
      } else {
        getChapter();
      }
      loadStatus.value = LOAD_STATUS.FINISH;
    } catch (e) {
      loadStatus.value = LOAD_STATUS.FAILED;
    }
  }

  initContent(int idx, bool jump) async {
    curPage = await loadChapter(idx);

    loadChapter(idx + 1).then((value) => {nextPage = value});

    loadChapter(idx - 1).then((value) => {prePage = value});

    if (jump) {
      book!.pageIdx = 0;
      canvasKey!.currentContext?.findRenderObject()?.markNeedsPaint();
    }
  }

  loadChapter(int idx) async {
    if (idx < 0 || idx >= chapters.length) {
      return null;
    }
    ReadPage readPage = ReadPage();
    var chapter = chapters[idx];
    readPage.chapterName = chapter.chapterName;
    readPage.chapterContent =
        await DataBaseProvider.dbProvider.getContent(chapter.chapterId);

    //获取章节内容
    if (readPage.chapterContent!.isEmpty) {
      readPage.chapterContent = await getChapterContent(idx);
      if (readPage.chapterContent!.isEmpty) {
        readPage.chapterContent = "章节内容加载失败,请重试.......\n";
      } else {
        await DataBaseProvider.dbProvider
            .updateContent(chapter.chapterId, readPage.chapterContent);
        chapters[idx].hasContent = "2";
      }
    }
    //获取分页数据
    //本地是否有分页的缓存
    var key = '${book!.id}_pages_${chapter.chapterId}';
    var pageData = LoacalStorage().getJSON(key);

    if (pageData != null) {
      List<TextPage> list = pageData.map((e) => TextPage.fromJson(e)).toList();
      readPage.pages = list;
      LoacalStorage().remove(key);
    } else {
      readPage.pages = TextComposition.parseContent(readPage, setting!);
    }
  }

  getChapterContent(int idx) async {
    //从数据库中取
    var chapterId = chapters[idx].chapterId;
    var res = await BookApi().getContent(chapterId);
    String chapterContent = res['data'];
    if (chapterContent.isEmpty) {
      //本地解析
      chapterContent = await ChapterParseUtil().parseContent(res['link']);
      //上传到数据库
      BookApi().updateContent(chapterId, chapterContent);
    }
    return chapterContent;
  }

  getChapter() async {
    List<ChapterProto> cps =
        await BookApi().getChapters(book!.id, chapters.length);
    if (cps.isNotEmpty) {
      chapters.addAll(cps);
      DataBaseProvider.dbProvider.addChapters(cps, book!.id);
    }
  }

  getReadRecord() async {
    if (Global.profile!.token!.isNotEmpty) {
      book!.chapterIdx =
          await BookApi().getReadRecord(Global.profile!.username, book!.id);
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    super.onClose();
    FlutterStatusbarManager.setFullscreen(false);
  }

  saveState() {}

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    print("挂起");
  }

  @override
  void onResumed() {
    print("恢复");
  }


}
