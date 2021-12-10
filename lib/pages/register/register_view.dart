import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/components/components.dart';

import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(title: "注册"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Center(
          child: Form(
            key: controller.key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.phone,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: '账号',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.person)),
                  onChanged: (String value) {
                    controller.registerModel.name = value;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "请输入账号";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: '密码',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.lock)),
                  onChanged: (String value) {
                    controller.registerModel.pwd = value;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "请输入密码";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: '重复密码',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.repeat)),
                  onChanged: (String value) {
                    controller.registerModel.repeatPWd = value;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "请再次输入密码";
                    }
                    if (controller.registerModel.pwd != v) {
                      return "两次输入密码不一致";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: '邮箱 找回密码的唯一凭证,请谨慎输入...',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.email)),
                  onChanged: (String value) {
                    controller.registerModel.email = value;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "请输入邮箱";
                    }
                    if (!v.isEmail) {
                      return "邮箱地址不合法";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                OutlinedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(330, 45))),
                  onPressed: () => controller.register(),
                  child: Text(
                    "注 册",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
