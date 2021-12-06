import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/components/loading.dart';
import 'package:novel/pages/book_chapters/chapter.pbserver.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/utils/database_provider.dart';

import 'read_book_controller.dart';

class ReadBookPage extends GetView<ReadBookController> {
  ReadBookPage({Key? key}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: _buildChapters(),
          ),
          body: controller.loadStatus.value == LOAD_STATUS.FINISH
              ? _buildContent()
              : controller.loadStatus.value == LOAD_STATUS.FAILED
                  ? Center(child: Text("something is wrong,please try again"))
                  : LoadingDialog(),
        ));
  }

  //拦截菜单和章节view
  bool popWithMenuAndChapterView() {
    if (controller.showMenu.value || scaffoldKey.currentState!.isDrawerOpen) {
      if (controller.showMenu.value) {
        controller.showMenu.value = false;
      }
      if (scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openEndDrawer();
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
      child: _buildPage(),
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Offstage(
            child: _buildMenu(),
            offstage: !controller.showMenu.value,
          ),
        ),
      ],
    );
  }

  confirmAddToShelf() async {
    await Get.dialog(AlertDialog(
      title: Text("提示"),
      content: Text('是否加入本书'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Get.back();
              controller.homeController!.modifyShelf(controller.book.value);
            },
            child: Text('确定')),
        TextButton(
            onPressed: () async {
              controller.saveReadState.value = false;

              DataBaseProvider.dbProvider
                  .clearChapter(controller.book.value.id ?? "");
              Get.back();
            },
            child: Text('取消')),
      ],
    ));
  }

  _buildMenu() {
    return Container(
      color: Colors.transparent,
      child: GestureDetector(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                // head(),

                midTransparent(),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: controller.darkModel.value
                          ? Colors.black
                          : Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[bottomHead(), buildBottomMenus()],
                  ),
                )
              ],
            ),
            Offstage(
                offstage: controller.type.value != OperateType.SLIDE,
                child: Align(
                  child: reloadCurChapterWidget(),
                  alignment: Alignment(.9, .5),
                ))
          ],
        ),
        onTap: () {
          controller.toggleShowMenu();
        },
      ),
      width: Screen.width,
      height: Screen.height,
    );
  }

  buildBottomMenus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildBottomItem('目录', Icons.menu),
        TextButton(
            child: Container(
              child: Column(
                children: <Widget>[
                  Icon(
                    controller.darkModel.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    // color: Colors.white,
                  ),
                  SizedBox(height: 5),
                  Text(controller.darkModel.value ? '日间' : '夜间',
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            onPressed: () {
              Get.changeTheme(controller.darkModel.value
                  ? ThemeData.light()
                  : ThemeData.dark());
              controller.darkModel.value = !controller.darkModel.value;
              controller.colorModelSwitch();
            }),
        buildBottomItem('缓存', Icons.cloud_download),
        buildBottomItem('设置', Icons.settings),
      ],
    );
  }

  buildBottomItem(String title, IconData iconData) {
    return TextButton(
      child: Container(
        child: Column(
          children: <Widget>[
            Icon(
              iconData,
              // color: Colors.white,
            ),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      onPressed: () {
        switch (title) {
          case '目录':
            {
              scaffoldKey.currentState!.openDrawer();
              controller.toggleShowMenu();
            }
            break;
          case '缓存':
            {
              if (controller.type.value == OperateType.DOWNLOAD) {
                controller.type.value = OperateType.SLIDE;
              } else {
                controller.type.value = OperateType.DOWNLOAD;
              }
            }
            break;
          case '设置':
            {
              if (controller.type.value == OperateType.MORE_SETTING) {
                controller.type.value = OperateType.SLIDE;
              } else {
                controller.type.value = OperateType.MORE_SETTING;
              }
            }
            break;
        }
      },
    );
  }

  Widget reloadCurChapterWidget() {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(25)),
      child: IconButton(
        onPressed: () {
          controller.reloadCurrentPage();
        },
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget chapterSlide() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Row(
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  if ((controller.book.value.chapterIdx! - 1) < 0) {
                    Get.snackbar("", '已经是第一章');
                    return;
                  }
                  controller.book.value.chapterIdx =
                      controller.book.value.chapterIdx! - 1;
                  await controller.initContent(
                      controller.book.value.chapterIdx!, true);
                },
                child: Text('上一章')),
            Expanded(
              child: Slider(
                value: controller.chapterIdx.value.toDouble(),
                max: (controller.chapters.length - 1).toDouble(),
                min: 0.0,
                onChanged: (newValue) {
                  int temp = newValue.round();
                  controller.book.value.chapterIdx = temp;
                  controller.chapterIdx.value = temp;
                },
                onChangeEnd: (_) {
                  controller.initContent(
                      controller.book.value.chapterIdx!, true);
                },
              ),
            ),
            TextButton(
                onPressed: () async {
                  if ((controller.book.value.chapterIdx! + 1) >=
                      controller.chapters.length) {
                    Get.snackbar("", "已经是最后一章");
                    return;
                  }
                  controller.book.value.chapterIdx =
                      controller.book.value.chapterIdx! + 1;
                  await controller.initContent(
                      controller.book.value.chapterIdx!, true);
                },
                child: Text('下一章')),
          ],
        ));
  }

  Widget downloadWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 70,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  width: (Screen.width - 40) / 2.5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      controller.dowload(controller.book.value.chapterIdx ?? 0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(
                            color: controller.darkModel.value
                                ? Colors.white
                                : Get.theme.primaryColor,
                            width: 1,
                          )),
                      alignment: Alignment(0, 0),
                      child: Text(
                        '从当前章节缓存',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 40,
                  width: (Screen.width - 40) / 2.5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      controller.dowload(controller.book.value.chapterIdx ?? 0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          border: Border.all(
                            color: controller.darkModel.value
                                ? Colors.white
                                : Get.theme.primaryColor,
                            width: 1,
                          )),
                      alignment: Alignment(0, 0),
                      child: Text(
                        '全本缓存',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 15.0),
    );
  }

  Widget moreSetting() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          height: controller.settingH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text("字号", style: TextStyle(fontSize: 13.0)),
                  IconButton(
                    onPressed: () {
                      if (controller.setting!.fontSize! <= 11) {
                        return;
                      }
                      controller.setting!.fontSize =
                          controller.setting!.fontSize! - 1;
                      controller.fontSize.value = controller.setting!.fontSize!;
                      controller.setting!.persistence();
                      controller.updPage();
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Container(
                      height: 12,
                      child: SliderTheme(
                        data: Get.theme.sliderTheme.copyWith(
                          trackHeight: 1,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: controller.fontSize.value,
                          onChanged: (v) {
                            controller.setting!.fontSize = v;
                            controller.fontSize.value = v;
                            controller.setting!.persistence();
                          },
                          onChangeEnd: (_) {
                            controller.updPage();
                          },
                          min: 10,
                          max: 30,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.setting!.fontSize! >= 29) {
                        return;
                      }
                      controller.setting!.fontSize =
                          controller.setting!.fontSize! + 1;
                      controller.fontSize.value = controller.setting!.fontSize!;
                      controller.setting!.persistence();
                      controller.updPage();
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),

              Row(
                children: [
                  Text("行距", style: TextStyle(fontSize: 13.0)),
                  IconButton(
                    onPressed: () {
                      if (controller.setting!.latterHeight! <= 1.1) {
                        return;
                      }
                      controller.setting!.latterHeight =
                          controller.setting!.latterHeight! - .1;
                      controller.latterHeight.value =
                          controller.setting!.latterHeight!;
                      controller.setting!.persistence();
                      controller.updPage();
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Container(
                      height: 12,
                      child: SliderTheme(
                        data: Get.theme.sliderTheme.copyWith(
                          trackHeight: 1,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          divisions: 20,
                          value: controller.latterHeight.value,
                          onChanged: (v) {
                            controller.setting!.latterHeight = v;
                            controller.latterHeight.value = v;
                            controller.setting!.persistence();
                          },
                          onChangeEnd: (_) {
                            controller.updPage();
                          },
                          min: 1,
                          max: 2.0,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.setting!.latterHeight! >= 1.9) {
                        return;
                      }
                      controller.setting!.latterHeight =
                          controller.setting!.latterHeight! + .1;
                      controller.latterHeight.value =
                          controller.setting!.latterHeight!;
                      controller.setting!.persistence();
                      controller.updPage();
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("段距", style: TextStyle(fontSize: 13.0)),
                  IconButton(
                    onPressed: () {
                      if (controller.setting!.paragraphHeight! <= .1) {
                        return;
                      }
                      controller.setting!.paragraphHeight =
                          controller.setting!.paragraphHeight! - .1;
                      controller.paragraphHeight.value =
                          controller.setting!.paragraphHeight!;
                      controller.setting!.persistence();
                      controller.updPage();
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Container(
                      height: 12,
                      child: SliderTheme(
                        data: Get.theme.sliderTheme.copyWith(
                          trackHeight: 1,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          divisions: 20,
                          value: controller.paragraphHeight.value,
                          onChanged: (v) {
                            controller.setting!.paragraphHeight = v;
                            controller.setting!.persistence();
                          },
                          onChangeEnd: (_) {
                            controller.updPage();
                          },
                          min: 0,
                          max: 2.0,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.setting!.paragraphHeight! >= 1.9) {
                        return;
                      }
                      controller.setting!.paragraphHeight =
                          controller.setting!.paragraphHeight! + .1;
                      controller.paragraphHeight.value =
                          controller.setting!.paragraphHeight!;
                      controller.setting!.persistence();
                      controller.updPage();
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("页距", style: TextStyle(fontSize: 13.0)),
                  IconButton(
                    onPressed: () {
                      if (controller.setting!.pageSpace! <= 1) {
                        return;
                      }
                      controller.setting!.pageSpace =
                          controller.setting!.pageSpace! - 1;
                      controller.pageSpace.value =
                          controller.setting!.pageSpace!;
                      controller.setting!.persistence();
                      controller.updPage();
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Container(
                      height: 12,
                      child: SliderTheme(
                        data: Get.theme.sliderTheme.copyWith(
                          trackHeight: 1,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          divisions: 40,
                          value: controller.pageSpace.value,
                          onChanged: (v) {
                            controller.setting!.pageSpace = v;
                            controller.pageSpace.value = v;
                            controller.setting!.persistence();
                          },
                          onChangeEnd: (_) {
                            controller.updPage();
                          },
                          min: 0,
                          max: 40,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.setting!.pageSpace! >= 39) {
                        return;
                      }
                      controller.setting!.pageSpace =
                          controller.setting!.pageSpace! + 1;
                      controller.pageSpace.value =
                          controller.setting!.pageSpace!;
                      controller.setting!.persistence();
                      controller.updPage();
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              Expanded(
                  child: ListView(
                children: bgThemes(),
                scrollDirection: Axis.horizontal,
              )),
              // Expanded(
              //   child: flipType(),
              // ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(
                            width: 2,
                            color: controller.darkModel.value
                                ? Colors.white
                                : Get.theme.primaryColor,
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(AppRoutes.FontSet);
                        },
                        child: Text('字体')),
                  ),
                  Expanded(child: Container(), flex: 2),
                  Expanded(
                    flex: 3,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.only(left: 15),
                      value: controller.leftClickNext.value,
                      onChanged: (value) {
                        controller.leftClickNext.value = value;
                        controller.setting!.leftClickNext = value;
                        controller.setting!.persistence();
                      },
                      title: Text(
                        '单手模式',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      selected: controller.leftClickNext.value,
                    ),
                  ),
                ],
              ),
            ],
          ),
          padding: EdgeInsets.all(15),
        ));
  }

  List<Widget> bgThemes() {
    List<Widget> wds = [];
    wds.add(
      Center(
        child: Text(
          '背景',
          style: TextStyle(fontSize: 13.0),
        ),
      ),
    );
    for (int i = 0; i < ReadSetting.bgImgs.length - 1; i++) {
      var f = "images/${ReadSetting.bgImgs[i]}";
      wds.add(RawMaterialButton(
        onPressed: () async {
          if (controller.darkModel.value) {
            Get.changeTheme(ThemeData.light());
            Get.changeThemeMode(ThemeMode.light);
            controller.darkModel.value = false;
          }
          controller.switchBgColor(i);
        },
        constraints: BoxConstraints(minWidth: 60.0, minHeight: 50.0),
        child: Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            width: 45.0,
            height: 45.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              border: Border.all(
                width: 1.5,
                color: controller.setting!.bgIndex == i
                    ? Get.theme.primaryColor
                    : Colors.white10,
              ),
              image: DecorationImage(
                image: AssetImage(f),
                fit: BoxFit.cover,
              ),
            )),
      ));
    }
    wds.add(SizedBox(
      height: 8,
    ));
    return wds;
  }

  Widget bottomHead() {
    switch (controller.type.value) {
      case OperateType.MORE_SETTING:
        return moreSetting();
      case OperateType.DOWNLOAD:
        return downloadWidget();
      default:
        return chapterSlide();
    }
  }

  Widget midTransparent() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
        ),
        onTap: () {
          controller.type.value = OperateType.SLIDE;
          controller.toggleShowMenu();
        },
      ),
    );
  }

  _buildChapters() {
    controller.reInitController();
    return Column(
      children: [
        _buildChaptersHead(),
        SizedBox(
          height: 5,
        ),
        Divider(
          indent: 10,
          thickness: 1,
          endIndent: 10,
          height: 10,
        ),

        Expanded(
          child: IndexedListView.builder(
            itemExtent: controller.itemExtent,
            maxItemCount: controller.chapters.length,
            addAutomaticKeepAlives: true,
            minItemCount: 0,
            itemBuilder: (c, i) {
              ChapterProto chapter = controller.chapters[i];
              return ListTile(
                title: Text(
                  chapter.chapterName,
                  maxLines: 2,
                  style: TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  chapter.hasContent == "2" ? "已缓存" : "",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                selected: i == controller.book.value.chapterIdx,
                onTap: () async {
                  Get.back();
                  await controller.jump(i);
                },
              );
            },
            controller: controller.indexController,
          ),
        )
        // _buildListView()
      ],
    );
  }

  _buildChaptersHead() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
            left: 10, top: Screen.topSafeHeight + 10, right: 20),
        height: 140,
        width: Screen.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            CommonImg(
              controller.book.value.img ?? "",
              width: 65,
            ),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.book.value.name ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    controller.book.value.author ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '共${controller.chapters.length}章',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_sharp,
            )
          ],
        ),
      ),
      onTap: () async {
        Get.offNamed(AppRoutes.BookDetail,
            arguments: {"bookId": controller.book.value.id ?? ""});
      },
    );
  }

  // Widget flipType() {
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         child: Center(
  //           child: Text('翻页动画', style: TextStyle(fontSize: 13.0)),
  //         ),
  //         height: 40,
  //         width: 40,
  //       ),
  //       SizedBox(
  //         width: 10,
  //       ),
  //       TextButton(
  //           style: ButtonStyle(
  //             side: MaterialStateProperty.all(BorderSide(
  //                 color: !SpUtil.getBool(Common.turnPageAnima)
  //                     ? _colorModel.dark
  //                     ? Colors.white
  //                     : Theme.of(context).primaryColor
  //                     : Colors.white10,
  //                 width: 1)),
  //           ),
  //           onPressed: () {
  //             if (mounted) {
  //               setState(() {
  //                 SpUtil.putBool(Common.turnPageAnima, false);
  //                 eventBus.fire(ZEvent(200));
  //               });
  //             }
  //           },
  //           child: Text('无')),
  //       SizedBox(
  //         width: 10,
  //       ),
  //       TextButton(
  //           style: ButtonStyle(
  //             side: MaterialStateProperty.all(BorderSide(
  //                 color: SpUtil.getBool(Common.turnPageAnima)
  //                     ? Get.isDarkMode
  //                     ? Colors.white
  //                     : Get.theme.primaryColor
  //                     : Colors.white10,
  //                 width: 1)),
  //           ),
  //           onPressed: () {
  //             if (mounted) {
  //               setState(() {
  //                 SpUtil.putBool(Common.turnPageAnima, true);
  //                 eventBus.fire(ZEvent(200));
  //               });
  //             }
  //           },
  //           child: Text('覆盖')),
  //     ],
  //   );
  // }
}
