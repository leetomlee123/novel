import 'dart:ui' as ui;

import 'package:battery_plus/battery_plus.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get/get.dart';
import 'package:novel/common/animation/AnimationControllerWithListenerNumber.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/pages/book_chapters/chapter.pb.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/pages/read_book/NovelPagePainter.dart';
import 'package:novel/pages/read_book/ReaderPageManager.dart';
import 'package:novel/pages/read_book/read_book_model.dart';
import 'package:novel/services/book.dart';
import 'package:novel/utils/chapter_parse.dart';
import 'package:novel/utils/database_provider.dart';
import 'package:novel/utils/text_composition.dart';
import 'package:sp_util/sp_util.dart';

enum LOAD_STATUS { LOADING, FINISH }
enum OperateType { SLIDE, MORE_SETTING, DOWNLOAD }

class ReadBookController extends SuperController
    with GetSingleTickerProviderStateMixin {
  Rx<Book> book = Book().obs;
  RxInt chapterIdx = 0.obs;
  Rx<LOAD_STATUS> loadStatus = LOAD_STATUS.LOADING.obs;
  RxBool saveReadState = true.obs;
  RxBool inShelf = false.obs;
  RxList<ChapterProto> chapters = List<ChapterProto>.empty(growable: true).obs;
  RxBool showMenu = false.obs;
  double? electricQuantity = 1.0;
  ui.Image? bgImage;
  Paint bgPaint = Paint();
  NovelPagePainter? mPainter;
  TouchEvent currentTouchEvent = TouchEvent(TouchEvent.ACTION_UP, Offset.zero);
  AnimationController? animationController;
  GlobalKey canvasKey = new GlobalKey();

  /// 翻页动画类型
  int currentAnimationMode = ReaderPageManager.TYPE_ANIMATION_COVER_TURN;

  //
  ReadPage? prePage;
  ReadPage? curPage;
  ReadPage? nextPage;

  //
  HomeController? homeController;
  IndexController? idxController;
  //menu
  double? settingH = 340;
  ReadSetting? setting;
  Rx<OperateType> type = OperateType.SLIDE.obs;

  RxBool darkModel = Get.isDarkMode.obs;

  //chapter
  ScrollController indexController = ScrollController();

  var itemExtent = 50.0;

  int downCommitLen = 20;

  //setting
  RxDouble fontSize = .0.obs;
  RxDouble latterHeight = .0.obs;
  RxDouble paragraphHeight = .0.obs;
  RxDouble pageSpace = .0.obs;
  RxBool leftClickNext = false.obs;

  @override
  void onInit() {
    super.onInit();

    homeController = Get.find<HomeController>();
    idxController = Get.find<IndexController>();
    String bookId = Get.arguments['id'].toString();
    if (bookId == "null") {
      book.value = Book.fromJson(Get.arguments['bookJson']);
    } else {
      book.value = homeController!.getBookById(bookId);
      inShelf.value = true;
    }
    setting = Global.setting;
    fontSize.value = setting!.fontSize!;
    latterHeight.value = setting!.latterHeight!;
    paragraphHeight.value = setting!.paragraphHeight!;
    pageSpace.value = setting!.pageSpace!;
    leftClickNext.value = setting!.leftClickNext!;
    if (darkModel.value) {
      bgImage = homeController!.bgImages![ReadSetting.bgImgs.length - 1];
    } else {
      bgImage = homeController!.bgImages![setting!.bgIndex ?? 0];
    }
    initReadConfig();
    initData();

    FlutterStatusbarManager.setFullscreen(true);
  }

  initReadConfig() {
    switch (currentAnimationMode) {
      case ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN:
      case ReaderPageManager.TYPE_ANIMATION_COVER_TURN:
        animationController = AnimationControllerWithListenerNumber(
          vsync: this,
        );
        break;
      case ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN:
        animationController = AnimationControllerWithListenerNumber.unbounded(
          vsync: this,
        );
        break;
    }

    if (animationController != null) {
      ReaderPageManager pageManager = ReaderPageManager();
      pageManager.setCurrentAnimation(currentAnimationMode);
      pageManager.setCurrentCanvasContainerContext(canvasKey);
      pageManager.setAnimationController(animationController!);
      pageManager.setContentViewModel(this);
      mPainter = NovelPagePainter(pageManager: pageManager);
    }
    mPainter = mPainter;
  }

  initData() async {
    try {
      electricQuantity = await Battery().batteryLevel / 100;

      chapters.value =
          await DataBaseProvider.dbProvider.getChapters(book.value.id);
      if (chapters.isEmpty) {
        //初次打开
        await getReadRecord();
        await getChapters();
      } else {
        getChapters();
      }
      chapterIdx.value = book.value.chapterIdx!;
      await initContent(book.value.chapterIdx!, false);
      await cur();
      indexController = ScrollController(
          initialScrollOffset: (book.value.chapterIdx ?? 0) == 0
              ? 0
              : (book.value.chapterIdx! - 6) * itemExtent);
      loadStatus.value = LOAD_STATUS.FINISH;
    } catch (e) {
      loadStatus.value = LOAD_STATUS.FINISH;
      print(e);
    }
  }

  reInitController() {
    indexController = ScrollController(
        initialScrollOffset: (book.value.chapterIdx ?? 0) == 0
            ? 0
            : (book.value.chapterIdx! - 6) * itemExtent);
  }

  initContent(int idx, bool jump) async {
    curPage = await loadChapter(idx);

    loadChapter(idx + 1).then((value) => {nextPage = value});

    loadChapter(idx - 1).then((value) => {prePage = value});

    if (jump) {
      reInitController();
      chapterIdx.value = book.value.chapterIdx!;
      book.value.pageIdx = 0;
      canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
    }
  }

  loadChapter(int idx) async {
    ReadPage readPage = ReadPage();
    if (idx < 0 || idx >= chapters.length) {
      return null;
    }
    var chapter = chapters[idx];
    readPage.chapterName = chapter.chapterName;
    readPage.chapterContent =
        await DataBaseProvider.dbProvider.getContent(chapter.chapterId);

    //获取章节内容
    if (readPage.chapterContent!.isEmpty) {
      readPage.chapterContent =
          await ChapterParseUtil().getChapterCotent(chapters[idx].chapterId);
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
    var key = 'pages_${book.value.id}_${chapter.chapterName}';

    if (SpUtil.haveKey(key)!) {
      readPage.pages =
          SpUtil.getObjList(key, (v) => TextPage.fromJson(v))!.toList();
      SpUtil.remove(key);
    } else {
      readPage.pages = TextComposition.parseContent(readPage, setting!);
    }
    return readPage;
  }

  //下载章节内容
  download(int idx) async {
    book.value.cacheChapterContent = "1";
    DataBaseProvider.dbProvider.updBook(book.value);

    List<DownChapter> cps = List.empty(growable: true);
    for (var i = idx; i < chapters.length; i++) {
      if (chapters[i].hasContent != "2") {
        cps.add(DownChapter(
          idx: i,
          chapterId: chapters[i].chapterId,
        ));
        if (cps.length % downCommitLen == 0) {
          cps = await compute(downChapter, cps);
          cps.forEach((element) {
            chapters[element.idx ?? 0].hasContent = "2";
          });
          DataBaseProvider.dbProvider.downContent(cps);
          cps.clear();
        }
      }
    }
  }

  saveState() {
    if (saveReadState.value) {
      DataBaseProvider.dbProvider.updBook(book.value);
      SpUtil.putObjectList('pages_${book.value.id}_${prePage?.chapterName}',
          prePage?.pages ?? []);
      SpUtil.putObjectList('pages_${book.value.id}_${curPage?.chapterName}',
          curPage?.pages ?? []);
      SpUtil.putObjectList('pages_${book.value.id}_${nextPage?.chapterName}',
          nextPage?.pages ?? []);

      if (Global.profile!.token!.isNotEmpty) {
        BookApi().uploadReadRecord(Global.profile!.username, book.value.id,
            book.value.chapterIdx.toString());
      }
    }
    setting!.persistence();
  }

  /*页面点击事件 */
  void tapPage(TapUpDetails details) {
    var wid = Screen.width;
    var hSpace = Screen.height / 4;
    var space = wid / 3;
    var curWid = details.globalPosition.dx;
    var curH = details.globalPosition.dy;
    var location = details.localPosition;
    if ((curWid > space) && (curWid < 2 * space) && (curH < hSpace * 3)) {
      toggleShowMenu();
    } else if ((curWid > space * 2)) {
      if (leftClickNext.value) {
        clickPage(1, location);
        return;
      }
      clickPage(1, location);
    } else if ((curWid > 0 && curWid < space)) {
      if (leftClickNext.value) {
        clickPage(1, location);
        return;
      }
      clickPage(-1, location);
    }
  }

  //点击模拟滑动
  void clickPage(int f, Offset detail) {
    TouchEvent currentTouchEvent = TouchEvent(TouchEvent.ACTION_DOWN, detail);

    mPainter!.setCurrentTouchEvent(currentTouchEvent);

    var offset = Offset(
        f > 0
            ? (detail.dx - Screen.width / 15 - 5)
            : (detail.dx + Screen.width / 15 + 5),
        0);
    currentTouchEvent = TouchEvent(TouchEvent.ACTION_MOVE, offset);

    mPainter!.setCurrentTouchEvent(currentTouchEvent);

    currentTouchEvent = TouchEvent(TouchEvent.ACTION_CANCEL, offset);

    mPainter!.setCurrentTouchEvent(currentTouchEvent);
    canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
  }

  //章节切换
  // chapter

  getChapters() async {
    List<ChapterProto> cps =
        await BookApi().getChapters(book.value.id, chapters.length);
    if (cps.isNotEmpty) {
      chapters.addAll(cps);
      DataBaseProvider.dbProvider.addChapters(cps, book.value.id);
    }
  }

  getReadRecord() async {
    if (Global.profile!.token!.isNotEmpty) {
      book.value.chapterIdx = await BookApi()
          .getReadRecord(Global.profile!.username, book.value.id);
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    saveState();
    super.onClose();
    indexController.dispose();
    animationController?.dispose();

    FlutterStatusbarManager.setFullscreen(false);
    SystemChrome.restoreSystemUIOverlays();
  }

  void toggleShowMenu() {
    showMenu.toggle();
  }

  bool isCanGoNext() {
    if (book.value.chapterIdx! >= (chapters.length - 1)) {
      if (book.value.pageIdx! >= (curPage!.pageOffsets - 1)) {
        return false;
      }
    }
    if (book.value.pageIdx! < (curPage!.pageOffsets - 1)) {
      return true;
    } else {
      return next() != null;
    }
  }

  bool isCanGoPre() {
    if (book.value.chapterIdx! <= 0 && book.value.pageIdx! <= 0) {
      return false;
    }
    if (book.value.pageIdx! > 0) {
      return pre() != null;
    } else {
      return true;
    }
  }

  getPageCacheKey(int? chapterIdx, int? pageIndex) {
    return book.value.id.toString() +
        chapterIdx.toString() +
        pageIndex.toString();
  }

  cur() {
    var key = getPageCacheKey(book.value.chapterIdx, book.value.pageIdx);
    if (homeController!.widgets.containsKey(key)) {
      return homeController!.widgets[key];
    } else {
      Future.delayed(Duration(milliseconds: 200), () => preLoadWidget());
      return homeController!.widgets.putIfAbsent(
          key,
          () => TextComposition.drawContent(
                curPage,
                book.value.pageIdx,
                darkModel.value,
                setting,
                bgImage,
                electricQuantity,
              ));
    }
  }

  next() {
    var i = book.value.pageIdx! + 1;
    var key = getPageCacheKey(book.value.chapterIdx, i);

    if (homeController!.widgets.containsKey(key)) {
      return homeController!.widgets[key];
    } else {
      if (nextPage == null) {
        loadChapter(book.value.chapterIdx! + 1)
            .then((value) => {nextPage = value});
      }
      return homeController!.widgets.putIfAbsent(
          key,
          () => i >= curPage!.pageOffsets
              ? TextComposition.drawContent(
                  nextPage,
                  0,
                  darkModel.value,
                  setting,
                  bgImage,
                  electricQuantity,
                )
              : TextComposition.drawContent(
                  curPage,
                  i,
                  darkModel.value,
                  setting,
                  bgImage,
                  electricQuantity,
                ));
    }
  }

  pre() {
    var i = book.value.pageIdx! - 1;
    var key = getPageCacheKey(book.value.chapterIdx, i);

    if (homeController!.widgets.containsKey(key)) {
      return homeController!.widgets[key];
    } else {
      if (prePage == null) {
        loadChapter(book.value.chapterIdx! - 1)
            .then((value) => prePage = value);
      }
      return homeController!.widgets.putIfAbsent(
          key,
          () => i < 0
              ? TextComposition.drawContent(
                  prePage,
                  prePage!.pageOffsets - 1,
                  darkModel.value,
                  setting,
                  bgImage,
                  electricQuantity,
                )
              : TextComposition.drawContent(
                  curPage,
                  i,
                  darkModel.value,
                  setting,
                  bgImage,
                  electricQuantity,
                ));
    }
  }

  void changeCoverPage(int offsetDifference) {
    int idx = book.value.pageIdx ?? 0;

    int curLen = (curPage?.pageOffsets ?? 0);
    if (idx == curLen - 1 && offsetDifference > 0) {
      Future.delayed(
          Duration(milliseconds: 500),
          () => {
                Battery()
                    .batteryLevel
                    .then((value) => electricQuantity = value / 100)
              });
      int tempCur = book.value.chapterIdx! + 1;
      if (tempCur >= chapters.length) {
        BotToast.showText(text: "已经是第一页");
        return;
      } else {
        book.value.chapterIdx = book.value.chapterIdx! + 1;

        prePage = curPage;
        if ((nextPage?.chapterName ?? "") == "-1") {
          loadChapter(book.value.chapterIdx ?? 0)
              .then((value) => curPage = value);
        } else {
          curPage = nextPage;
        }
        book.value.pageIdx = 0;
        nextPage = null;
        Future.delayed(Duration(milliseconds: 500), () {
          loadStatus.value = LOAD_STATUS.LOADING;
          loadChapter(book.value.chapterIdx! + 1)
              .then((value) => nextPage = value);
          loadStatus.value = LOAD_STATUS.FINISH;
        });

        chapterIdx.value = book.value.chapterIdx!;
        reInitController();

        return;
      }
    }
    if (idx == 0 && offsetDifference < 0) {
      Future.delayed(
          Duration(milliseconds: 500),
          () => {
                Battery()
                    .batteryLevel
                    .then((value) => electricQuantity = value / 100)
              });
      int tempCur = book.value.chapterIdx! - 1;
      if (tempCur < 0) {
        BotToast.showText(text: "第一页");

        return;
      }
      nextPage = curPage;
      curPage = prePage;
      book.value.chapterIdx = book.value.chapterIdx! - 1;

      book.value.pageIdx = curPage!.pageOffsets - 1;
      prePage = null;
      Future.delayed(Duration(milliseconds: 500), () {
        loadChapter(book.value.chapterIdx! - 1)
            .then((value) => prePage = value);
      });

      chapterIdx.value = book.value.chapterIdx!;
      reInitController();

      return;
    }
    offsetDifference > 0
        ? (book.value.pageIdx = book.value.pageIdx! + 1)
        : (book.value.pageIdx = book.value.pageIdx! - 1);
  }

  panDown(DragDownDetails e) {
    showMenu.value = false;
    if (currentTouchEvent.action != TouchEvent.ACTION_DOWN ||
        currentTouchEvent.touchPos != e.localPosition) {
      currentTouchEvent = TouchEvent(TouchEvent.ACTION_DOWN, e.localPosition);
      mPainter!.setCurrentTouchEvent(currentTouchEvent);
      canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
    }
  }

  panUpdate(DragUpdateDetails e) {
    if (!showMenu.value) {
      if (currentTouchEvent.action != TouchEvent.ACTION_MOVE ||
          currentTouchEvent.touchPos != e.localPosition) {
        currentTouchEvent = TouchEvent(TouchEvent.ACTION_MOVE, e.localPosition);
        mPainter!.setCurrentTouchEvent(currentTouchEvent);
        canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
      }
    }
  }

  panEnd(DragEndDetails e) {
    if (!showMenu.value) {
      if (currentTouchEvent.action != TouchEvent.ACTION_UP ||
          currentTouchEvent.touchPos != Offset(0, 0)) {
        currentTouchEvent =
            TouchEvent<DragEndDetails>(TouchEvent.ACTION_UP, Offset(0, 0));
        currentTouchEvent.touchDetail = e;

        mPainter!.setCurrentTouchEvent(currentTouchEvent);
        canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
      }
    }
  }

  preLoadWidget() {
    if (prePage == null) return;
    var preIdx = book.value.pageIdx! - 1;
    var preKey;
    if (preIdx < 0) {
      preKey =
          getPageCacheKey(book.value.chapterIdx! - 1, prePage!.pageOffsets - 1);
    } else {
      preKey = getPageCacheKey(book.value.chapterIdx!, preIdx);
    }
    if (!homeController!.widgets.containsKey(preKey)) {
      if (prePage?.pages == null) return;
      homeController!.widgets.putIfAbsent(preKey, () => pre());
    }

    var nextIdx = book.value.pageIdx! + 1;
    var nextKey;
    if (nextIdx >= curPage!.pageOffsets) {
      nextKey = getPageCacheKey(book.value.chapterIdx! + 1, 0);
    } else {
      nextKey = getPageCacheKey(book.value.chapterIdx!, nextIdx);
    }
    if (!homeController!.widgets.containsKey(nextKey)) {
      if (nextPage?.pages == null) return;
      homeController!.widgets.putIfAbsent(preKey, () => next());
    }
  }

  Future<void> reloadCurrentPage() async {
    try {
      loadStatus.value = LOAD_STATUS.LOADING;
      toggleShowMenu();

      String chapterId = chapters[book.value.chapterIdx!].chapterId;
      //从数据库中取
      var res = await BookApi().getContent(chapterId);

      String chapterContent =
          await ChapterParseUtil().parseContent(res['link']);
      //上传到数据库
      BookApi().updateContent(chapterId, chapterContent);
      await DataBaseProvider.dbProvider
          .updateContent(chapterId, chapterContent);
      curPage = await loadChapter(book.value.chapterIdx!);
      chapters[book.value.chapterIdx!].hasContent = "2";
      homeController!.widgets.removeWhere((key, value) => key
          .startsWith(book.value.id.toString() + chapterIdx.value.toString()));

      // curPage!.chapterContent = chapterContent;
      // curPage!.pages = TextComposition.parseContent(curPage!, setting!);
      loadStatus.value = LOAD_STATUS.FINISH;
      canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
    } catch (e) {
      loadStatus.value = LOAD_STATUS.FINISH;
      BotToast.showText(text: "加载失败");
    }
  }

  Future<void> updPage() async {
    homeController!.widgets.clear();

    var keys = SpUtil.getKeys();
    for (var key in keys!) {
      if (key.startsWith("pages")) {
        SpUtil.remove(key);
      }
    }
    await initContent(book.value.chapterIdx ?? 0, true);
    canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
  }

  colorModelSwitch() {
    idxController!.toggleModel();

    if (darkModel.value) {
      bgImage = homeController!.bgImages![ReadSetting.bgImgs.length - 1];
    } else {
      bgImage = homeController!.bgImages![setting!.bgIndex ?? 0];
    }
    homeController!.widgets.clear();
    canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
  }

  void switchBgColor(int i) {
    setting!.bgIndex = i;
    setting!.persistence();
    if (darkModel.value) {
      bgImage = homeController!.bgImages![ReadSetting.bgImgs.length - 1];
    } else {
      bgImage = homeController!.bgImages![setting!.bgIndex ?? 0];
    }
    homeController!.widgets.clear();
    canvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
  }

  reloadCurChapterWidget() {}

  Future<void> jump(int i) async {
    await Future.delayed(Duration(seconds: 1));

    try {
      loadStatus.value = LOAD_STATUS.LOADING;
      book.value.chapterIdx = i;
      await initContent(i, true);
      loadStatus.value = LOAD_STATUS.FINISH;
    } catch (e) {
      loadStatus.value = LOAD_STATUS.FINISH;
    }
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
    saveState();
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
