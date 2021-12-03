import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'find_password_controller.dart';

class FindPasswordPage extends GetView<FindPasswordController> {
  const FindPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("忘记密码"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.person)),
                  onChanged: (String value) {
                    controller.findPass.account = value;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "请输入用户名";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: '邮箱',
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.email)),
                  onChanged: (String value) {
                    controller.findPass.email = value;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "请输入邮箱地址";
                    }
                    if (!v.isEmail) {
                      return "请输入正确的邮箱地址";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: '输入新密码',
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.lock)),
                  onChanged: (String value) {
                    controller.findPass.newPwd = value;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "请输入新密码";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  obscureText: true,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: '重复新密码',
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.repeat)),
                  onChanged: (String value) {
                    controller.findPass.repeatPwd = value;
                  },
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "请再次输入新密码";
                    }
                    if (controller.findPass.newPwd != v) {
                      return "两次输入密码不一致";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                OutlinedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(330, 45))),
                  onPressed: () => controller.resetPass(),
                  child: Text(
                    "重置密码",
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
        ),
      ),
    );
  }
}
