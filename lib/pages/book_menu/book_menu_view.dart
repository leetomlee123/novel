import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/pages/read_book/read_book_controller.dart';

class BookMenuPage extends GetView<ReadBookController> {
  BookMenuPage({Key? key}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                // head(),

                // midTransparent(),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[bottomHead(), buildBottomMenus()],
                  // ),
                )
              ],
            ),
            // Offstage(
            //     offstage: controller.type.value != OperateType.SLIDE,
            //     child: Align(
            //       child: reloadCurChapterWidget(),
            //       alignment: Alignment(.9, .5),
            //     ))
          ],
        ),
        onTap: () {
          controller.toggleShowMenu();
        },
      ),
    );
  }

  // buildBottomMenus() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: <Widget>[
  //       buildBottomItem('目录', Icons.menu),
  //       TextButton(
  //           child: Container(
  //             child: Column(
  //               children: <Widget>[
  //                 Icon(
  //                   Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
  //                   // color: Colors.white,
  //                 ),
  //                 SizedBox(height: 5),
  //                 Text(Get.isDarkMode ? '日间' : '夜间',
  //                     style: TextStyle(fontSize: 12)),
  //               ],
  //             ),
  //           ),
  //           onPressed: () {
  //             Get.changeTheme(
  //                 Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
  //             controller.colorModelSwitch();
  //           }),
  //       buildBottomItem('缓存', Icons.cloud_download),
  //       buildBottomItem('设置', Icons.settings),
  //     ],
  //   );
  // }

  // buildBottomItem(String title, IconData iconData) {
  //   return TextButton(
  //     child: Container(
  //       child: Column(
  //         children: <Widget>[
  //           Icon(
  //             iconData,
  //             // color: Colors.white,
  //           ),
  //           SizedBox(height: 5),
  //           Text(title, style: TextStyle(fontSize: 12)),
  //         ],
  //       ),
  //     ),
  //     onPressed: () {
  //       switch (title) {
  //         case '目录':
  //           {
  //             // Routes.navigateTo(context, Routes.chapters,replace: true);
  //             controller.toggleShowMenu();
  //           }
  //           break;
  //         case '缓存':
  //           {
  //             if (controller.type.value == OperateType.DOWNLOAD) {
  //               controller.type.value = OperateType.SLIDE;
  //             } else {
  //               controller.type.value = OperateType.DOWNLOAD;
  //             }
  //           }
  //           break;
  //         case '设置':
  //           {
  //             if (controller.type.value == OperateType.MORE_SETTING) {
  //               controller.type.value = OperateType.SLIDE;
  //             } else {
  //               controller.type.value = OperateType.MORE_SETTING;
  //             }
  //           }
  //           break;
  //       }
  //     },
  //   );
  // }

  // List<Widget> bgThemes() {
  //   List<Widget> wds = [];
  //   wds.add(
  //     Center(
  //       child: Text(
  //         '背景',
  //         style: TextStyle(fontSize: 13.0),
  //       ),
  //     ),
  //   );
  //   for (int i = 0; i < ReadSetting.bgImgs.length - 1; i++) {
  //     // var path = ReadSetting.bgImgs[i];
  //     var f = "images/${ReadSetting.bgImgs[i]}";
  //     wds.add(RawMaterialButton(
  //       onPressed: () async {
  //         if (Get.isDarkMode) {
  //           Get.changeThemeMode(ThemeMode.light);
  //         } else {
  //           Get.changeThemeMode(ThemeMode.dark);
  //         }
  //         controller.switchBgColor(i);
  //       },
  //       constraints: BoxConstraints(minWidth: 60.0, minHeight: 50.0),
  //       child: Container(
  //           margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
  //           width: 45.0,
  //           height: 45.0,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(25.0)),
  //             border: Border.all(
  //               width: 1.5,
  //               color: controller.setting!.bgIndex == i
  //                   ? Get.theme.primaryColor
  //                   : Colors.white10,
  //             ),
  //             image: DecorationImage(
  //               image: AssetImage(f),
  //               fit: BoxFit.cover,
  //             ),
  //           )),
  //     ));
  //   }
  //   wds.add(SizedBox(
  //     height: 8,
  //   ));
  //   return wds;
  // }

  // Widget reloadCurChapterWidget() {
  //   return Container(
  //     width: 50,
  //     height: 50,
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //         color: Colors.grey, borderRadius: BorderRadius.circular(25)),
  //     child: IconButton(
  //       onPressed: () {
  //         controller.reloadCurrentPage();
  //       },
  //       icon: Icon(
  //         Icons.refresh,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  // Widget chapterSlide() {
  //   return Container(
  //       padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
  //       child: Row(
  //         children: <Widget>[
  //           TextButton(
  //               onPressed: () async {
  //                 if ((controller.book!.chapterIdx! - 1) < 0) {
  //                    BotToast.showText(text: '已经是第一章');
  //                   return;
  //                 }
  //                 controller.book!.chapterIdx =
  //                     controller.book!.chapterIdx! - 1;
  //                 await controller.initContent(
  //                     controller.book!.chapterIdx!, true);
  //               },
  //               child: Text('上一章')),
  //           Expanded(
  //             child: Container(
  //               child: Slider(
  //                 value: controller.book!.chapterIdx!.toDouble(),
  //                 max: (controller.chapters.length - 1).toDouble(),
  //                 min: 0.0,
  //                 onChanged: (newValue) {
  //                   int temp = newValue.round();
  //                   controller.book!.chapterIdx = temp;

  //                   controller.initContent(controller.book!.chapterIdx!, true);
  //                 },
  //                 label:
  //                     '${controller.chapters[controller.book!.chapterIdx!].chapterName} ',
  //                 semanticFormatterCallback: (newValue) {
  //                   return '${newValue.round()} dollars';
  //                 },
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //               onPressed: () async {
  //                 if ((controller.book!.chapterIdx! + 1) >=
  //                     controller.chapters.length) {
  //                    BotToast.showText(text: "已经是最后一章");
  //                   return;
  //                 }
  //                 controller.book!.chapterIdx =
  //                     controller.book!.chapterIdx! + 1;
  //                 await controller.initContent(
  //                     controller.book!.chapterIdx!, true);
  //               },
  //               child: Text('下一章')),
  //         ],
  //       ));
  // }

  // Widget downloadWidget() {
  //   Color _color = Get.isDarkMode ? Colors.black : Colors.white;
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: _color,
  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //     ),
  //     height: 70,
  //     child: Column(
  //       children: <Widget>[
  //         Expanded(
  //           child: ListView(
  //             scrollDirection: Axis.horizontal,
  //             children: <Widget>[
  //               Container(
  //                 decoration: BoxDecoration(color: _color),
  //                 height: 40,
  //                 width: (Screen.width - 40) / 2,
  //                 margin: EdgeInsets.only(top: 15, bottom: 15),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                      BotToast.showText(text: '从当前章节开始下载...');

  //                     // controller.downloadAll(_readModel.book.cur);
  //                   },
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //                         border: Border.all(
  //                           width: 1,
  //                           color: _color,
  //                         )),
  //                     alignment: Alignment(0, 0),
  //                     child: Text(
  //                       '从当前章节缓存',
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 20,
  //               ),
  //               Container(
  //                 decoration: BoxDecoration(color: _color),
  //                 height: 40,
  //                 width: (Screen.width - 40) / 2,
  //                 margin: EdgeInsets.only(top: 15, bottom: 15),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                      BotToast.showText(text: '开始全本下载...');

  //                     // _readModel.downloadAll(0);
  //                   },
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.all(Radius.circular(25.0)),
  //                         border: Border.all(
  //                           width: 1,
  //                           color: _color,
  //                         )),
  //                     alignment: Alignment(0, 0),
  //                     child: Text(
  //                       '全本缓存',
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //     padding: EdgeInsets.only(left: 15.0),
  //   );
  // }

  // Widget moreSetting() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       // color: _colorModel.dark ? Colors.black : Colors.white,
  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //     ),
  //     height: controller.settingH,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         // MenuConfig(
  //         //       () {
  //         //     ReadSetting.calcFontSize(-1);
  //         //     _readModel.updPage();
  //         //   },
  //         //       () {
  //         //     ReadSetting.calcFontSize(1);
  //         //     _readModel.updPage();
  //         //   },
  //         //       (v) {
  //         //     ReadSetting.setFontSize(v);
  //         //     _readModel.updPage();
  //         //   },
  //         //   ReadSetting.getFontSize(),
  //         //   "字号",
  //         //   min: 10,
  //         //   max: 60,
  //         // ),
  //         Row(
  //           children: [
  //             Text("行距", style: TextStyle(fontSize: 13.0)),
  //             IconButton(
  //               onPressed: () {
  //                 // ReadSetting.subLineHeight();
  //                 controller.setting!.latterHeight =
  //                     controller.setting!.latterHeight! - .1;
  //                 controller.setting!.persistence();
  //                 controller.updPage();
  //               },
  //               icon: Icon(Icons.remove),
  //             ),
  //             Expanded(
  //               child: Container(
  //                 height: 12,
  //                 child: SliderTheme(
  //                   data: Get.theme.sliderTheme.copyWith(
  //                     trackHeight: 1,
  //                     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
  //                     overlayShape: SliderComponentShape.noOverlay,
  //                   ),
  //                   child: Slider(
  //                     value: controller.setting!.latterHeight ?? .0,
  //                     onChanged: (v) {
  //                       controller.setting!.latterHeight = v;
  //                       controller.setting!.persistence();
  //                       controller.updPage();
  //                     },
  //                     min: .1,
  //                     max: 4.0,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 controller.setting!.latterHeight =
  //                     controller.setting!.latterHeight! + .1;
  //                 controller.setting!.persistence();
  //                 controller.updPage();
  //               },
  //               icon: Icon(Icons.add),
  //             ),
  //             // Text('${ReadSetting.getLineHeight().toStringAsFixed(1)}')
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Text("段距", style: TextStyle(fontSize: 13.0)),
  //             IconButton(
  //               onPressed: () {
  //                 controller.setting!.paragraphHeight =
  //                     controller.setting!.paragraphHeight! - .1;
  //                 controller.setting!.persistence();
  //                 controller.updPage();
  //               },
  //               icon: Icon(Icons.remove),
  //             ),
  //             Expanded(
  //               child: Container(
  //                 height: 12,
  //                 child: SliderTheme(
  //                   data: Get.theme.sliderTheme.copyWith(
  //                     trackHeight: 1,
  //                     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
  //                     overlayShape: SliderComponentShape.noOverlay,
  //                   ),
  //                   child: Slider(
  //                     value: controller.setting!.paragraphHeight ?? .0,
  //                     onChanged: (v) {
  //                       controller.setting!.paragraphHeight = v;
  //                       controller.setting!.persistence();
  //                       controller.updPage();
  //                     },
  //                     min: .1,
  //                     max: 2.0,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 controller.setting!.paragraphHeight =
  //                     controller.setting!.paragraphHeight! + .1;
  //                 controller.setting!.persistence();
  //                 controller.updPage();
  //               },
  //               icon: Icon(Icons.add),
  //             ),
  //             // Text('${ReadSetting.getParagraph().toStringAsFixed(1)}')
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Text("页距", style: TextStyle(fontSize: 13.0)),
  //             IconButton(
  //               onPressed: () {
  //                 controller.setting!.pageSpace =
  //                     controller.setting!.pageSpace! - 1;
  //                 controller.setting!.persistence();
  //                 controller.updPage();
  //               },
  //               icon: Icon(Icons.remove),
  //             ),
  //             Expanded(
  //               child: Container(
  //                 height: 12,
  //                 child: SliderTheme(
  //                   data: Get.theme.sliderTheme.copyWith(
  //                     trackHeight: 1,
  //                     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
  //                     overlayShape: SliderComponentShape.noOverlay,
  //                   ),
  //                   child: Slider(
  //                     value: controller.setting!.pageSpace ?? 0,
  //                     onChanged: (v) {
  //                       controller.setting!.pageSpace = v;
  //                       controller.setting!.persistence();
  //                       controller.updPage();
  //                     },
  //                     min: 0,
  //                     max: 50,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 controller.setting!.pageSpace =
  //                     controller.setting!.pageSpace! + 1;
  //                 controller.setting!.persistence();
  //                 controller.updPage();
  //               },
  //               icon: Icon(Icons.add),
  //             ),
  //             // Text('${ReadSetting.getPageDis()}')
  //           ],
  //         ),
  //         Expanded(
  //             child: ListView(
  //           children: bgThemes(),
  //           scrollDirection: Axis.horizontal,
  //         )),
  //         // Expanded(
  //         //   child: flipType(),
  //         // ),
  //         Row(
  //           children: [
  //             Expanded(
  //               flex: 2,
  //               child: OutlinedButton(
  //                   style: OutlinedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(18.0),
  //                     ),
  //                     side: BorderSide(
  //                       width: 2,
  //                       color: Get.isDarkMode
  //                           ? Colors.white
  //                           : Get.theme.primaryColor,
  //                     ),
  //                   ),
  //                   onPressed: () {
  //                     // Routes.navigateTo(context, Routes.fontSet);
  //                   },
  //                   child: Text('字体')),
  //             ),
  //             Expanded(child: Container(), flex: 2),
  //             Expanded(
  //               flex: 3,
  //               child: SwitchListTile(
  //                 contentPadding: EdgeInsets.only(left: 15),
  //                 value: controller.setting!.leftClickNext ?? false,
  //                 onChanged: (value) {
  //                   controller.setting!.leftClickNext =
  //                       !(controller.setting!.leftClickNext ?? false);
  //                 },
  //                 title: Text(
  //                   '单手模式',
  //                   style: TextStyle(
  //                       fontSize: 13,
  //                       color: Get.isDarkMode ? Colors.white : Colors.black),
  //                 ),
  //                 selected: controller.setting!.leftClickNext ?? false,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //     padding: EdgeInsets.all(15),
  //   );
  // }

  // // Widget flipType() {
  // //   return Row(
  // //     children: <Widget>[
  // //       Container(
  // //         child: Center(
  // //           child: Text('翻页动画', style: TextStyle(fontSize: 13.0)),
  // //         ),
  // //         height: 40,
  // //         width: 40,
  // //       ),
  // //       SizedBox(
  // //         width: 10,
  // //       ),
  // //       TextButton(
  // //           style: ButtonStyle(
  // //             side: MaterialStateProperty.all(BorderSide(
  // //                 color: !SpUtil.getBool(Common.turnPageAnima)
  // //                     ? _colorModel.dark
  // //                     ? Colors.white
  // //                     : Theme.of(context).primaryColor
  // //                     : Colors.white10,
  // //                 width: 1)),
  // //           ),
  // //           onPressed: () {
  // //             if (mounted) {
  // //               setState(() {
  // //                 SpUtil.putBool(Common.turnPageAnima, false);
  // //                 eventBus.fire(ZEvent(200));
  // //               });
  // //             }
  // //           },
  // //           child: Text('无')),
  // //       SizedBox(
  // //         width: 10,
  // //       ),
  // //       TextButton(
  // //           style: ButtonStyle(
  // //             side: MaterialStateProperty.all(BorderSide(
  // //                 color: SpUtil.getBool(Common.turnPageAnima)
  // //                     ? Get.isDarkMode
  // //                     ? Colors.white
  // //                     : Get.theme.primaryColor
  // //                     : Colors.white10,
  // //                 width: 1)),
  // //           ),
  // //           onPressed: () {
  // //             if (mounted) {
  // //               setState(() {
  // //                 SpUtil.putBool(Common.turnPageAnima, true);
  // //                 eventBus.fire(ZEvent(200));
  // //               });
  // //             }
  // //           },
  // //           child: Text('覆盖')),
  // //     ],
  // //   );
  // // }

  // Widget bottomHead() {
  //   switch (controller.type.value) {
  //     case OperateType.MORE_SETTING:
  //       return moreSetting();
  //       break;
  //     case OperateType.DOWNLOAD:
  //       return downloadWidget();
  //       break;
  //     default:
  //       return chapterSlide();
  //   }
  // }

  // Widget midTransparent() {
  //   return Expanded(
  //     child: GestureDetector(
  //       behavior: HitTestBehavior.opaque,
  //       child: Container(
  //         color: Colors.transparent,
  //       ),
  //       onTap: () {
  //         controller.type.value = OperateType.SLIDE;
  //         Get.back();
  //         // controller.toggleShowMenu();
  //       },
  //     ),
  //   );
  // }

//   _buildDrawer() {}
// }
}
