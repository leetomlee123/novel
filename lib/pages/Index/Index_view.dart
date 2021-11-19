import 'package:flutter/material.dart';
import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/pages/home/home_view.dart';
import 'package:novel/pages/splash/spalsh_view.dart';
import 'package:get/get.dart';

class IndexPage extends GetView<IndexController> {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        body:
            controller.isloadWelcomePage.isTrue ? SplashPage() : HomePage()));
  }
}
