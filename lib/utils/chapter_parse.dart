// 必须是顶层函数
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:novel/services/book.dart';
import 'package:novel/utils/local_storage.dart';
import 'package:novel/utils/request.dart';

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
  DownChapter({this.chapterContent, this.idx, this.chapterId});
}

/// Isolate的顶级方法
void isolateTopLevelFunction(SendPort sendPort) {
  final receivePort = ReceivePort();
  var send;
  List<DownChapter> dcs = List.empty(growable: true);

  /// 绑定
  // print('执行：3'); // ----> 3. 将2边sendPort进行绑定
  sendPort.send(receivePort.sendPort);

  /// 监听
  // print('执行：4'); // ----> 4. 创建监听，监听那边发过来的数据和SendPort
  receivePort.listen((message) async {
    // print('执行：7'); // ----> 7. 监听到了那边发过来的数据和SendPort

    /// 获取数据并解析
    final downChapter = message[0] as DownChapter;
    if (send == null) {
      send = message[1] as SendPort;
    }
    // print(downChapter.chapterId ?? "");
    dcs.add(downChapter);

    /// 返回结果
    // print('执行：8'); // ----> 8. 用拿到的数据进行大量的计算
  }, onDone: () {
    print("oook");
    dcs.forEach((element) async {
      String chapterContent =
          await ChapterParseUtil().getChapterCotent(element.chapterId ?? "");
      print("getOk");
      // print('执行：10'); // ----> 10. 将计算完的数据发到那边
      send.send(DownChapter(
          idx: element.idx ?? 0,
          chapterId: element.chapterId ?? "",
          chapterContent: chapterContent));
    });
  });
}

class ChapterParseUtil {
  static ChapterParseUtil _instance = ChapterParseUtil._internal();

  factory ChapterParseUtil() => _instance;

  static List<ParseContentConfig>? _configs;
  Future<List<ParseContentConfig>?> get configs async {
    if (_configs == null) {
      List rules = LocalStorage().getJSON("rules");
      _configs = rules
          .map((e) => ParseContentConfig.fromJson(e))
          .toList()
          .cast<ParseContentConfig>();
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

  ParseContentConfig.fromJson(Map<String, dynamic> json) {
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
