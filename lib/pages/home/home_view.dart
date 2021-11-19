import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/app_menu/app_menu_view.dart';
import 'package:novel/pages/home/home_controller.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert_sharp),
              onPressed: () {},
            )
          ],
          centerTitle: true,
          title: Text("书架"),
          leading: IconButton(
              icon: Icon(Icons.person),
              onPressed: () => scaffoldKey.currentState!.openDrawer()),
        ),
        drawer: Drawer(
          child: AppMenuPage(),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Obx(() => controller.shelf.isNotEmpty
                ? controller.cover.value
                    ? _buildCoverModel()
                    : _buildListModel()
                : Container())));
  }

  Widget _buildCoverModel() {
    return WaterfallFlow.builder(
        itemCount: controller.shelf.length,
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 30.0,
        ),
        itemBuilder: (itemBuilder, i) {
          var data = controller.shelf[i];
          return Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(3)),
                clipBehavior: Clip.antiAlias,
                child: _buildBookCover(data, i),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  data.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        });
  }

  Widget _buildBookCover(ShelfModel shelfModel, int i) {
    return Stack(
      children: <Widget>[
        CommonImg(shelfModel.img ?? "",aspect: .85,),
        Offstage(
          offstage: shelfModel.update != 1,
          child: Container(
            // color: Colors.red,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'images/h6.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
        // Visibility(
        //   visible: this.type == "sort",
        //   child: Container(
        //     height: this.height,
        //     width: this.width,
        //     child: Align(
        //         alignment: Alignment.bottomRight,
        //         child: Image.asset(
        //           'images/pick.png',
        //           width: 30,
        //           height: 30,
        //           color: !shelf.picks(this.idx)
        //               ? Colors.white
        //               : Theme.of(context).primaryColor,
        //         )),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildListModel() {
    return Container();
  }

  void tapAction() {}
}
