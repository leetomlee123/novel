import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/router/app_pages.dart';

import 'book_search_controller.dart';

class BookSearchPage extends GetView<BookSearchController> {
  const BookSearchPage({Key? key}) : super(key: key);
  final itemHeight = 90 / .8;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: appBarTheme(context),
        child: Scaffold(
            appBar: _buildSearchBar(),
            body: Obx(
              () => controller.books.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: LoadMore(
                        isFinish: controller.isFinish.value,
                        onLoadMore: controller.loadMore,
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int i) {
                            return _buildSearchItem(i);
                          },
                          itemCount: controller.count,
                          itemExtent: itemHeight + 5,
                        ),
                        whenEmptyLoad: false,
                        delegate: DefaultLoadMoreDelegate(),
                        textBuilder: DefaultLoadMoreTextBuilder.chinese,
                      ),
                    ),
            )));
  }

  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.inputDecorationTheme.hintStyle,
        border: InputBorder.none,
      ),
    );
  }

  AppBar _buildSearchBar() {
    return AppBar(
      title: TextField(
          autofocus: true,
          onSubmitted: (v) => controller.search(v),
          controller: controller.textEditingController,
          decoration: InputDecoration(
              hintText: "书名/作者名",
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => controller.clear(),
              ))),
    );
  }

  Widget _buildSearchItem(int i) {
    var book = controller.books[i];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.toNamed(AppRoutes.BookDetail, arguments: {"bookId": book.id});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: itemHeight,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  book.name ?? "",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 11),
                  maxLines: 2,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
