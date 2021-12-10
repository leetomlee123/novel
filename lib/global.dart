import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/common/values/values.dart';
import 'package:novel/pages/login/login_model.dart';
import 'package:novel/services/system.dart';
import 'package:novel/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_util/sp_util.dart';

/// 全局配置
class Global {
  /// System overlays should be drawn with a light color. Intended for
  /// applications with a dark background.
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  /// System overlays should be drawn with a dark color. Intended for
  /// applications with a light background.
  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  /// 用户配置
  static UserProfileModel? profile = UserProfileModel(token: "");
  static ReadSetting? setting;

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isIOS || Platform.isAndroid) {
      if (!await Permission.storage.request().isGranted) {
        return;
      }
    }
    // Ruquest 模块初始化
    Request();
    // 本地存储初始化
    await SpUtil.getInstance();

    //配置文件
    SystemApi().getConfigs();

    //检查更新
    // UpdateAppUtil.checkUpdate();

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

    // 读取离线用户信息
    Map? _profileJSON = SpUtil.getObject(STORAGE_USER_PROFILE_KEY);
    if (_profileJSON != null) {
      profile = UserProfileModel.fromJson(_profileJSON);
      isOfflineLogin = true;
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(setting!.isDark! ? light : dark);
    }
  }

  // 持久化 用户信息
  static Future<bool> saveProfile(UserProfileModel userResponse) {
    profile = userResponse;
    return SpUtil.putObject(STORAGE_USER_PROFILE_KEY, userResponse.toJson())!;
  }
}
