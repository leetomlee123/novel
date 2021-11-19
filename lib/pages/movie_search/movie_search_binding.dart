import 'package:get/get.dart';
import 'movie_search_controller.dart';

class MovieSearchBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<MovieSearchController>(() => MovieSearchController());
    }
}
