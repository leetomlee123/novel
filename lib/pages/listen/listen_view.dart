import 'package:audioplayers/audioplayers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        children: [_buildSearchBar(), Padding(
          padding: const EdgeInsets.only(top: 40),
          child: _buildPlayUi(),
        )],
      ),
    );
  }

  Widget _buildPlayUi() {
    return Obx(
      () => controller.play.value
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
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(20),
                                  child: ListView.builder(
                                      controller: controller.scrollcontroller,
                                      itemCount: controller.chapters.length,
                                      itemExtent: 40,
                                      itemBuilder: (ctx, i) {
                                        Item item = controller.chapters[i];
                                        return ListTile(
                                          title:
                                              Text("第${item.title ?? ""}集"),
                                          trailing: Checkbox(
                                            value: controller.idx.value == i,
                                            onChanged: (bool? value) async {
                                              if (value ?? false) {
                                                controller.idx.value = i;
    
                                                Get.back();
                                                await controller.reset();
                                                await controller.getUrl(i);
                                              }
                                            },
                                          ),
                                        );
                                      }),
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
                                color: Colors.white,
                                child: ListView.builder(
                                    itemCount: 9,
                                    itemExtent: 40,
                                    itemBuilder: (ctx, i) {
                                      return ListTile(
                                        title: Text("${.5 + (.25 * i)}x"),
                                        trailing: Checkbox(
                                          value: controller.fast.value ==
                                              (.5 * (i + 1)),
                                          onChanged: (bool? value) {
                                            if (value ?? false) {
                                              controller.fast.value =
                                                  (.5 + (.25 * i));
                                              Get.back();
                                            }
                                          },
                                        ),
                                      );
                                    }),
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
                        // IconButton(onPressed: (){
                        //     _showSheetWithoutList(context);
                        // }, icon: Icon(Icons.menu)),
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
                              key: ValueKey(controller.playerState.value),
                              iconSize: 80,
                              onPressed: () => controller.playToggle(),
                              icon: Icon(controller.playerState.value ==
                                      PlayerState.PLAYING
                                  ? Icons.stop
                                  : Icons.play_arrow)),
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
         
         
          : Padding(
              padding: const EdgeInsets.only(top: 40),
              child: _buildSearchList(),
            ),
    );
  }

  Widget _buildSearchList() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (ctx, i) {
        ListenSearchModel model = controller.searchs[i];
        String date =
            DateUtil.formatDateMs(model.addtime ?? 0, format: "yyyy/MM");
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            await controller.detail(model.id.toString());
            await controller.reset();
            controller.model.value = model;
            controller.controller!.close();
            controller.idx.value = 0;
            controller.playerState.value = PlayerState.STOPPED;
            controller.url.value = "";
            controller.play.value = true;
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
        return Container();
        // return Obx(() => controller.searchs.isEmpty
        //     ? Container()
        //     : ClipRRect(
        //         borderRadius: BorderRadius.circular(8),
        //         child: SingleChildScrollView(
        //           child: Material(
        //             color: Colors.white,
        //             elevation: 4.0,
        //             child: _buildSearchList(context),
        //           ),
        //         ),
        //       ));
      },
    );
  }

  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.inputDecorationTheme.hintStyle,
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      child: Column(
        children: [Obx(() => Text(controller.model.value.title ?? ""))],
      ),
    );
  }
}
