import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/pages/search/search_model.dart';
import 'package:novel/utils/request.dart';

class ListenApi {
  static String host = "http://m.tingshubao.com";

  static var random = new Random();

  Future<int?> checkSite(String sk) async {
    var res = await Request().getBase(host);
    print(res);
    return res;
  }

  Future<List<Search>?> search(String keyword) async {
    if (keyword.isEmpty) return null;

    var res = await Request().postForm1("$host/search.asp",
        params:
            "searchword=${Uri.encodeQueryComponent(keyword, encoding: gbk)}");
    Document document = parse(res);

    List<Element> es = document.querySelectorAll(".book-li");
    var result = es
        .map(
          (e) => Search(
            id: e
                .querySelector("a")!
                .attributes['href']
                .toString()
                .split("/")[2]
                .split(".")[0],
            cover: 'http://m.tingshubao.com' +
                e
                    .getElementsByClassName("book-cover")[0]
                    .attributes['data-original']
                    .toString(),
            title: e
                .getElementsByClassName("book-cover")[0]
                .attributes['alt']
                .toString(),
            desc: e.getElementsByClassName('book-desc')[0].text,
            bookMeta: e.getElementsByClassName('book-meta')[0].text,
          ),
        )
        .toList();
    return result;
  }

  Future<int> getChapters(String bookId) async {
    var res = await Request().get("$host/book/$bookId.html",
        options: Options(headers: {"User-Agent": random.nextInt(36)}));
    Document document = parse(res);

    return document.querySelector("#playlist>ul")!.children.length;
  }

  Future<String> chapterUrl(String? chapterLink) async {
    var link = "$chapterLink";
    print(link);
    var res = await Request().get(link);
    Document document = parse(res);
    Element? e;
    document.querySelectorAll("head>script").forEach((element) {
      if (element.text.contains('datas')) {
        e = element;
      }
    });
    var text = e!.text;
    var target = text.split(";")[0];
    var s = target.split("(")[2].split(")")[0];
    s = s.substring(2, s.length - 1);
    var charList = s.split('*');
    int len = charList.length;
    var str = '';
    for (int i = 0; i < len; i++) {
      try {
        var code = int.parse(charList[i]);
        if (charList[i].startsWith('-')) {
          code = code & 0xffff;
        }
        str += String.fromCharCode(code);
      } catch (e) {
        print(e);
      }
    }
    print("key url:$str");
    var keys = str.split("&");
    if (keys[2] == 'tudou') {
      return str;
    } else if (keys[2] == 'm4a') {
      {
        return keys[0];
      }
    } else {
      var re = await Request()
          .get("http://43.129.176.64/player/key.php?url=" + keys[0]);
      print(re);
      var url = jsonDecode(re)['url'];
      print(url);
      return Uri.encodeFull(url);
    }
  }

  Future<List<TopRank>> rank(String ss) async {
    var res = await Request().get('$host/top.html');
    Document document = parse(res);
    List<TopRank> result = [];
    document.getElementsByClassName("list-li").forEach((element) {
      result.add(TopRank(
          id: element.querySelector(">a")!.attributes['href'].toString(),
          name: element.querySelector(" figcaption > a")!.text,
          cover: element
              .querySelector("a>img")!
              .attributes['data-original']
              .toString(),
          cast: element.querySelector(">p>a")?.text));
      print('aa');
    });
    return result;
  }
}
