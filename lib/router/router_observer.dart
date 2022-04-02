import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:novel/common/values/setting.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    // TODO: implement didPop
    super.didPop(route, previousRoute);
    print("pop");
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // TODO: implement didPush
    super.didPush(route, previousRoute);
    print("push");
    setNav();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    // TODO: implement didRemove
    super.didRemove(route, previousRoute);
    print("remove");
    setNav();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    // TODO: implement didReplace
    // super.didReplace(newRoute, oldRoute);
    print("replace");
    setNav();
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    // TODO: implement didStartUserGesture
    super.didStartUserGesture(route, previousRoute);
    print("ges start");
    setNav();
  }

  setNav() {
    // var indexController = Get.find<IndexController>();
    // var dark = indexController.darkModel;
    // print("set nav $dark");
    // SystemChrome.restoreSystemUIOverlays();
    // SystemChrome.setSystemUIOverlayStyle(
    //     !dark.value ? ReadSetting.light : ReadSetting.dark);
  }
}
