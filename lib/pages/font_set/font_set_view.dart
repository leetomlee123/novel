import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'font_set_controller.dart';

class FontSetPage extends GetView<FontSetController> {
  const FontSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("字体"),
        ),
        body: Obx(() => controller.fonts.isEmpty
            ? Container()
            : Container(
                child: _buildPoet(),
                padding: EdgeInsets.all(20),
              )));
  }

  _buildPoet() {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            "问刘十九",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1.4,
                letterSpacing: .5,
                fontFamily: controller.fontName.value),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            "绿蚁新醅酒，红泥小火炉。",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1.4,
                letterSpacing: .5,
                fontFamily: controller.fontName.value),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Center(
          child: Text(
            "晚来天欲雪，能饮一杯无？",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1.4,
                letterSpacing: .5,
                fontFamily: controller.fontName.value),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
            child:
                Container(alignment: Alignment.center, child: _buildFontView()))
      ],
    );
  }

  _buildFontView() {
    print("rea");
    return ListView.builder(
      itemCount: controller.fonts.length,
      itemExtent: 40,
      itemBuilder: (context, index) {
        FontInfo e = controller.fonts[index];
        return Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Text(e.fontName ?? ""),
                  Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                        child: controller.fontName.value == e.fontName
                            ? (!controller.download.value
                                ? Icon(Icons.radio_button_checked)
                                : Text(
                                    "${NumUtil.multiply(controller.process.value, 100)}%"))
                            : Icon(Icons.radio_button_unchecked)),
                    onTap: () => controller.setFont(e, index),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ));
      },
    );
  }
}
