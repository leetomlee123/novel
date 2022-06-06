import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/pages/search/search_model.dart';
import 'package:novel/services/listen.dart';

class SearchController extends GetxController {
  RxList<Search>? searchs = RxList<Search>();
  TextEditingController textEditingController = TextEditingController();
  RxList<TopRank> result = <TopRank>[].obs;
  RxBool showResult = true.obs;
  @override
  void onInit() {
    super.onInit();
    // getTop();
  }

//搜索
  search(String v) async {
    if (v.isEmpty) return;
    searchs!.clear();
    searchs!.value = (await ListenApi().search(v))!;
    Get.focusScope!.unfocus();
  }

  getTop() async {
    result.value = await compute(ListenApi().rank, "");
  }

  clear() {
    searchs!.clear();
    textEditingController.clear();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    textEditingController.dispose();
  }
}
