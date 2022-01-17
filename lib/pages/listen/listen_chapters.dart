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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          //设置四周边框
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            TabBar(
                controller: controller.tabController,
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
            },
            title: Text("${controller.model.value.title}第${item.title ?? ""}回"),
            trailing: Checkbox(
              value: controller.idx.value == i,
              onChanged: (bool? value) async {
                controller.idx.value = i;
                Get.back();
                await controller.getUrl(i);
                if (controller.playerState.value != ProcessingState.idle) {
                  await controller.audioPlayer.play();
                }
              },
            ),
          );
        });
  }

  Widget _body() {
    return TabBarView(
        controller: controller.tabController,
        children: [_buildChapter(), _buildHistory()]);
  }

  _buildHistory() {
    controller.initHitory();
    return ListView.separated(
      itemBuilder: (ctx, i) {
        final item = controller.history[i];
        String date =
            DateUtil.formatDateMs(item.addtime ?? 0, format: "yyyy/MM");
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: CommonImg(
                "https://img.ting55.com/$date/${item.picture}!300",
                width: 60,
                aspect: .8,
              ),
              title: Text(
                item.title ?? "",
              ),
              subtitle: Text("${item.title}-第${controller.idx.value + 1}回"),
              trailing: Text(
                  '已听%${((controller.idx.value + 1) / (controller.chapters.length) * 100).toStringAsFixed(1)}'),
            ));
      },
      itemCount: controller.history.length,
      cacheExtent: 40,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
