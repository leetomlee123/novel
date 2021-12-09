import 'package:flutter/material.dart';

class NavigationIconView {
  final BottomNavigationBarItem item;
  final AnimationController controller;

  NavigationIconView({IconData? iconData, String? title, TickerProvider? vsync})
      : item = BottomNavigationBarItem(
          icon: Icon(
            iconData,
            size: 18,
          ),
          label: title,
        ),
        controller = AnimationController(
            duration: kThemeAnimationDuration, // 设置动画持续的时间
            vsync: vsync! // 默认属性和参数
            );
}
