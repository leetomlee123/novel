import 'package:novel/pages/movie/movie_model.dart';
import 'package:novel/utils/utils.dart';

/// 用户
class MovieApi {
  /// 首页
  static Future<List<List<MovieModel>>> index() async {
    var response = await Request().get('/index');
    List data = response;
    return data
        .map((e) => (e as List).map((e1) => MovieModel.fromJson(e1)).toList())
        .toList();
  }



  //search movie
  static Future<List<MovieModel>> searchMovie(var key, int page) async {
    var response = await Request().get('/movies/$key/search/$page/tv');
    List data = response;
    return data.map((e) => MovieModel.fromJson(e)).toList();
  }
}
