import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novel/pages/listen/listen_controller.dart';

class ListenChapters extends GetView<ListenController> {
  const ListenChapters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: _buildChapter());
  }

  ListView _buildChapter() {
    return ListView.builder(
        controller: controller.scrollcontroller,
        itemCount: controller.model.value.count,
        shrinkWrap: true,
        itemExtent: 40,
        itemBuilder: (ctx, i) {
          return GestureDetector(
              onTap: () async {
                await playChapter(i);
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${controller.model.value.title}",
                    style: TextStyle(
                        color:
                            i == controller.idx.value ? Colors.lightBlue : null,
                        fontSize: 22),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "-第${i + 1}回",
                    style: TextStyle(
                        color:
                            i == controller.idx.value ? Colors.lightBlue : null,
                        fontSize: 14),
                  ),
                  Spacer(),
                  Offstage(
                    offstage: i != controller.idx.value,
                    child: Icon(
                      Icons.check,
                      color: Colors.lightBlue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ));
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

      controller.updatePlay();
    }
  }
}
