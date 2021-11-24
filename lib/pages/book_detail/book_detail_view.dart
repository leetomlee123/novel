import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/components/loading.dart';

import 'book_detail_controller.dart';

class BookDetailPage extends GetView<BookDetailController> {
  const BookDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => null == controller.bookDetailModel.value.id
        ? LoadingDialog()
        : Scaffold(
            body: Container(),
          ));
  }
}
