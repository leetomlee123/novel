import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:novel/components/common_img.dart';
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
                      height: 100,
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
                                  size: 40,
                                ),
                                Text("播放列表"),
                              ],
                            ),
                            onTap: () {
                              if (controller.chapters.isNotEmpty) {
                                Get.bottomSheet(Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0)),
                                    //设置四周边框
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: _buildChapters()
                                ));
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
                              Get.bottomSheet(Container(
                                padding: const EdgeInsets.all(20),
                                     decoration: BoxDecoration(
                                    color: Colors.white,

                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0)),
                                    //设置四周边框
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                  ),
                                child: _buildAdjustVolum(),
                              ));
                            },
                          )
                        ],
                      ),
                    ),
                    VoiceSlider(),
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
                        // Visibility(
                        //   visible: (controller.playerState.value ==
                        //           ProcessingState.ready ||
                        //       controller.playerState.value ==
                        //           ProcessingState.buffering),
                        //   replacement: Text(
                        //     'init',
                        //     style: TextStyle(fontSize: 35),
                        //   ),
                        // TextButton(
                        //   child: Text("init...."),
                        //   onPressed: () {},
                        //   style: ButtonStyle(
                        //     textStyle: MaterialStateProperty.all(
                        //         TextStyle(fontSize: 35, color: Colors.red)),
                        //   ),
                        // ),
                        // child:
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
                        // ),
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

  ListView _buildAdjustVolum() {
    return ListView.builder(
        itemCount: 9,
        itemExtent: 40,
        itemBuilder: (ctx, i) {
          var v = (.5 + (.25 * i));
          return ListTile(
            onTap: (){
           controller.fast.value = v;
                  Get.back();
            },
            title: Text("${v}x"),
            trailing: Checkbox(
              value: controller.fast.value == v,
              onChanged: (bool? value) {
                  controller.fast.value = v;
                  Get.back();
              },
            ),
          );
        });
  }

  ListView _buildChapters() {

    return ListView.builder(
        controller: controller.scrollcontroller,
        itemCount: controller.chapters.length,
        shrinkWrap: true,
        itemExtent: 40,
        itemBuilder: (ctx, i) {
          Item item = controller.chapters[i];
          return ListTile(
            onTap: () async {
              controller.idx.value = i;
              Get.back();
              // await controller.reset();
              await controller.getUrl(i);
              if (controller.playerState.value != ProcessingState.idle) {
                await controller.audioPlayer.play();
              }
            },
            title: Text("${controller.model.value.title}第${item.title ?? ""}回"),
            trailing: Checkbox(
              value: controller.idx.value == i,
              onChanged: (bool? value) async {
                controller.idx.value = i;
                Get.back();
                // await controller.reset();
                await controller.getUrl(i);
                if (controller.playerState.value != ProcessingState.idle) {
                  await controller.audioPlayer.play();
                }
              },
            ),
          );
        });
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
