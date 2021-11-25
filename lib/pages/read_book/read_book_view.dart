import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/components/loading.dart';
import 'package:novel/pages/book_menu/book_menu_view.dart';

import 'read_book_controller.dart';

class ReadBookPage extends GetView<ReadBookController> {
  ReadBookPage({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loadStatus.value == LOAD_STATUS.FINISH
        ? _buildContent()
        : controller.loadStatus.value == LOAD_STATUS.FAILED
            ? Center(child: Text("something is wrong,please try again"))
            : LoadingDialog());
  }

  _buildContent() {
    return Scaffold(
      drawer: Drawer(
        child: BookMenuPage(),
      ),
      body: _buildPage(),
      key: _scaffoldKey,
    );
  }

  _buildPage(){
    return Container(child: Text("ssss"),);
  }
}
