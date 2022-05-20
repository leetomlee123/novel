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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(
            width: 4,
          ),
          const SizedBox(
            height: 120,
          ),
          Icon(Icons.menu),
          const SizedBox(
            width: 20,
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
          GestureDetector(child: Icon(Icons.search_outlined),   onTap: () {
                Get.toNamed(AppRoutes.search);
              },)
   ,         const SizedBox(
            width: 4,
          ),
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
