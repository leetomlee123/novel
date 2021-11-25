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
}
