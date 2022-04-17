// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:charset_converter/charset_converter.dart';
import 'package:fast_gbk/fast_gbk.dart';

void main() {
//gbk encode
//   List<int> gbkCodes = gbk.encode('凡人');
  String hex = '';
//   gbkCodes.forEach((i) {hex += i.toRadixString(16);});
//   print(hex);

  //gbk_bytes encode
  // List<int> gbk_byteCodes = gbk.encode('1');
  // hex = '';
  // gbk_byteCodes.forEach((i) {hex +='%'+ i.toRadixString(16);});
  // print(hex);
 CharsetConverter.encode("GB2312", "1");
}
