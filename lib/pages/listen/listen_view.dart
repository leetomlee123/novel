import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/listen/adjust_speed.dart';
import 'package:novel/pages/listen/listen_chapters.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/pages/listen/voice_slider.dart';

import 'listen_controller.dart';

class ListenPage extends GetView<ListenController> {
  const ListenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildSearchBar(),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: _buildPlayUi(),
          )
        ],
      ),
    );
  }

  Widget _buildPlayUi() {
    return Obx(
      () => controller.showPlay.value
          ? Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: CommonImg(
                        "https://img.ting55.com/${DateUtil.formatDateMs(controller.model.value.addtime ?? 0, format: "yyyy/MM")}/${controller.model.value.picture}!300",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("第${controller.idx.value + 1}集"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                          // Text.rich(TextSpan(children: [
                          //   TextSpan(text: "作者${controller.model.value.author}-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                          //   TextSpan(
                          //       text: "播音${controller.model.value.transmit ?? ''}",
                          //       style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w100,fontSize: 18)),
                          //   // WidgetSpan(child: Icon(Icons.home))
                          // ]))
                          Text(
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
                                  size: 40,
                                ),
                                Text("播放列表"),
                              ],
                            ),
                            onTap: () {
                              if (controller.chapters.isNotEmpty) {
                                Get.bottomSheet(
                                  ListenChapters(),
                                );
                              }
                            },
                          ),
                          GestureDetector(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.fast_forward,
                                  size: 40,
                                ),
                                Text("倍速"),
                              ],
                            ),
                            onTap: () {
                              Get.bottomSheet(ListenAdjustSpeed());
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
            )
          : Container(),
    );
  }

  Widget _buildSearchList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, i) {
        ListenSearchModel model = controller.searchs[i];
        String date =
            DateUtil.formatDateMs(model.addtime ?? 0, format: "yyyy/MM");
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            await controller.detail(model.id.toString());
            controller.model.value = model;
            controller.controller!.close();
            controller.idx.value = 0;
            controller.playerState.value = ProcessingState.idle;
            controller.showPlay.value = true;
            await controller.getUrl(i);
            await controller.audioPlayer.play();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                CommonImg(
                  "https://img.ting55.com/$date/${model.picture}!300",
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "${model.title ?? ""}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("著:${model.author ?? ""}"),
                    Text("音:${model.transmit ?? ""}"),
                  ],
                )
              ],
            ),
            // child: ListTile(
          ),
        );
      },
      itemCount: controller.searchs.length,
      itemExtent: 130,
    );
  }

  Widget _buildSearchBar() {
    final isPortrait =
        MediaQuery.of(Get.context!).orientation == Orientation.portrait;
    return FloatingSearchBar(
      closeOnBackdropTap: true,
      controller: controller.controller,
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) => controller.search(query),
      onFocusChanged: (isFocus) {
        controller.searchs.clear();
        controller.showPlay.value = !isFocus;
      },
      // isScrollControlled: true,

      transition: CircularFloatingSearchBarTransition(),
      automaticallyImplyBackButton: false,
      leadingActions: [
        FloatingSearchBarAction.hamburgerToBack(),
      ],
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.sensors),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        // return Container();
        return Obx(() => controller.searchs.isEmpty
            ? Container()
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: _buildSearchList(),
                ),
              ));
      },
    );
  }
}
