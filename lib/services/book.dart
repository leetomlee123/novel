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
    print(page);
    var res = await Request().get("/book/search?key=$key&page=$page&size=10");
    List data = res['data'] ?? [];

    return data.map((e) => SearchBookModel.fromJson(e)).toList();
  }
}
