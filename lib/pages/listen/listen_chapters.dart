import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/listen/listen_controller.dart';
import 'package:novel/pages/listen/listen_model.dart';

class ListenChapters extends GetView<ListenController> {
  const ListenChapters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modalColor = !Get.isDarkMode ? Colors.black : Colors.white;

    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      //   //设置四周边框
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // _buildClose(),
              // Spacer(),
              // Text(
              //   '播放列表',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // Spacer(),
            ],
          ),
          TabBar(
              controller: controller.tabController,
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              labelColor: modalColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              automaticIndicatorColorAdjustment: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: controller.tabs
                  .map(
                    (e) => Text(e),
                  )
                  .toList()),
          Expanded(
            child: _body(),
          ),
        ],
      ),
    );
  }

  ListView _buildChapter() {
    return ListView.builder(
        controller: controller.scrollcontroller,
        itemCount: controller.chapters.length,
        shrinkWrap: true,
        itemExtent: 40,
        itemBuilder: (ctx, i) {
          Item item = controller.chapters[i];
          return ListTile(
            onTap: () async {
              await playChapter(i);
            },
            title: Text("${controller.model.value.title}第${item.title ?? ""}回"),
            trailing: Checkbox(
              value: controller.idx.value == i,
              onChanged: (bool? value) async {
                await playChapter(i);
              },
            ),
          );
        });
  }

  Future<void> playChapter(int i) async {
    controller.idx.value = i;
    controller.audioPlayer.stop();
    controller.cache!.value = Duration.zero;
    controller.model.update((val) {
      val!.position = Duration.zero;
    });
    Get.back();

    await controller.getUrl(i);
    if (controller.playerState.value != ProcessingState.idle) {
      await controller.audioPlayer.play();
    }
  }

  Widget _body() {
    return TabBarView(
        controller: controller.tabController,
        children: [_buildChapter(), _buildHistory()]);
  }

  _buildClose() {
    return IconButton(
        onPressed: () => Get.back(), icon: Icon(Icons.close_outlined));
  }

  _buildHistory() {
    final modalColor = !Get.isDarkMode ? Colors.black : Colors.white;

    controller.initHitory();
    return ListView.separated(
      itemBuilder: (ctx, i) {
        final item = controller.history[i];
        String date =
            DateUtil.formatDateMs(item.addtime ?? 0, format: "yyyy/MM");
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: ListTile(
              leading: CommonImg(
                "https://img.ting55.com/$date/${item.picture}!300",
                width: 100,
                aspect: 1,
              ),
              contentPadding: const EdgeInsets.all(5),
              title: Text(
                item.title ?? "",
              ),
              subtitle: Text("${item.title}-第${item.idx! + 1}回"),
              trailing: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '已听',
                    style: TextStyle(color: modalColor, fontSize: 16),
                  ),
                  TextSpan(
                    text:
                        '${((item.idx! + 1) / (item.count!) * 100).toStringAsFixed(1)}%',
                    style: TextStyle(color: modalColor, fontSize: 13),
                  ),
                ]),
              ),
              // trailing: Text(
              //     '已听${((item.idx! + 1) / (item.count!) * 100).toStringAsFixed(1)}%'),

              onTap: () async {
                controller.audioPlayer.stop();
                controller.saveState();
                controller.detail(item.id.toString());

                controller.model.value = item;
                Get.back();
                controller.idx.value = controller.model.value.idx ?? 0;
                // controller.getBackgroundColor();
                controller.playerState.value = ProcessingState.idle;
                controller.showPlay.value = true;

                await controller.getUrl(i);

                await controller.audioPlayer.play();
              },
            ));
      },
      itemCount: controller.history.length,
      cacheExtent: 40,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.black45,
          indent: 10,
          endIndent: 10,
        );
      },
    );
  }
}
