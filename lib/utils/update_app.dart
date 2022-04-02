import 'dart:io';

import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/system.dart';

class UpdateAppUtil {
  ///初始化
  static Future<void> _initXUpdate() async {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(

              ///是否输出日志
              debug: true,

              ///是否使用post请求
              isPost: false,

              ///post请求是否是上传json
              isPostJson: false,

              ///是否开启自动模式
              isWifiOnly: false,

              ///是否开启自动模式
              isAutoMode: false,

              ///需要设置的公共参数
              supportSilentInstall: false,

              ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
              enableRetry: false)
          .then((value) {
        //  updateMessage("初始化成功: $value");
      }).catchError((error) {});
      // FlutterXUpdate.setErrorHandler(
      //     onUpdateError: (Map<String, dynamic> message) async {

      //     });
    }
  }

  static Future<void> checkUpdate() async {
    await _initXUpdate();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    AppInfo appInfo = await SystemApi().updateApp();

    if (int.parse(appInfo.version!.replaceAll(".", "")) >
        int.parse(version.replaceAll(".", ""))) {
      var up = UpdateEntity(
          hasUpdate: true,
          isForce: appInfo.forceUpdate == "2",
          isIgnorable: false,
          versionCode: 1,
          versionName: appInfo.version,
          updateContent: appInfo.msg,
          downloadUrl: appInfo.link,
          apkSize: int.parse(appInfo.apkSize ?? ""),
          apkMd5: appInfo.apkMD5);

      FlutterXUpdate.updateByInfo(
          updateEntity: up, supportBackgroundUpdate: true, widthRatio: .6);
    }
  }
}

class AppInfo {
  String? id;
  String? msg;
  String? link;
  String? version;
  String? forceUpdate;
  String? apkMD5;
  String? apkSize;

  AppInfo(
      {this.id,
      this.msg,
      this.link,
      this.version,
      this.forceUpdate,
      this.apkMD5,
      this.apkSize});

  AppInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msg = json['msg'];
    link = json['link'];
    version = json['version'];
    forceUpdate = json['forceUpdate'];
    apkMD5 = json['apkMD5'];
    apkSize = json['apkSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['msg'] = this.msg;
    data['link'] = this.link;
    data['version'] = this.version;
    data['forceUpdate'] = this.forceUpdate;
    data['apkMD5'] = this.apkMD5;
    data['apkSize'] = this.apkSize;
    return data;
  }
}
