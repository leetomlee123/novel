class BookDetailModel {
  String? id;
  String? name;
  String? cName;
  String? author;
  int? hot;
  String? rate;
  String? lastTime;
  String? desc;
  String? bookStatus;
  String? img;
  String? lastChapter;
  int? count;
  List<SameAuthorBooks>? sameAuthorBooks;

  BookDetailModel(
      {this.id,
      this.name,
      this.cName,
      this.author,
      this.hot,
      this.rate,
      this.lastTime,
      this.desc,
      this.bookStatus,
      this.img,
      this.lastChapter,
      this.count,
      this.sameAuthorBooks});

  BookDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    cName = json['CName'];
    author = json['Author'];
    hot = json['Hot'];
    rate =json['Rate'].toString();
    lastTime = json['LastTime'];
    desc = json['Desc'];
    bookStatus = json['BookStatus'];
    img = json['Img'];
    lastChapter = json['LastChapter'];
    count = json['Count'];
    if (json['SameAuthorBooks'] != null) {
      sameAuthorBooks = <SameAuthorBooks>[];
      json['SameAuthorBooks'].forEach((v) {
        sameAuthorBooks!.add(new SameAuthorBooks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['CName'] = this.cName;
    data['Author'] = this.author;
    data['Hot'] = this.hot;
    data['Rate'] = this.rate;
    data['LastTime'] = this.lastTime;
    data['Desc'] = this.desc;
    data['BookStatus'] = this.bookStatus;
    data['Img'] = this.img;
    data['LastChapter'] = this.lastChapter;
    data['Count'] = this.count;
    if (this.sameAuthorBooks != null) {
      data['SameAuthorBooks'] =
          this.sameAuthorBooks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SameAuthorBooks {
  String? id;
  String? name;
  String? cName;
  int? rate;
  String? author;
  String? uTime;
  String? bookStatus;
  String? img;
  String? lastChapter;

  SameAuthorBooks(
      {this.id,
      this.name,
      this.cName,
      this.rate,
      this.author,
      this.uTime,
      this.bookStatus,
      this.img,
      this.lastChapter});

  SameAuthorBooks.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    cName = json['CName'];
    rate = json['Rate'];
    author = json['Author'];
    uTime = json['UTime'];
    bookStatus = json['BookStatus'];
    img = json['Img'];
    lastChapter = json['LastChapter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['CName'] = this.cName;
    data['Rate'] = this.rate;
    data['Author'] = this.author;
    data['UTime'] = this.uTime;
    data['BookStatus'] = this.bookStatus;
    data['Img'] = this.img;
    data['LastChapter'] = this.lastChapter;
    return data;
  }
}
