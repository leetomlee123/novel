import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/app_menu/app_menu_view.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/router/app_pages.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () async {
            if (controller.manageShelf.value) {
              controller.manageShelf.value = !controller.manageShelf.value;
              return false;
            }
            return false;
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: controller.manageShelf.value
                ? AppBar(
                    leadingWidth: 70,
                    leading: TextButton(
                      onPressed: () => controller.pickAction(),
                      child: Text(
                        controller.pickAll.value ? "全不选" : "全选",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    centerTitle: true,
                    title: Column(
                      children: [
                        Text("书架整理"),
                        Text(
                          "已选择${controller.pickList.length}本",
                          style: TextStyle(fontSize: 11),
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => controller.manage(),
                          child: Text(
                            "完成",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )
                : AppBar(
                    actions: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          Get.toNamed(AppRoutes.SearchBook);
                        },
                      ),
                      _popupMenuButton(context)
                    ],
                    centerTitle: true,
                    title: Text("书架"),
                    leading: IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () =>
                            scaffoldKey.currentState!.openDrawer()),
                  ),
            drawer: Drawer(
              child: AppMenuPage(),
            ),
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: controller.shelf.isNotEmpty
                    ? controller.coverLayout.value
                        ? _buildListModel()
                        : _buildCoverModel()
                    : Container()),
            bottomNavigationBar:
                controller.manageShelf.value ? _buildManageAction() : null,
          ),
        ));
  }

  Widget _buildManageAction() {
    return Padding(
      padding: EdgeInsets.only(bottom: Screen.bottomSafeHeight),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () => controller.deleteBooks(),
              child: Text(
                "删除",
                style: TextStyle(
                    color: controller.pickList.isNotEmpty
                        ? Colors.redAccent
                        : Colors.grey),
              ))
        ],
      ),
    );
  }

  PopupMenuButton _popupMenuButton(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert_sharp),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
              value: "1",
              child: Obx(
                () => Text(controller.coverLayout.value ? "封面模式" : "列表模式"),
              )),
          PopupMenuItem(
            child: Text("书架整理"),
            value: "书架整理",
          ),
        ];
      },
      onSelected: (var value) => controller.menuAction(value),
    );
  }

  Widget _buildCoverModel() {
    return WaterfallFlow.builder(
        itemCount: controller.shelf.length,
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 50.0,
          mainAxisSpacing: 30.0,
        ),
        itemBuilder: (itemBuilder, i) {
          var data = controller.shelf[i];
          return tapAction(
              Column(
                children: [
                  _buildBookCover(data, i),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      data.name ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              i);
        });
  }

  Widget _buildBookCover(Book book, int i) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        CommonImg(
          book.img ?? "",
          aspect: .73,
          fit: BoxFit.fitWidth,
        ),
        Offstage(
          offstage: book.newChapter == 0,
          child: Container(
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'images/h6.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
        Visibility(
          visible: controller.manageShelf.value,
          child: Icon(
            controller.pickList.contains(i)
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 30.0,
          ),
        ),
      ],
    );
  }

  Widget _buildListModel() {
    return ListView.builder(
      itemBuilder: (c, i) {
        Book book = controller.shelf[i];
        return tapAction(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  _buildBookCover(book, i),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        book.name ?? "",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Text(
                        book.author ?? "",
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        book.lastChapter ?? "",
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        book.uTime ?? "",
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                        maxLines: 1,
                      ),
                    ],
                  ))
                ],
              ),
            ),
            i);
      },
      itemCount: controller.shelf.length,
      itemExtent: 130,
    );
  }

  Widget tapAction(Widget child, int i) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        controller.manageShelf.value = true;
      },
      child: child,
      onTap: () => controller.tapAction(i),
    );
  }
}
