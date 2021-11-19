import 'package:novel/pages/find_password/find_password_model.dart';
import 'package:novel/pages/login/login_model.dart';
import 'package:novel/pages/register/register_model.dart';
import 'package:novel/utils/request.dart';

/// 用户
class UserAPI {
  Future<UserProfileModel> login(UserProfileModel? userProfileModel) async {
    var res = await Request().postForm("/login", params: {
      "name": userProfileModel!.username,
      "password": userProfileModel.pwd
    });
    return UserProfileModel.fromJson(res['data']);
  }

  Future<dynamic> modifyPassword(FindPasswordModel? findPasswordModel) async {
    var res = await Request().patch("/password", params: {
      "name": findPasswordModel!.account,
      "password": findPasswordModel.newPwd,
      "email": findPasswordModel.email
    });
    return res;
  }

  Future<dynamic> register(RegisterModel? registerModel) async {
    var res = await Request().post("/register", params: {
      "name": registerModel!.name,
      "password": registerModel.pwd,
      "email": registerModel.email
    });
    return res;
  }
}
