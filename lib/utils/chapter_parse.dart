// 必须是顶层函数
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
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

class ChapterParseUtil {
  static ChapterParseUtil _instance = ChapterParseUtil._internal();

  factory ChapterParseUtil() => _instance;

  List<ParseContentConfig>? _configs;
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
