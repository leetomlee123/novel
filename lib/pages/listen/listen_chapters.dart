import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novel/pages/listen/listen_controller.dart';
import 'package:novel/pages/listen/listen_model.dart';

class ListenChapters extends GetView<ListenController> {
  const ListenChapters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(     ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: ListView.builder(
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
                title: Text(
                    "${controller.model.value.title}第${item.title ?? ""}回"),
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
            }),
      ),
    );
  }
}
