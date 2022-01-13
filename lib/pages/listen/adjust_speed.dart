import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:novel/pages/listen/listen_controller.dart';

class ListenAdjustSpeed extends GetView<ListenController> {
  const ListenAdjustSpeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        //   //设置四周边框
        //   border: Border.all(
        //     width: 1,
        //   ),
        // ),
        child: ListView.builder(
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
      ),
    );
  }
}
