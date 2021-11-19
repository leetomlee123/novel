import 'package:get/get.dart';
import 'movie_controller.dart';

class MovieBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<MovieController>(() => MovieController());
    }
}
