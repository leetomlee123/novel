import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/components/loading.dart';
import 'package:novel/pages/book_menu/book_menu_view.dart';
import 'package:novel/pages/read_book/PageContentRender.dart';
import 'package:novel/pages/read_book/ReaderPageManager.dart';

import 'read_book_controller.dart';

class ReadBookPage extends GetView<ReadBookController> {
  ReadBookPage({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loadStatus.value == LOAD_STATUS.FINISH
        ? _buildContent()
        : controller.loadStatus.value == LOAD_STATUS.FAILED
            ? Center(child: Text("something is wrong,please try again"))
            : LoadingDialog());
  }

  //拦截菜单和章节view
  bool popWithMenuAndChapterView() {
    if (controller.showMenu.value || _scaffoldKey.currentState!.isDrawerOpen) {
      if (controller.showMenu.value) {
        controller.showMenu.value = false;
      }
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openEndDrawer();
      }
      return false;
    }
    return true;
  }

  _buildContent() {
    return WillPopScope(
      onWillPop: () async {
        var popWithMenuAndChapterView2 = popWithMenuAndChapterView();
        if (!popWithMenuAndChapterView2) {
          return false;
        }
        if (!controller.inShelf.value) {
          await confirmAddToShelf();
        }
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          child: BookMenuPage(),
        ),
        body: _buildPage(),
        key: _scaffoldKey,
      ),
    );
  }

  _buildPage() {
    return Stack(
      children: [
        GestureDetector(
          child: RepaintBoundary(
              child: CustomPaint(
            key: controller.canvasKey,
            isComplex: true,
            size: Size(Screen.width, Screen.height),
            painter: controller.mPainter,
          )),
          onTapUp: (e) => controller.tapPage(e),
          onPanDown: (e) => controller.panDown(e),
          onPanUpdate: (e) => controller.panUpdate(e),
          onPanEnd: (e) => controller.panEnd(e),
        ),
        Offstage(
          child: BookMenuPage(),
          offstage: !controller.showMenu.value,
        ),
      ],
    );
  }

  _buildPageReader() {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        NovelPagePanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<NovelPagePanGestureRecognizer>(
          () => NovelPagePanGestureRecognizer(false),
          (NovelPagePanGestureRecognizer instance) {
            instance.setMenuOpen(false);

            instance
              ..onDown = (detail) {
                if (controller.currentTouchEvent.action !=
                        TouchEvent.ACTION_DOWN ||
                    controller.currentTouchEvent.touchPos !=
                        detail.localPosition) {
                  controller.currentTouchEvent =
                      TouchEvent(TouchEvent.ACTION_DOWN, detail.localPosition);
                  controller.mPainter!
                      .setCurrentTouchEvent(controller.currentTouchEvent);
                  controller.canvasKey.currentContext!
                      .findRenderObject()!
                      .markNeedsPaint();
                }
              };
            instance
              ..onUpdate = (detail) {
                if (!controller.showMenu.value) {
                  if (controller.currentTouchEvent.action !=
                          TouchEvent.ACTION_MOVE ||
                      controller.currentTouchEvent.touchPos !=
                          detail.localPosition) {
                    controller.currentTouchEvent = TouchEvent(
                        TouchEvent.ACTION_MOVE, detail.localPosition);
                    controller.mPainter!
                        .setCurrentTouchEvent(controller.currentTouchEvent);
                    controller.canvasKey.currentContext!
                        .findRenderObject()!
                        .markNeedsPaint();
                  }
                }
              };
            instance
              ..onEnd = (detail) {
                if (!controller.showMenu.value) {
                  if (controller.currentTouchEvent.action !=
                          TouchEvent.ACTION_UP ||
                      controller.currentTouchEvent.touchPos != Offset(0, 0)) {
                    controller.currentTouchEvent = TouchEvent<DragEndDetails>(
                        TouchEvent.ACTION_UP, Offset(0, 0));
                    controller.currentTouchEvent.touchDetail = detail;

                    controller.mPainter!
                        .setCurrentTouchEvent(controller.currentTouchEvent);
                    controller.canvasKey.currentContext!
                        .findRenderObject()!
                        .markNeedsPaint();
                  }
                }
              };
          },
        ),
      },
      child: CustomPaint(
        key: controller.canvasKey,
        isComplex: true,
        size: Size(Screen.width, Screen.height),
        painter: controller.mPainter,
      ),
    );
  }

  confirmAddToShelf() {
    Get.dialog(AlertDialog(
      title: Text("提示"),
      content: Text('是否加入本书'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Get.back();

              // Store.value<ShelfModel>(context)
              //     .modifyShelf(this.widget.book);
            },
            child: Text('确定')),
        TextButton(
            onPressed: () async {
              controller.saveReadState.value = false;

              // await Store.value<ShelfModel>(context)
              //     .delLocalCache([this.widget.book.Id]);
              Get.back();
            },
            child: Text('取消')),
      ],
    ));
  }
}
