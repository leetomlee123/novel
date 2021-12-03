part of 'app_pages.dart';

abstract class AppRoutes {
  //system
  static const Index = '/index';
  static const Home = '/home';
  static const Login = '/login';
  static const Register = '/register';
  static const FindPassword = '/findPassword';
  //book
  static const Shelf = '/shelf';
  static const ReadBook = '/readBook';
  static const SearchBook = '/searchBook';
  static const BookDetail = '/bookDetail';
  static const BookMenu = '/bookMenu';
  static const FontSet = '/fontSet';

  //moive
  static const Movie = '/movie';
  static const MovieDetail = '/detail';
  static const MoviePlayer = '/player';
  // notfound
  static const NotFound = '/notfound';

  // setproxy
  static const Proxy = '/proxy';
}
