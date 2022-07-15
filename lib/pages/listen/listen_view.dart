import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/listen/adjust_speed.dart';
import 'package:novel/pages/listen/listen_chapters.dart';
import 'package:novel/pages/listen/voice_slider.dart';
import 'package:novel/router/app_pages.dart';

import 'listen_controller.dart';

class ListenPage extends GetView<ListenController> {
  ListenPage({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  //监听程序进入前后台的状态改变的方法

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // drawer: Drawer(
      //   child: SideView(),
      // ),
      // backgroundColor: controller.bgColor.value,
      // appBar: _buildAppBar(),
      // body: _buildPlayUi()
      resizeToAvoidBottomInset: true,
      body: Obx(() => Container(
            decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   // colors: [
                //   //   controller.color1,
                //   //
                //   // ],
                // ),
                ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [_buildAppBar(), _buildPlayUi()]),
          )),
    );
  }

  _buildAppBar() {
    return PreferredSize(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // const SizedBox(
          //   width: 1,
          // ),
          const SizedBox(
            height: 120,
          ),
          IconButton(
            onPressed: () {
              // scaffoldKey.currentState!.openDrawer();
              Get.toNamed(AppRoutes.QR);
            },
            icon: Icon(Icons.qr_code_scanner_outlined),
          ),
          const SizedBox(
            width: 5,
          ),
          Obx(() => Offstage(
                offstage: !controller.getLink.value,
                child: SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    strokeWidth: 2.0,
                    color: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              )),
          Spacer(),
          Row(
            children: [
              const Text(
                '听书楼',
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(7.0, 9, 0, 0),
                child: Obx(() => Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                          color: controller.online.value
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    )),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.search);
            },
            icon: Icon(Icons.search_outlined),
          )
        ]),
        preferredSize: Size.fromHeight(kToolbarHeight));
  }

  Widget _buildPlayUi() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            CommonImg(
              controller.model.value.cover ?? "",
              width: 100,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("第${controller.idx.value + 1}集"),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(controller.model.value.bookMeta ?? ""),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Icon(
                          Icons.menu_open_outlined,
                          size: 32,
                        ),
                        Text("播放列表"),
                      ],
                    ),
                    onTap: () {
                      if (controller.model.value.count! > 0) {
                        Get.bottomSheet(ListenChapters(),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            backgroundColor: controller.color1);
                      }
                    },
                  ),
                  GestureDetector(
                    child: Column(
                      children: [
                        Icon(
                          Icons.fast_forward,
                          size: 32,
                        ),
                        Text("倍速"),
                      ],
                    ),
                    onTap: () {
                      Get.bottomSheet(ListenAdjustSpeed(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          elevation: 2,
                          backgroundColor: controller.color1);
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: VoiceSlider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    iconSize: 40,
                    onPressed: () => controller.replay(),
                    icon: Icon(Icons.replay_10_outlined)),
                IconButton(
                    iconSize: 40,
                    onPressed: () => controller.pre(),
                    icon: Icon(Icons.skip_previous_outlined)),
                AnimatedSwitcher(
                  transitionBuilder: (child, anim) {
                    return ScaleTransition(child: child, scale: anim);
                  },
                  duration: Duration(milliseconds: 300),
                  child: IconButton(
                      key: ValueKey(controller.playing.value),
                      iconSize: 60,
                      onPressed: () => controller.playToggle(),
                      icon: Icon(controller.playing.value
                          ? Icons.pause
                          : Icons.play_arrow_outlined)),
                ),
                IconButton(
                    iconSize: 40,
                    onPressed: () => controller.next(),
                    icon: Icon(Icons.skip_next_outlined)),
                IconButton(
                    iconSize: 40,
                    onPressed: () => controller.forward(),
                    icon: Icon(Icons.forward_10_outlined)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
