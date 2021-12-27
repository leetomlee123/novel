import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/components/components.dart';
import 'package:novel/pages/Index/Index_controller.dart';

class AppMenuPage extends GetView<IndexController> {
  const AppMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),

              // getItem(
              //   ImageIcon(AssetImage("images/info.png")),
              //   '公告',
              //   () {
              //     // Navigator.of(context).push(MaterialPageRoute(
              //     //     builder: (BuildContext context) => InfoPage()));
              //   },
              // ),
              // getItem(
              //   ImageIcon(AssetImage("images/re.png")),
              //   '免责声明',
              //   () {
              //     showDialog(
              //         context: context,
              //         builder: (context) => AlertDialog(
              //               title: Text(
              //                 '免责声明',
              //               ),
              //               content: SingleChildScrollView(
              //                 child: Text(ReadSetting.lawWarn
              //                     // ReadSetting.lawWarn,""
              //                     ),
              //               ),
              //               actions: <Widget>[
              //                 TextButton(
              //                   child: Text(
              //                     "确定",
              //                   ),
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                 ),
              //               ],
              //             ));
              //   },
              // ),
              // getItem(
              //   ImageIcon(AssetImage("images/skin.png")),
              //   '主题',
              //   () {
              //     // Navigator.of(context).push(MaterialPageRoute(
              //     //     builder: (BuildContext context) => Skin()));
              //   },
              // ),
              // getItem(
              //   ImageIcon(AssetImage("images/fe.png")),
              //   '意见反馈',
              //   () {
              //     // locator<TelAndSmsService>()
              //     //     .sendEmail('leetomlee123@gmail.com');
              //   },
              // ),
              // getItem(
              //   ImageIcon(AssetImage("images/github.png")),
              //   '开源地址',
              //   () {
              //     // launch('https://github.com/leetomlee123/book');
              //   },
              // ),
              // getItem(
              //   ImageIcon(AssetImage("images/upgrade.png")),
              //   '应用更新',
              //   () async {
              //     UpdateAppUtil.checkUpdate();
              //   },
              // ),
              // getItem(
              //   ImageIcon(AssetImage("images/ab.png")),
              //   '关于',
              //   () {
              //     showDialog(
              //         context: context,
              //         builder: (context) => AlertDialog(
              //               title: Text(('清阅揽胜')),
              //               content: Text(
              //                 ReadSetting.poet,
              //                 style: TextStyle(fontSize: 15, height: 2.1),
              //               ),
              //               actions: <Widget>[
              //                 TextButton(
              //                   child: new Text(
              //                     "确定",
              //                   ),
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                 ),
              //               ],
              //             ));
              //   },
              // ),
              // Obx(
              //   () => Offstage(
              //       offstage: controller.userProfileModel.value!.token!.isEmpty,
              //       child: OutlinedButton(
              //         style: ButtonStyle(
              //             minimumSize:
              //                 MaterialStateProperty.all(Size(330, 45))),
              //         onPressed: () => controller.dropAccountOut(),
              //         child: Text("退出登录"),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return buildAppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
        ),
        actions: [
          Obx(() => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.toggleModel();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: controller.darkModel.value
                        ? Colors.white10
                        : Colors.black12,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        controller.darkModel.value
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      SizedBox(height: 1),
                      Text(
                        controller.darkModel.value ? '日间' : '夜间',
                      ),
                    ],
                  ),
                ),
              )),
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () {},
          ),
        ]);
  }

  Widget getItem(imageIcon, text, fun) {
    return ListTile(
      onTap: fun,
      leading: imageIcon,
      title: Text(text),
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        size: 17,
      ),
    );
  }

  Widget _headImg() {
    return Container(
      width: 60,
      height: 60,
      child: CircleAvatar(
        backgroundImage: AssetImage("images/fu.png"),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)),color: Colors.white),
          height: 200,
          child: Visibility(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _headImg(),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.userProfileModel.value!.username ?? "",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      controller.userProfileModel.value!.email ?? "",
                    ),
                  ],
                )
              ],
            ),
            visible: controller.userProfileModel.value!.token!.isNotEmpty,
            replacement: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _headImg(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "登陆/注册",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              onTap: () => controller.toLogin(),
            ),
          ),
        ));
  }
}
