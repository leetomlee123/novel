import 'package:common_utils/common_utils.dart';

class HomeModel {}

class Book {
  String? id;
  String? name;
  String? cName;
  int? rate;
  String? author;
  String? uTime;
  String? desc;
  String? bookStatus;
  int? newChapter;
  int? chapterIdx;
  int? pageIdx;
  int? sortTime;
  String? img;
  String? lastChapter;

  Book(
      {this.id,
      this.name,
      this.cName,
      this.rate,
      this.author,
      this.uTime,
      this.newChapter = 0,
      this.chapterIdx = 0,
      this.sortTime,
      this.pageIdx = 0,
      this.desc,
      this.bookStatus,
      this.img,
      this.lastChapter});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    cName = json['CName'];
    rate = json['Rate'];
    author = json['Author'];
    uTime = json['UTime'];
    desc = json['Desc'];
    bookStatus = json['BookStatus'];
    img = json['Img'];
    sortTime = json['sort_time'] ?? DateUtil.getNowDateMs();
    lastChapter = json['LastChapter'];
    newChapter = json['new_chapter'] ?? 0;
    chapterIdx = json['chapter_idx'] ?? 0;
    pageIdx = json['page_idx'] ?? 0;
  }

  Book.fromSql(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cName = json['cname'];
    rate = json['rate'];
    author = json['author'];
    uTime = json['u_time'];
    desc = json['book_desc'];
    bookStatus = json['book_status'];
    img = json['img'];
    sortTime = json['sort_time'] ?? DateUtil.getNowDateMs();
    newChapter = json['new_chapter'] ?? 0;
    chapterIdx = json['chapter_idx'] ?? 0;
    pageIdx = json['page_idx'] ?? 0;
    lastChapter = json['last_chapter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['update'] = this.newChapter;
    data['CName'] = this.cName;
    data['Rate'] = this.rate;
    data['Author'] = this.author;
    data['UTime'] = this.uTime;
    data['Desc'] = this.desc;
    data['BookStatus'] = this.bookStatus;
    data['Img'] = this.img;
    data['LastChapter'] = this.lastChapter;
    return data;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['id'] = id;
    json['name'] = name;
    json['cname'] = cName;
    json['rate'] = rate;
    json['author'] = author;
    json['u_time'] = uTime;
    json['book_desc'] = desc;
    json['book_status'] = bookStatus;
    json['img'] = img;
    json['sort_time'] = sortTime ?? DateUtil.getNowDateMs();
    json['new_chapter'] = newChapter ?? 0;
    json['chapter_idx'] = chapterIdx ?? 0;
    json['page_idx'] = pageIdx ?? 0;
    json['last_chapter'] = lastChapter;
    return json;
  }
}
