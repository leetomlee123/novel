import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/Index/Index_controller.dart';

class AppMenuPage extends GetView<IndexController> {
  const AppMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: kToolbarHeight),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildHeader(context),
                ),
                Divider(),
                getItem(
                  ImageIcon(AssetImage("images/info.png")),
                  '公告',
                  () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (BuildContext context) => InfoPage()));
                  },
                ),
                getItem(
                  ImageIcon(AssetImage("images/re.png")),
                  '免责声明',
                  () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                '免责声明',
                              ),
                              content: SingleChildScrollView(
                                child: Text("lawWarn"
                                    // ReadSetting.lawWarn,""
                                    ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "确定",
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                ),
                getItem(
                  ImageIcon(AssetImage("images/skin.png")),
                  '主题',
                  () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (BuildContext context) => Skin()));
                  },
                ),
                getItem(
                  ImageIcon(AssetImage("images/fe.png")),
                  '意见反馈',
                  () {
                    // locator<TelAndSmsService>()
                    //     .sendEmail('leetomlee123@gmail.com');
                  },
                ),
                getItem(
                  ImageIcon(AssetImage("images/github.png")),
                  '开源地址',
                  () {
                    // launch('https://github.com/leetomlee123/book');
                  },
                ),
                getItem(
                  ImageIcon(AssetImage("images/upgrade.png")),
                  '应用更新',
                  () async {
                    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    // String version = packageInfo.version;

                    // Response response =
                    //     await HttpUtil.instance.dio.get(Common.update);
                    // var data = response.data['data'];
                    // AppInfo appInfo = AppInfo.fromJson(data);
                    // if (int.parse(appInfo.version.replaceAll(".", "")) >
                    //     int.parse(version.replaceAll(".", ""))) {
                    //   Navigator.pop(context);
                    //   Future.delayed(Duration(milliseconds: 400), () {
                    //     var up = UpdateEntity(
                    //         hasUpdate: true,
                    //         isForce: appInfo.forceUpdate == "2",
                    //         isIgnorable: false,
                    //         versionCode: 1,
                    //         versionName: appInfo.version,
                    //         updateContent: appInfo.msg,
                    //         downloadUrl: appInfo.link,
                    //         apkSize: int.parse(appInfo.apkSize),
                    //         apkMd5: appInfo.apkMD5);

                    //     FlutterXUpdate.updateByInfo(
                    //       updateEntity: up,
                    //       supportBackgroundUpdate: true,
                    //     );
                    //   });
                    // } else {
                    //   BotToast.showText(text: "暂无更新");
                    // }
                  },
                ),
                getItem(
                  ImageIcon(AssetImage("images/ab.png")),
                  '关于',
                  () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(('清阅揽胜')),
                              content: Text(
                                "ReadSetting.poet",
                                style: TextStyle(fontSize: 15, height: 2.1),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text(
                                    "确定",
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                ),
              ],
            ),
            Obx(()=>
            Positioned(
              bottom: 1,
              left: 10,
              right: 10,
              child: Offstage(
                  offstage: controller.userProfileModel.value!.token!.isEmpty,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(330, 45))),
                    onPressed: () => controller.dropAccountOut(),
                    child: Text("退出登录"),
                  )),
            ),),
          ],
        ),
      ),
    );
  }

  Widget getItem(imageIcon, text, fun) {
    return ListTile(
      onTap: fun,
      leading: imageIcon,
      title: Text(text),
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
    return Obx(() => Visibility(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headImg(),
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
        ));
  }
}
