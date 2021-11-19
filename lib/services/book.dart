import 'package:novel/pages/home/home_model.dart';
import 'package:novel/utils/request.dart';

class BookApi {
  Future<List<ShelfModel>> shelf() async {
    var res = await Request().get("/book/shelf");
    List data = res['data'];
    return data.map((e) => ShelfModel.fromJson(e)).toList();
  }
}
