import 'package:novel/pages/movie/movie_model.dart';
import 'package:novel/services/movie.dart';
import 'package:get/get.dart';

class MovieController extends GetxController {
  final count = 0.obs;
  final initOk = false.obs;
  List<List<MovieModel>> models = [];

  @override
  void onInit() {
    super.onInit();
    MovieApi.index().then((value) {
      models = value;
      initOk.value = true;
    });
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  increment() => count.value++;
}
