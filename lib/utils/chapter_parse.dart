// 必须是顶层函数
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:novel/services/book.dart';
import 'package:novel/utils/request.dart';
import 'package:sp_util/sp_util.dart';

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

_encode(var response) {
  return jsonEncode(response);
}

encodeJson(var text) {
  return compute(_encode, text);
}

class DownChapter {
  int? idx;
  String? chapterContent;
  String? chapterId;
  String? hasContent;
  DownChapter({this.chapterContent, this.idx, this.chapterId, this.hasContent});
}

Future<List<DownChapter>> downChapter(List<DownChapter> cps) async {
  int len = cps.length;
  for (var i = 0; i < len; i++) {
    String chapterContent =
        await ChapterParseUtil().getChapterCotent(cps[i].chapterId ?? "");
    cps[i].chapterContent = chapterContent;
  }
  print("download all");
  return cps;
}

/// Isolate的顶级方法
void isolateTopLevelFunction(SendPort sendPort) {
  final receivePort = ReceivePort();

  /// 绑定
  // print('执行：3'); // ----> 3. 将2边sendPort进行绑定
  sendPort.send(receivePort.sendPort);
  var message = receivePort.first;
  print("dd");
  // final downChapter = message[0] as DownChapter;
  // final send = message[1] as SendPort;

  /// 监听
  // print('执行：4'); // ----> 4. 创建监听，监听那边发过来的数据和SendPort
  // receivePort.listen((message) async {
  //   // print('执行：7'); // ----> 7. 监听到了那边发过来的数据和SendPort

  //   /// 获取数据并解析
  //   final downChapter = message[0] as DownChapter;
  //   final send = message[1] as SendPort;
  //   // print(downChapter.chapterId ?? "");
  //   print(downChapter.chapterId);

  //   /// 返回结果
  //   // print('执行：8'); // ----> 8. 用拿到的数据进行大量的计算

  // String chapterContent =
  //     await ChapterParseUtil().getChapterCotent(downChapter.chapterId ?? "");

  //   downChapter.chapterContent = chapterContent;
  //   // print("getOk");
  //   // // print('执行：10'); // ----> 10. 将计算完的数据发到那边
  //   print("get content from network");
  //   send.send(downChapter);
  // });
}

class ChapterParseUtil {
  static ChapterParseUtil _instance = ChapterParseUtil._internal();

  factory ChapterParseUtil() => _instance;

  static List<ParseContentConfig>? _configs;
  Future<List<ParseContentConfig>?> get configs async {
  Set<String>? keys=  SpUtil.getKeys();
    if (_configs == null) {
      _configs =
          SpUtil.getObjList("rules", (v) => ParseContentConfig.fromJson(v))!
              .toList();
    }
    return _configs;
  }

  Future<String> getChapterCotent(String chapterId) async {
    //从数据库中取
    var res = await BookApi().getContent(chapterId);
    String chapterContent = res['content'];
    if (chapterContent.isEmpty) {
      //本地解析
      chapterContent = await parseContent(res['link']);
      //上传到数据库
      BookApi().updateContent(chapterId, chapterContent);
    }

    return chapterContent;
  }

  Future<String> parseContent(String url) async {
    var c = "";
    var res = await Request().get(url);

    Element? content;
    List<ParseContentConfig>? cfs = await configs;
    cfs!.forEach((element) {
      if (url.contains(element.domain ?? "")) {
        content = parse(res, encoding: element.encode ?? "")
            .getElementById(element.documentId ?? "");
      }
    });

    if (content == null) {
      content = parse(res['data']).getElementById("content");
    }

    content!.nodes.forEach((element) {
      var text = element.text!.trim();
      if (text.isNotEmpty) {
        c += "\t\t\t\t\t\t\t\t" + text + "\n";
      }
    });
    return c;
  }

  ChapterParseUtil._internal() {}
}

class ParseContentConfig {
  String? domain;
  String? encode;
  String? documentId;

  ParseContentConfig({this.domain, this.encode, this.documentId});

  ParseContentConfig.fromJson(Map<dynamic, dynamic> json) {
    domain = json['domain'];
    encode = json['encode'];
    documentId = json['documentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain'] = this.domain;
    data['encode'] = this.encode;
    data['documentId'] = this.documentId;
    return data;
  }
}
