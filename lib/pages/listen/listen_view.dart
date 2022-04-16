import 'package:common_utils/common_utils.dart';
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
        appBar: _buildAppBar(),
        body: _buildPlayUi());
  }

  _buildAppBar() {
    return AppBar(
      leading: Icon(Icons.menu),
      elevation: 0,
      title: Offstage(
        offstage: !controller.getLink.value,
        child: const Text(
          '获取资源中...',
          style: TextStyle(fontSize: 13),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.search);
            },
            icon: Icon(Icons.search_outlined))
      ],
    );
  }

  Widget _buildPlayUi() {
    final modalColor = Colors.white;

    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CommonImg(
                  "https://img.ting55.com/${DateUtil.formatDateMs(controller.model.value.addtime ?? 0, format: "yyyy/MM")}/${controller.model.value.picture}!300",
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("第${controller.idx.value + 1}集"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      "作者${controller.model.value.author}    |   播音${controller.model.value.transmit ?? ''}"),
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
                              size: 35,
                            ),
                            Text("播放列表"),
                          ],
                        ),
                        onTap: () {
                          if (controller.chapters.isNotEmpty) {
                            Get.bottomSheet(ListenChapters(),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                backgroundColor: modalColor);

                            // showModalBottomSheet(
                            //     context: Get.context!,
                            //     builder: (ctx) {
                            //       return Stack(
                            //         children: <Widget>[
                            //           Container(
                            //             height: 25,
                            //             width: double.infinity,
                            //             color: modalColor,
                            //           ),
                            //           Container(
                            //             decoration: BoxDecoration(
                            //                 color: modalColor,
                            //                 borderRadius:
                            //                     BorderRadius.only(
                            //                   topLeft:
                            //                       Radius.circular(25),
                            //                   topRight:
                            //                       Radius.circular(25),
                            //                 )),
                            //           ),

                            //         ],
                            //       );
                            //     });
                          }
                        },
                      ),
                      // Checkbox(
                      //     value: controller.useProxy.value,
                      //     onChanged: (_) => controller.useProxy.toggle()),
                      GestureDetector(
                        child: Column(
                          children: [
                            Icon(
                              Icons.fast_forward,
                              size: 35,
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
                              backgroundColor: modalColor);

                          // showModalBottomSheet(
                          //     context: Get.context!,
                          //     builder: (ctx) {
                          //       return Stack(
                          //         children: <Widget>[
                          //           Container(
                          //             height: 30.0,
                          //             width: double.infinity,
                          //             color: Colors.black54,
                          //           ),
                          //           Container(
                          //             decoration: BoxDecoration(
                          //                 color: modalColor,
                          //                 borderRadius: BorderRadius.only(
                          //                   topLeft: Radius.circular(25),
                          //                   topRight: Radius.circular(25),
                          //                 )),
                          //           ),
                          //           ListenAdjustSpeed()
                          //         ],
                          //       );
                          //     });
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        ));
  }



}
