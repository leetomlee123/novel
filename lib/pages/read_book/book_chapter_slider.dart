import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:novel/pages/read_book/read_book_controller.dart';

class BookSliderChapter extends GetView<ReadBookController> {
  BookSliderChapter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Row(
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  if ((controller.book.value.chapterIdx! - 1) < 0) {
                    BotToast.showText(text: '已经是第一章');
                    return;
                  }
                  controller.book.value.chapterIdx =
                      controller.book.value.chapterIdx! - 1;
                  await controller.initContent(
                      controller.book.value.chapterIdx!, true);
                },
                child: Text('上一章')),
            Expanded(
              child: Slider(
                value: controller.chapterIdx.value.toDouble(),
                max: (controller.chapters.length - 1).toDouble(),
                min: 0.0,
                onChanged: (newValue) {
                  int temp = newValue.round();
                  controller.book.value.chapterIdx = temp;
                  controller.chapterIdx.value = temp;
                },
                divisions: controller.chapters.length,
                label: controller
                    .chapters[controller.chapterIdx.value].chapterName,
                onChangeEnd: (_) {
                  controller.initContent(
                      controller.book.value.chapterIdx!, true);
                },
              ),
            ),
            TextButton(
                onPressed: () async {
                  if ((controller.book.value.chapterIdx! + 1) >=
                      controller.chapters.length) {
                    BotToast.showText(text: "已经是最后一章");
                    return;
                  }
                  controller.book.value.chapterIdx =
                      controller.book.value.chapterIdx! + 1;
                  await controller.initContent(
                      controller.book.value.chapterIdx!, true);
                },
                child: Text('下一章')),
          ],
        ));
  }
}
