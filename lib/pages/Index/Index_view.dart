import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/pages/Index/NavigationIconView.dart';

class IndexPage extends GetView<IndexController> {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () {
            Get.log("index page can`t pop");
            return Future.value(false);
          },
          child: Scaffold(
            body: controller.pageList![controller.index.value],
            bottomNavigationBar:
                controller.showBottom.value ? _buildnavigationBar() : null,
          ),
        ));
  }

  _buildnavigationBar() {
    return BottomNavigationBar(
      items: controller.navigationViews!
          .map((NavigationIconView navigationIconView) =>
              navigationIconView.item)
          .toList(), // 添加 icon 按钮
      currentIndex: controller.index.value, // 当前点击的索引值
      type: BottomNavigationBarType.fixed, // 设置底部导航工具栏的类型：fixed 固定
      onTap: (int index) {
        // 添加点击事件
        controller.index.value = index;
      },
    );
  }
}
