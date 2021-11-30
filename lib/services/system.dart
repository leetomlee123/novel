import 'package:novel/utils/chapter_parse.dart';
import 'package:novel/utils/request.dart';

class SystemApi {
  Future<List<ParseContentConfig>> getParseContentConfigs() async {
    var res = await Request().get("/book/shelf");
    List data = res['data'];
    return data.map((e) => ParseContentConfig.fromJson(e)).toList();
  }
}
