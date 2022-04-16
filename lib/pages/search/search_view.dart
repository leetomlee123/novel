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
          Search model = controller.searchs![i];

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.toPlay(i),
            child: Container(
              height: 130,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                children: [
                  CommonImg(
                    model.cover ?? "",
                    fit: BoxFit.fitWidth,
                    width: 80,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "${model.title ?? ""}",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(model.desc ?? "",maxLines: 3,),
                        Text(model.bookMeta ?? "",
                        style: TextStyle(color: Colors.black54),maxLines: 1,),
                      ],
                    ),
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
