import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/utils/request.dart';

class ListenApi {
  static String host = "https://ting55.com";

  Future<List<ListenSearchModel>?> search(String keyword) async {
    if (keyword.isEmpty) return null;
    var res = await Request().get("$host/s/$keyword");

    List data = jsonDecode(res)['data'];
    return data.map((e) => ListenSearchModel.fromJson(e)).toList();
  }

  Future<List<Item>> getChapters(String bookId) async {
    var res = await Request()
        .get("$host/book/$bookId", options: Options(headers: {"": ""}));
    Document document = parse(res);

    List<Element> es = document.querySelectorAll(".f");
    return es
        .map((e) =>
            Item(link: e.attributes['href'].toString(), title: e.innerHtml))
        .toList();
  }

  Future<String> chapterUrl(String chapterLink, int? bookId, int? idx) async {
    // var res11 = await Request().get(
    //   "http://134.175.83.19:8012/listen/chapter/$bookId${idx! + 1}",
    // );
    // if (res11.toString().isNotEmpty) return res11;
    var link = "$host$chapterLink";
    print(link);
    var res = await Request().get(link);
    Document document = parse(res);

    Element? e1 = document.querySelector("meta[name='_c']");
    String xt = e1!.attributes['content'].toString();
    Element? e2 = document.querySelector("meta[name='_l']");
    String l = e2!.attributes['content'].toString();
    Element? e3 = document.querySelector("meta[name='_cp']");
    String cp = e3!.attributes['content'].toString();
    print(xt);
    var res1 = await Request().post("$host/nlinka",
        params: {"bookId": bookId, "isPay": 0, "page": cp},
        options: Options(headers: {
          "Referer": link,
          'Host': 'ting55.com',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          "Origin": host,
          "xt": xt,
          "l": l,
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62",
        }),
        useToken: false);
    var data = jsonDecode(res1);
    String url = data['ourl'];
    if (url.isEmpty) {
      url = data['url'];
    }
    // if (url.isNotEmpty) {
    //   Request().post("http://134.175.83.19:8012/listen/chapter",
    //       params: {"key": "$bookId$cp", "url": url});
    // }
    return url;
  }

}
