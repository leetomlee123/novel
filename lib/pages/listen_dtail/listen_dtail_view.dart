import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/listen/adjust_speed.dart';
import 'package:novel/pages/listen/listen_chapters.dart';
import 'package:novel/pages/listen/voice_slider.dart';

import '../listen/listen_controller.dart';

class ListenDtailPage extends GetView<ListenController> {
  const ListenDtailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.model.value.title??""),centerTitle: true,),
      body: _buildPlayUi(),
    );
  }

  Widget _buildPlayUi() {
    return Obx(()=> Center(
    
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                            elevation: 2,backgroundColor: controller.color1
                           );
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
      
    ));
  }
}
