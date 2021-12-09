import 'package:get/get.dart';
import 'book_city_controller.dart';

class BookCityBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<BookCityController>(() => BookCityController());
    }
}
