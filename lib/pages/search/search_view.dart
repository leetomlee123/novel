import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_controller.dart';
import 'package:novel/pages/listen/listen_model.dart';

import '../../components/common_img.dart';

class SearchPage extends GetView<ListenController> {
  SearchPage({Key? key}) : super(key: key);
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: _buildInput(),
          ),
          body: SingleChildScrollView(
            child: _buildSearchList(),
          ),
        ));
  }

  _buildInput() {
    return TextField(
      autofocus: true,
      focusNode: focusNode,
      cursorColor: Colors.white,
      cursorHeight: 25,
      controller: controller.textEditingController,
      style: TextStyle(color: Colors.white),
      onChanged: (v) => controller.search(v),
      decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white),
          alignLabelWithHint: true,
          border: InputBorder.none),
    );
  }

  //搜索结果
  Widget _buildSearchList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, i) {
          ListenSearchModel model = controller.searchs![i];
          String date =
              DateUtil.formatDateMs(model.addtime ?? 0, format: "yyyy/MM");
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.toPlay(i),
            child: Container(
              height: 120,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                children: [
                  CommonImg(
                    "https://img.ting55.com/$date/${model.picture}!300",
                    fit: BoxFit.fitWidth,
                    width: 80,
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
            ),
          );
        },
        itemCount: controller.searchs!.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.amber,
          );
        },
      ),
    );
  }
}
