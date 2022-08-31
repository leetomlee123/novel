import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/pages/search/search_model.dart';
import 'package:novel/services/listen.dart';

class SearchController extends SuperController {
  RxList<Search>? searchs = RxList<Search>();
  TextEditingController textEditingController = TextEditingController();
  RxList<TopRank> result = <TopRank>[].obs;
  RxBool showResult = true.obs;
  final ScrollController? controller = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    controller?.addListener(() {
      focusNode.unfocus();
    });
    // getTop();
  }

//搜索
  search(String v) async {
    if (v.isEmpty) return;
    searchs!.clear();
    searchs!.value = (await ListenApi().search(v))!;
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
    controller?.dispose();
  }

  @override
  void onDetached() {
    Get.focusScope!.unfocus();

    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
