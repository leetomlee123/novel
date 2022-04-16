import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_controller.dart';

class ListenAdjustSpeed extends GetView<ListenController> {
  const ListenAdjustSpeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        // decoration: BoxDecoration(
        //   color: Colors.white10,
        //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
        //   //设置四周边框
        // ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close_outlined)),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  '播放速度调节',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 9,
                itemExtent: 40,
                itemBuilder: (ctx, i) {
                  var v = (.5 + (.25 * i));
                  return ListTile(
                    onTap: () {
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
                }),
          ],
        ),
      ),
    );
  }
}
