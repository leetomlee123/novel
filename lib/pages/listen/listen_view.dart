import 'package:common_utils/common_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/pages/listen/listen_chapters.dart';
import 'package:novel/router/app_pages.dart';

import 'listen_controller.dart';

// ignore: must_be_immutable
class ListenPage extends GetView<ListenController> {
  ListenPage({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  //监听程序进入前后台的状态改变的方法

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.search);
            },
            icon: Icon(
              Icons.search_outlined,
              size: 25,
            ),
          )
        ],
        title: Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            const Text(
              '听书楼',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(7.0, 9, 0, 0),
              child: Obx(() => Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: controller.online.value
                            ? Color.fromARGB(255, 66, 196, 70)
                            : Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  )),
            ),
            const SizedBox(
              width: 6,
            ),
            Obx(() => SizedBox(
                  height: 14,
                  width: 14,
                  child: controller.getLink.value
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          strokeWidth: 2.0,
                          color: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : null,
                )),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 70, top: 10),
        child: _buildHistory(),
        color: Color.fromARGB(255, 189, 183, 183),
      ),
      bottomSheet: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.detail),
        child: Container(
          height: 70,
          width: Screen.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Obx(() => Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: ExtendedNetworkImageProvider(
                      controller.model.value.cover ?? "",
                    ),
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            controller.model.value.title ?? "",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${DateUtil.formatDateMs(controller.model.value.position!.inMilliseconds, format: 'mm:ss')}/${DateUtil.formatDateMs(controller.model.value.duration!.inMilliseconds, format: 'mm:ss')}",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    transitionBuilder: (child, anim) {
                      return ScaleTransition(child: child, scale: anim);
                    },
                    duration: Duration(milliseconds: 300),
                    child: IconButton(
                        key: ValueKey(controller.playing.value),
                        iconSize: 50,
                        onPressed: () => controller.playToggle(),
                        icon: Icon(controller.playing.value
                            ? Icons.pause
                            : Icons.play_arrow_outlined)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    onPressed: () => {
                      if (controller.model.value.count! > 0)
                        {
                          Get.bottomSheet(
                            ListenChapters(),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                          )
                        }
                    },
                    icon: Icon(Icons.playlist_play_outlined),
                    iconSize: 30,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _buildHistory() {
    return Obx(() => ListView.builder(
          itemExtent: 100,
          itemBuilder: (ctx, i) {
            final item = controller.history[i];

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                if (i != 0) {
                  controller.toTop(i);

                  await controller.audioPlayer.stop();
                  await controller.saveState();
                  controller.model.value = item;
                  controller.idx.value = controller.model.value.idx ?? 0;
                  controller.playerState.value = ProcessingState.idle;

                  await controller.getUrl(controller.idx.value);

                  await controller.audioPlayer.play();
                  controller.detail(item.id.toString());
                }
                Get.toNamed(AppRoutes.detail);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.deepPurpleAccent,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
                  ),
                  height: 100,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: ExtendedNetworkImageProvider(
                          item.cover ?? "",
                        ),
                        radius: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title ?? "",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "第${item.idx! + 1}回",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (i == 0) return;
                                controller.toTop(i);

                                await controller.audioPlayer.stop();
                                await controller.saveState();
                                controller.model.value = item;
                                controller.idx.value =
                                    controller.model.value.idx ?? 0;
                                controller.playerState.value =
                                    ProcessingState.idle;

                                await controller.getUrl(controller.idx.value);

                                await controller.audioPlayer.play();
                                controller.detail(item.id.toString());
                              },
                              icon: Icon(
                                i == 0
                                    ? Icons.music_note_outlined
                                    : Icons.play_arrow_rounded,
                                size: 30,
                                color: Colors.white,
                              )),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: '已听',
                                style: TextStyle(fontSize: 11),
                              ),
                              TextSpan(
                                text:
                                    '${((item.idx! + 1) / ((item.count ?? 1) == 0 ? 100 : (item.count ?? 1)) * 100).toStringAsFixed(1)}%',
                                style: TextStyle(fontSize: 10),
                              ),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: controller.history.length,
        ));
  }
}
