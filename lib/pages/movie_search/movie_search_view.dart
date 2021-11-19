import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'movie_search_controller.dart';

class MovieSearchPage extends GetView<MovieSearchController> {
  const MovieSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // 修饰搜索框, 白色背景与圆角
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
      ),
      alignment: Alignment.center,
      height: 36,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: buildTextField(),
    );
  }

  Widget buildTextField() {
    // theme设置局部主题
    return Theme(
      data: ThemeData(primaryColor: Colors.grey),
      child: TextField(
        cursorColor: Colors.grey, // 光标颜色
        // 默认设置
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            border: InputBorder.none,
            icon: Icon(Icons.search),
            hintText: "搜索视频",
            hintStyle:
                TextStyle(fontSize: 14, color: Color.fromARGB(50, 0, 0, 0))),
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }
}
