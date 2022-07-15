import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/listen/listen_controller.dart';

class ListenChapters extends GetView<ListenController> {
  const ListenChapters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modalColor = !Get.isDarkMode ? Colors.black : Colors.white;
    return SliderTheme(
        data: SliderThemeData(
            activeTrackColor: Colors.pink.withOpacity(0.8),
            inactiveTrackColor: Colors.grey,
            thumbColor: Colors.deepPurple,
            overlayColor: Colors.deepPurple.withOpacity(0.3),
            valueIndicatorColor: Colors.deepPurple.withOpacity(0.6),
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorTextStyle: TextStyle(fontSize: 14.0)),
        child: Container(
          // decoration: BoxDecoration(
          //   borderRadius: const BorderRadius.only(
          //       topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
          //   //设置四周边框
          // ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                  controller: controller.tabController,
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  labelColor: modalColor,
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
        ));
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
              child: Text(
                "${controller.model.value.title}第${i + 1}回",
                
                style: TextStyle(
                    color: i == controller.idx.value
                        ? Colors.lightBlue
                        : null,
                        fontSize: 18
                        
                        ),
              ));

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

  Widget _body() {
    return Obx(() => TabBarView(
        controller: controller.tabController,
        children: [Padding(
          padding: const EdgeInsets.only(left: 20,top: 10),
          child: _buildChapter(),
        ), _buildHistory()]));
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

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: ListTile(
              leading: CommonImg(
                item.cover ?? "",
                width: 100,
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
                Get.back();

                controller.audioPlayer.stop();

                await controller.saveState();

                // controller.getBackgroundColor();

                controller.model.value = item;
                controller.idx.value = controller.model.value.idx ?? 0;
                // controller.getBackgroundColor();
                controller.playerState.value = ProcessingState.idle;

                await controller.getUrl(controller.idx.value);

                await controller.audioPlayer.play();
                controller.detail(item.id.toString());
              },
            ));
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
