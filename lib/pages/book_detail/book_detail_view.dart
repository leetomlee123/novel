import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/components/loading.dart';
import 'package:novel/router/app_pages.dart';
import 'package:readmore/readmore.dart';

import 'book_detail_controller.dart';

class BookDetailPage extends GetView<BookDetailController> {
  const BookDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => controller.ok.value
          ? Stack(
              children: [
                CustomScrollView(
                  slivers: [_buildSliverAppBar(), _buildSliverBody()],
                ),
                _buildBottom()
              ],
            )
          : LoadingDialog(),
    ));
  }

  Widget _buildSliverAppBar() {
    var topSafeHeight = Screen.topSafeHeight;
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      floating: false,
      expandedHeight: 220,
      actions: [
        TextButton(
            onPressed: () => Get.offNamed(AppRoutes.Index),
            child: Text(
              "书架",
              style: TextStyle(color: Colors.white),
            ))
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: topSafeHeight + 40, bottom: 10),
          child: _buildBookDetail(),
        ),
      ),
    );
  }

  Widget _buildBookDetail() {
    var book = controller.bookDetailModel.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonImg(
          book.img ?? "",
          width: 100,
          aspect: .78,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              book.name ?? "",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            SizedBox(
              height: 6,
            ),
            Text('作者: ${book.author ?? ""}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.white)),
            SizedBox(
              height: 6,
            ),
            Text('类型: ${book.cName ?? ""}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 12, color: Colors.white)),
            SizedBox(
              height: 6,
            ),
            Text('状态: ${book.bookStatus}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 12, color: Colors.white)),
            SizedBox(
              height: 6,
            ),
            RatingBar.builder(
              initialRating: double.parse(book.rate.toString()),
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 23,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.white,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            )
          ],
        ),
      ],
    );
  }

  Widget _buildSliverBody() {
    return SliverList(
        delegate: SliverChildListDelegate([
      _bookDesc(),
      Divider(
        endIndent: 12,
        indent: 12,
      ),
      _bookMenu(),
      Divider(
        endIndent: 12,
        indent: 12,
      ),
      _sameAuthorBooks(),
      const SizedBox(
        height: 200,
      ),
      const Center(
        child: Text('no more data'),
      )
    ]));
  }

  Widget _bookDesc() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "简介",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          ReadMoreText(
            controller.bookDetailModel.value.desc ?? "",
            trimLines: 3,
            colorClickableText: Colors.blue,
            trimMode: TrimMode.Line,
            style:
                TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _bookMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '目录',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          ListTile(
            leading: Container(
              width: 70,
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '最新',
                  )
                ],
              ),
            ),
            title: Text(controller.bookDetailModel.value.lastChapter ?? ""),
          ),
        ],
      ),
    );
  }

  _sameAuthorBooks() {
    var sameAuthorBooks2 =
        controller.bookDetailModel.value.sameAuthorBooks ?? [];
    return sameAuthorBooks2.length == 0
        ? Container()
        : Padding(
            padding: EdgeInsets.only(
                left: 20, right: 20, bottom: Screen.bottomSafeHeight + 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "作品集:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    shrinkWrap: true,
                    itemCount: sameAuthorBooks2.length,
                    itemExtent: 120,
                    itemBuilder: (ctx, i) {
                      var book = sameAuthorBooks2[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            controller.getDetail(book.id ?? "");
                          },
                          child: Row(
                            children: [
                              CommonImg(
                                book.img ?? "",
                                aspect: .8,
                                width: 85,
                                fit: BoxFit.fitWidth,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    book.name ?? "",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
                                  Text(
                                    book.author ?? "",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                    maxLines: 1,
                                  ),
                                  Text(
                                    book.lastChapter ?? "",
                                    style: TextStyle(fontSize: 11),
                                    maxLines: 2,
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          );
  }

  _buildBottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
        ),
        padding: EdgeInsets.only(bottom: Screen.bottomSafeHeight),
        child: Obx(() => ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () => controller.modifyShelf(),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        //执行缩放动画
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: Text(controller.inShelf.value ? "移出书架" : "加入书架"),
                    )),
                TextButton(
                    onPressed: () {
                      if (controller.inShelf.value) {
                        Get.toNamed(AppRoutes.ReadBook, arguments: {
                          "id": controller.bookDetailModel.value.id
                        });
                      } else {
                        Get.toNamed(AppRoutes.ReadBook,
                            arguments: {"bookJson": controller.book!.toJson()});
                      }
                    },
                    child: Text(controller.inShelf.value ? "继续阅读" : "立即阅读")),
              ],
            )),
      ),
    );
  }
}
