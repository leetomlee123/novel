import 'package:novel/utils/request.dart';

import '../utils/update_app.dart';

class SystemApi {
  Future<AppInfo> updateApp() async {
    var res = await Request().get("/update");

    return AppInfo.fromJson(res['data']);
  }
}
