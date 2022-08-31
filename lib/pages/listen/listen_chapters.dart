import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/listen/listen_controller.dart';

class ListenChapters extends GetView<ListenController> {
  const ListenChapters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: _buildChapter()
    );
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
              child: Row(children: [
                const SizedBox(width: 10,),
                Text(
                "${controller.model.value.title}",
                
                style: TextStyle(
                    color: i == controller.idx.value
                        ? Colors.lightBlue
                        : null,
                        fontSize: 22
                        
                        ),
              ),
              const SizedBox(width: 4,),
              Text(
                "-第${i + 1}回",
                
                style: TextStyle(
                    color: i == controller.idx.value
                        ? Colors.lightBlue
                        : null,
                        fontSize: 14
                        
                        ),
              ),
                Spacer(),
                Offstage(offstage: i!=controller.idx.value,child:  Icon(Icons.check,color: Colors.lightBlue,),),
                const SizedBox(width: 10,),
              ],)
              
              );

          // return ListTile(
          //   onTap: () async {
          //     await playChapter(i);
          //   },
          //   title: Text("${controller.model.value.title}-第${i + 1}回"),
          //   trailing: Checkbox(
          //     value: controller.idx.value == i,
          //     onChanged: (bool? value) async {
          //       await playChapter(i);
          //     },
          //   ),
          // );
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



  _buildHistory() {
    final modalColor = Colors.white;
    return ListView.separated(
      itemBuilder: (ctx, i) {
        final item = controller.history[i];

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            Get.back();

            controller.audioPlayer.stop();

            await controller.saveState();
            controller.model.value = item;
            controller.idx.value = controller.model.value.idx ?? 0;
            controller.playerState.value = ProcessingState.idle;

            await controller.getUrl(controller.idx.value);

            await controller.audioPlayer.play();
            controller.detail(item.id.toString());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                CommonImg(
                  item.cover ?? "",
                  width: 50,
                  aspect: .8,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "第${item.idx! + 1}回",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () => controller.removeHistory(i),
                        icon: Icon(
                          Icons.close_outlined,
                          size: 20,
                          color: Colors.redAccent,
                        )),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '已听',
                          style: TextStyle(color: modalColor, fontSize: 11),
                        ),
                        TextSpan(
                          text:
                              '${((item.idx! + 1) / (item.count ?? 1) * 100).toStringAsFixed(1)}%',
                          style: TextStyle(color: modalColor, fontSize: 10),
                        ),
                      ]),
                    ),
                  ],
                )
              ],
            ),
          ),
        );


      },
      itemCount: controller.history.length,
      cacheExtent: 40,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Color.fromARGB(115, 114, 40, 156),
          indent: 15,
          endIndent: 15,
        );
      },
    );
  }


}
