import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/components/components.dart';
import 'package:novel/pages/Index/Index_controller.dart';
import 'package:novel/utils/update_app.dart';

class AppMenuPage extends GetView<IndexController> {
  const AppMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
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
                          child: Text(ReadSetting.lawWarn
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
            ImageIcon(AssetImage("images/fe.png")),
            '意见反馈',
            () {
              // locator<TelAndSmsService>()
              //     .sendEmail('leetomlee123@gmail.com');
            },
          ),
          getItem(
            ImageIcon(AssetImage("images/upgrade.png")),
            '应用更新',
            () async {
              UpdateAppUtil.checkUpdate();
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
            ImageIcon(AssetImage("images/ab.png")),
            '关于',
            () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(('清阅揽胜')),
                        content: Text(
                          ReadSetting.poet,
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
          const SizedBox(
            height: 200,
          ),
          Obx(
            () => Offstage(
                offstage: controller.userProfileModel.value!.token!.isEmpty,
                child: OutlinedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(330, 45))),
                  onPressed: () => controller.dropAccountOut(),
                  child: Text("退出登录"),
                )),
          ),
        ],
      ),
    );
    // return Stack(
    //   children: [
    //     _buildHeader(),
    //     // Container(
    //     //   margin: const EdgeInsets.only(top: 280),
    //     //   decoration: BoxDecoration(
    //     //       borderRadius: BorderRadius.horizontal(
    //     //           left: Radius.circular(20.0), right: Radius.circular(20.0)),
    //     //       color: Colors.yellowAccent),
    //     // )
    //   ],
    // );
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
                        style: TextStyle(color: Colors.white),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        onTap: fun,
        leading: imageIcon,
        style: ListTileStyle.drawer,
        title: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          size: 17,
        ),
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

  Widget _buildHeader() {
    return Obx(() => Theme(
          data: ThemeData(
              iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white))),
          child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)),color: Colors.white),
            height: 300,
            // width: Get.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExtendedNetworkImageProvider(
                        controller.darkModel.value
                            ? 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0611%252F4069030cj00qujl4t001ic000hs00quc.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1645844294&t=3fa3649ce54f0c420f6ce67486e2a068'
                            : "https://img1.baidu.com/it/u=1319713773,2074606622&fm=253&fmt=auto&app=138&f=JPG?w=889&h=500",
                        cache: true),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                _buildAppBar(),
                const SizedBox(
                  height: 60,
                ),
                Visibility(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      _headImg(),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.userProfileModel.value!.username ?? "",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            controller.userProfileModel.value!.email ?? "",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    onTap: () => controller.toLogin(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
