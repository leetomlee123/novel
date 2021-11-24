import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'read_book_controller.dart';

class ReadBookPage extends GetView<ReadBookController> {
  const ReadBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(controller.book.name ?? ""),
      color: Colors.red,
    );
  }
}
