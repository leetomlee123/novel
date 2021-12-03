import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get/get.dart';
import 'package:novel/global.dart';
import 'package:novel/pages/read_book/read_book_controller.dart';
import 'package:novel/utils/CustomCacheManager.dart';
import 'package:novel/utils/local_storage.dart';

class FontSetController extends GetxController {
  RxList<FontInfo> fonts = List<FontInfo>.empty().obs;
  RxBool download = false.obs;
  Rx<String?> fontName = Global.setting!.fontName.obs;
  RxDouble process = .0.obs;
  Stream? fileStream;
  String? tempFonts = Global.setting!.fontName;
  @override
  void onInit() {
    super.onInit();
    initFontInfos();
    FlutterStatusbarManager.setFullscreen(false);
  }

  initFontInfos() async {
    {
      Map map = LocalStorage().getJSON("fonts");
      var entries = map.entries;
      fonts.add(FontInfo("默认字体", "", null));
      for (int i = 0; i < entries.length; i++) {
        var k = entries.elementAt(i).key;
        var v = entries.elementAt(i).value;
        var fontInfo =
            await CustomCacheManager.instanceFont.getFileFromCache(k);
        fonts.add(FontInfo(k, v, fontInfo));
      }
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    FlutterStatusbarManager.setFullscreen(true);
    if (tempFonts != fontName.value) {
      Get.find<ReadBookController>().updPage();
    }
  }

  setFont(FontInfo e, int i) async {
    download.value = false;
    fontName.value = e.fontName;

    Global.setting!.fontName = e.fontName;
    Global.setting!.persistence();
    if (e.fileInfo == null && e.fontName != "默认字体") {
      fileStream = CustomCacheManager.instanceFont
          .getFileStream(e.fontUrl ?? "", key: e.fontName, withProgress: true);

      download.value = true;

      fileStream!.listen((event) {
        try {
          var downloadProcess = event as DownloadProgress;
          process.value =
              NumUtil.getNumByValueDouble(downloadProcess.progress, 2)!
                  .toDouble();
          print(process.value);
        } catch (e) {}
        try {
          var fileInfo = event as FileInfo;
          fonts.elementAt(i).fileInfo = fileInfo;
        } catch (e) {}
      }).onDone(() async {
        download.value = false;
        process.value = .0;
        fileStream = null;

        fontName.value = e.fontName;
        var fontLoader = FontLoader(e.fontName ?? "");

        Uint8List readAsBytes = fonts[i].fileInfo!.file.readAsBytesSync();

        fontLoader.addFont(Future.value(ByteData.view(readAsBytes.buffer)));
        await fontLoader.load();
      });
    } else {
      if (e.fileInfo != null) {
        var fontLoader = FontLoader(e.fontName ?? "");

        Uint8List readAsBytes = fonts[i].fileInfo!.file.readAsBytesSync();

        fontLoader.addFont(Future.value(ByteData.view(readAsBytes.buffer)));
        await fontLoader.load();
      }
    }
  }
}

class FontInfo {
  String? fontName;
  String? fontUrl;
  FileInfo? fileInfo;

  FontInfo(this.fontName, this.fontUrl, this.fileInfo);
}
