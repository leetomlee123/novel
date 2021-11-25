import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    //创建透明层
    Brightness brightness = Theme.of(context).brightness;
    return Container(
      color: Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(
              brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
