import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/common/values/values.dart';
import 'package:novel/utils/utils.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:sp_util/sp_util.dart';

/// 全局配置
class Global {
  /// 用户配置
  static ReadSetting? setting;

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();
    // if (Platform.isIOS || Platform.isAndroid) {
    //   if (!await Permission.storage.request().isGranted) {
    //     return;
    //   }
    // }
    // Ruquest 模块初始化
    Request();
    // 本地存储初始化
    await SpUtil.getInstance();

    //init audioservice
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
    //广告初始化
    // MobileAds.instance.initialize();
    //检查更新
    // UpdateAppUtil.checkUpdate();
    //google service init
    await Firebase.initializeApp();
    //阅读器配置文件
    // LocalStorage().remove(ReadSetting.settingKey);
    setting = SpUtil.getObj(
        ReadSetting.settingKey, (v) => ReadSetting.fromJson(v),
        defValue: ReadSetting());

    if (setting!.topSafeHeight == null) {
      setting!.topSafeHeight = Screen.topSafeHeight;
      setting!.persistence();
    }

    // 极光推送初始化
    // await PushManager.setup();

    // 语音播报初始化
    // await TtsManager.setup();

    // 高德地图初始化
    // await AmapService.instance.init(
    //   iosKey: 'xxxx',
    //   androidKey: 'xxxx',
    // );

    // 读取设备第一次打开
    isFirstOpen = !SpUtil.getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY)!;
    if (isFirstOpen) {
      SpUtil.putBool(STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
      ReadSetting.light);
    }
  }
}
