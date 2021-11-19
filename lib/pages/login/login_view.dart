import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/router/app_pages.dart';

import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            _buildLogo(),
            _buildTitle(),
            _buildLogin(),
            _buildThirdLogin()
          ],
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: Screen.topSafeHeight + 5),
      )),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        radius: 60,
        backgroundImage: const AssetImage("images/login.jpg"),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Center(child: Text('即刻追书')),
    );
  }

  Widget _buildLogin() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: controller.key,
        child: Column(
          children: [
            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                  hintText: '账号',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  prefixIcon: Icon(Icons.person)),
              onChanged: (String value) {
                controller.userProfileModel!.username = value;
              },
              validator: (v) {
                if (v!.isEmpty) {
                  return "请输入账号";
                }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: '密码',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
              onChanged: (String value) {
                controller.userProfileModel!.pwd = value;
              },
              validator: (v) {
                if (v!.isEmpty) {
                  return "请输入密码";
                }
                return null;
              },
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  // shape: MaterialStateProperty.all(C.all(22.0)),
                  // shape: MaterialStateProperty.all(BorderRadius.all(const Radius.circular(22.0))),
                  minimumSize: MaterialStateProperty.all(Size(330, 45))),
              onPressed: () => controller.login(),
              child: Text(
                "登 陆",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                height: 10,
                color: Colors.black,
                endIndent: 12,
                indent: 5,
              ),
            ),
            Text(
              "其他账号登录",
              style: TextStyle(fontSize: 12),
            ),
            Expanded(
              child: Divider(
                height: 10,
                color: Colors.black,
                endIndent: 5,
                indent: 12,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: CircleAvatar(
                backgroundImage: const AssetImage("images/google-logo.jpg"),
                backgroundColor: Colors.white,
              ),
              onTap: () => controller.googleLogin(),
            ),
            GestureDetector(
              child: CircleAvatar(
                backgroundImage: const AssetImage("images/github.png"),
                backgroundColor: Colors.white,
              ),
              onTap: () => controller.githubLogin(),
            ),
          ],
        ),
        Row(
          key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              child: Text(
                '忘记密码',
                // style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.FindPassword);
              },
            ),
            SizedBox(
              width: 30,
            ),
            TextButton(
              child: Text(
                '注册',
                // style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.Register);
              },
            ),
          ],
        ),
      ],
    );
  }
}
