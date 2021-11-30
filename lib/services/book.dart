import 'dart:convert';
import 'dart:math';

import 'package:novel/pages/book_chapters/chapter.pb.dart';
import 'package:novel/pages/book_detail/book_detail_model.dart';
import 'package:novel/pages/book_search/book_search_model.dart';
import 'package:novel/pages/home/home_model.dart';
import 'package:novel/utils/request.dart';

class BookApi {
  Future<List<Book>> shelf() async {
    var res = await Request().get("/book/shelf");
    List data = res['data'];
    return data.map((e) => Book.fromJson(e)).toList();
  }

  Future<List<SearchBookModel>> search(String key, int page) async {
    var res = await Request().get("/book/search?key=$key&page=$page&size=10");
    List data = res['data'] ?? [];

    return data.map((e) => SearchBookModel.fromJson(e)).toList();
  }

  Future<BookDetailModel> detail(String bookId) async {
    var res = await Request().get("/book/detail/$bookId");
    var data = res['data'] ?? {};
    return BookDetailModel.fromJson(data);
  }

  Future<void> modifyShelf(String bookId, String action) async {
    await Request().get("/book/action/$bookId/$action");
  }

  Future<List<ChapterProto>> getChapters(String? bookId, int offset) async {
    var res = await Request()
        .get("/book/proto/chapters/$bookId/$offset/${pow(10, 4)}");
    String data = res['data'];

    var x = base64Decode(data);
    ChaptersProto cps = ChaptersProto.fromBuffer(x);
    return cps.chaptersProto.toList();
  }

  Future<int> getReadRecord(String? userName, String? bookId) async {
    var res = await Request().get("/book/process/$userName/$bookId");
    String data = res['data'];
    if (data.isEmpty) {
      return 0;
    }
    return int.parse(data);
  }

  Future<Map> getContent(String? chapterId) async {
    var res = await Request().get("/book/chapter/$chapterId");
    return res['data'];
  }

  Future<void> updateContent(String? chapterId, String? content) async {
    await Request().patchForm("/book/chapter/content",
        params: {"id": chapterId, "content": content});
  }
}
