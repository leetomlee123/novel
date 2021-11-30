class ChapterModel {
  String? chapterId;
  String? bookId;
  String? content;

  ChapterModel({this.chapterId, this.bookId, this.content});

  ChapterModel.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    bookId = json['bookId'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapterId'] = this.chapterId;
    data['bookId'] = this.bookId;
    data['content'] = this.content;
    return data;
  }
}
