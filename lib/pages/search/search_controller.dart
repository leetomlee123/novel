import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/services/listen.dart';

class SearchController extends GetxController {
  RxList<Search>? searchs = RxList<Search>();
  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

//搜索
  search(String v) async {
    if (v.isEmpty) return;
    searchs!.clear();
    searchs!.value = (await ListenApi().search(v))!;
    Get.focusScope!.unfocus();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    textEditingController.dispose();
  }
}
