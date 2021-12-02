import 'package:novel/utils/chapter_parse.dart';
import 'package:novel/utils/local_storage.dart';
import 'package:novel/utils/request.dart';

class SystemApi {
  Future<void> getConfigs() async {
    var res = await Request().get("/book/config");
    var d = await parseJson(res['data']);

    List rules = d['rules'];
    Map fonts = d['fonts'];

    List<ParseContentConfig> configs =
        rules.map((e) => ParseContentConfig.fromJson(e)).toList();
    LocalStorage().setJSON("rules", configs);
    LocalStorage().setJSON("fonts", fonts);
  }
}
