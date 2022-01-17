import 'package:novel/utils/chapter_parse.dart';
import 'package:novel/utils/request.dart';
import 'package:novel/utils/update_app.dart';
import 'package:sp_util/sp_util.dart';

class SystemApi {
  Future<void> getConfigs() async {
    var res = await Request().get("/book/config");
    var d = await parseJson(res['data']);

    List rules = d['rules'];
    Map fonts = d['fonts'];

    List<ParseContentConfig> configs =
        rules.map((e) => ParseContentConfig.fromJson(e)).toList();
    SpUtil.putObjectList("rules", configs);
    SpUtil.putObject("fonts", fonts);
  }

  Future<AppInfo> updateApp() async {
    var res = await Request().get("/update");

    return AppInfo.fromJson(res['data']);
  }

  Future<String> getProxy({int retry = 5}) async {
    var res = await Request().get('http://134.175.83.19:5010/get/');
    if (res['https']) {
      return res['proxy'];
    }
    if (retry > 0) {
      return getProxy(retry: retry - 1);
    } else {
      return "";
    }
  }
}
