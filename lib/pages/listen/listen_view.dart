import 'package:audioplayers/audioplayers.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/listen/listen_model.dart';

import 'listen_controller.dart';

class ListenPage extends GetView<ListenController> {
  const ListenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appBarTheme(context),
      child: Scaffold(
        appBar: _buildSearchBar(),
        body: Obx(
          () => controller.play.value
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateUtil.formatDateMs(
                                  controller.position.value.inMilliseconds,
                                  format: DateFormats.h_m_s),
                            ),
                            Expanded(
                              child: Slider(
                                onChangeStart: (value) =>
                                    controller.changeStart(),
                                onChanged: (double value) =>
                                    controller.movePosition(value),
                                onChangeEnd: (double value) =>
                                    controller.changeEnd(value),
                                value: controller.position.value.inSeconds
                                    .toDouble(),
                                min: .0,
                                max: controller.duration.value.inSeconds
                                    .toDouble(),
                                divisions:
                                    (controller.duration.value.inSeconds <= 0
                                        ? 1
                                        : controller.duration.value.inSeconds),
                                label: DateUtil.formatDateMs(
                                    controller.position.value.inMilliseconds,
                                    format: DateFormats.h_m_s),
                              ),
                            ),
                            Text(DateUtil.formatDateMs(
                                controller.duration.value.inMilliseconds,
                                format: DateFormats.h_m_s)),
                          ],
                        ),
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
                            IconButton(
                                iconSize: 40,
                                onPressed: () => controller.playToggle(),
                                icon: Icon(controller.playerState.value ==
                                            PlayerState.PLAYING
                                        ? Icons.stop
                                        : Icons.play_arrow
                                    // : (controller.playerState.value ==
                                    //         PlayerState.PAUSED
                                    //     ? Icons.play_arrow
                                    //     : Icons.done)
                                    )),
                            IconButton(
                                iconSize: 40,
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.skip_next_outlined)),
                            IconButton(
                                iconSize: 40,
                                onPressed: () => controller.forward(),
                                icon: Icon(Icons.forward_10_outlined)),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (ctx, i) {
                    ListenSearchModel model = controller.searchs[i];
                    String date = DateUtil.formatDateMs(model.addtime ?? 0,
                        format: "yyyy/MM");
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        await controller.detail(model.id.toString());
                        controller.model.value = model;
                        _showSheetWithoutList(context);
                        // Get.bottomSheet(_buildBottomSheet(),ignoreSafeArea: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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

                        // leading: CommonImg(
                        //   "https://img.ting55.com/$date/${model.picture}!300",
                        //   fit: BoxFit.fitWidth,
                        // ),
                        //   title: Text(model.title ?? ""),
                        //   subtitle: Text(model.author ?? ""),
                        // ),
                      ),
                    );
                  },
                  itemCount: controller.searchs.length,
                  itemExtent: 130,
                ),
        ),
      ),
    );
  }

  void _showSheetWithoutList(context) {
    showStickyFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.7,
      maxHeight: .8,
      headerHeight: 80,
      isModal: false,
      isExpand: controller.play.value,
      context: context,
      decoration: const BoxDecoration(
        // color: Colors.teal,
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      headerBuilder: (context, offset) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            // color: Colors.green,
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(offset == 0.8 ? 0 : 20),
              topRight: Radius.circular(offset == 0.8 ? 0 : 20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  leading: CommonImg(
                    "https://img.ting55.com/${DateUtil.formatDateMs(controller.model.value.addtime ?? 0, format: "yyyy/MM")}/${controller.model.value.picture}!300",
                  ),
                  title: Text(controller.model.value.author ?? ""),
                  subtitle: Text(controller.model.value.transmit ?? ""),
                  trailing: Text(" 共${controller.chapters.length}集"),
                ),
              ),
            ],
          ),
        );
      },
      bodyBuilder: (context, offset) {
        return SliverChildListDelegate(buildChapters());
      },
      anchors: [.2, 0.5, .8],
    );
  }

  List<Widget> buildChapters() {
    List<Widget> wds = [];
    int len = controller.chapters.length;
    for (int i = 0; i < len; i++) {
      Item element = controller.chapters[i];
      wds.add(Card(
        child: ListTile(
          title: Text(element.title ?? ""),
          onTap: () => controller.getUrl(i),
        ),
      ));
    }
    return wds;
  }

  AppBar _buildSearchBar() {
    return AppBar(
      title: TextField(
          // autofocus: true,
          onSubmitted: (v) => controller.search(v),
          controller: controller.textEditingController,
          decoration: InputDecoration(
              hintText: "书名/作者名",
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => controller.clear(),
              ))),
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
