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
    SpUtil.putObject("rules", configs);
    SpUtil.putObject("fonts", fonts);
  }

  Future<AppInfo> updateApp() async {
    var res = await Request().get("/update");

    return AppInfo.fromJson(res['data']);
  }
}
