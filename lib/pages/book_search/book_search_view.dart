import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';
import 'package:novel/components/common_img.dart';

import 'book_search_controller.dart';

class BookSearchPage extends GetView<BookSearchController> {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
      controller.books.isEmpty ? Container() : LoadMore(
        // isFinish: controller.count >= 60,
        onLoadMore: controller.loadMore,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int i) {
            return _buildSearchItem(i);
          },
          itemCount: controller.count,
        ),
        whenEmptyLoad: false,
        delegate: DefaultLoadMoreDelegate(),
        textBuilder: DefaultLoadMoreTextBuilder.chinese,

      ),
      )
    );
  }

  Widget _buildSearchItem(int i) {
    var book = controller.books[i];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CommonImg(
            book.img ?? "",
            aspect: .8,
            width: 80,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    book.name ?? "",
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
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
                    book.desc ?? "",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 2,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
