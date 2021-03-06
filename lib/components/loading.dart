import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    //创建透明层
    Brightness brightness = Theme.of(context).brightness;
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        strokeWidth: 2.0,
        color: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(
            brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
    );
  }
}
