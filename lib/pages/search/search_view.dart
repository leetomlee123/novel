import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_controller.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/pages/search/search_controller.dart';

import '../../components/common_img.dart';

class SearchPage extends GetView<SearchController> {
  SearchPage({Key? key}) : super(key: key);
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: _buildInput(),
            backgroundColor: Colors.black87,
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
          suffixIcon: IconButton(icon: Icon(Icons.close_outlined,),onPressed: ()=>controller.clear(),),
          
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
            onTap: () async {

              Get.find<ListenController>().toPlay(i, model);
            },
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          model.desc ?? "",
                          maxLines: 3,
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          model.bookMeta ?? "",
                          maxLines: 1,
                        ),
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
        cacheExtent: 130,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Color.fromARGB(255, 187, 143, 10),
          );
        },
      ),
    );
  }
}
