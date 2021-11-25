import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/components/loading.dart';

import 'read_book_controller.dart';

class ReadBookPage extends GetView<ReadBookController> {
  const ReadBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loadStatus.value == LOAD_STATUS.FINISH
        ? _buildContent()
        : controller.loadStatus.value == LOAD_STATUS.FAILED
            ? Center(child: Text("something is wrong,please try again"))
            : LoadingDialog());
  }

  _buildContent() {

  }
}
