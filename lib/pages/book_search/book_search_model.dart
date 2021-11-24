class SearchBookModel {
  String? id;
  String? name;
  String? cName;
  int? rate;
  String? author;
  String? uTime;
  String? desc;
  String? bookStatus;
  String? img;
  String? lastChapter;

  SearchBookModel(
      {this.id,
      this.name,
      this.cName,
      this.rate,
      this.author,
      this.uTime,
      this.desc,
      this.bookStatus,
      this.img,
      this.lastChapter});

  SearchBookModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    cName = json['CName'];
    rate = json['Rate'];
    author = json['Author'];
    uTime = json['UTime'];
    desc = json['Desc'];
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
    data['Desc'] = this.desc;
    data['BookStatus'] = this.bookStatus;
    data['Img'] = this.img;
    data['LastChapter'] = this.lastChapter;
    return data;
  }
}
