import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';
import 'package:novel/components/common_img.dart';
import 'package:novel/pages/book_search/book_search_model.dart';
import 'package:novel/pages/book_search/book_search_view.dart';
import 'package:novel/services/book.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  String? get searchFieldLabel => "搜索";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BookSearchPage();

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
