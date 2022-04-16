import 'package:common_utils/common_utils.dart';

class Chapter {
  String? cover;
  String? bookMeta;
}

class Search {
  String? id;
  String? cover;
  String? bookMeta;
  String? title;
  String? desc;
  String? url;
  int? idx;
  int? count;
  Duration? position;
  Duration? duration;
  Search({
    this.id,
    this.desc,
    this.url = '',
    this.bookMeta,
    this.cover,
    this.title,
    this.idx = 0,
    this.count = 0,
    this.position = Duration.zero,
    this.duration = const Duration(seconds: 1),
  });

  Search.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'].toString();
    title = json['title'];
    url = json['url'];
    bookMeta = json['bookMeta'];
    idx = json['idx'];
    position = Duration(milliseconds: json['position'] ?? 0);
    duration = Duration(seconds: json['duration'] ?? 1);
    cover = json['cover'];
    count = json['count'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookMeta'] = this.bookMeta;
    data['url'] = this.url;
    data['idx'] = this.idx ?? 0;
    data['cover'] = this.cover;
    data['position'] = this.position!.inMilliseconds;
    data['duration'] = this.duration?.inSeconds ?? 1;
    data['count'] = this.count;
    data['title'] = this.title;
    return data;
  }
}

class ListenSearchModel {
  int? id;
  String? title;
  String? author;
  String? transmit;
  String? picture;
  int? addtime;
  int? isFinished;
  String? htitle;
  String? authorUrl;
  String? transUrl;
  String? url;
  int? idx;
  int? count;
  Duration? position;
  Duration? duration;

  ListenSearchModel(
      {this.id,
      this.title,
      this.idx = 0,
      this.count = 0,
      this.position = Duration.zero,
      this.duration = const Duration(seconds: 1),
      this.author,
      this.transmit,
      this.picture,
      this.addtime,
      this.isFinished,
      this.htitle,
      this.authorUrl,
      this.transUrl,
      this.url});

  ListenSearchModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    idx = json['idx'];
    position = Duration(milliseconds: json['position'] ?? 0);
    duration = Duration(seconds: json['duration'] ?? 1);
    transmit = json['transmit'];
    picture = json['picture'];
    addtime = json['addtime'];
    isFinished = json['isFinished'];
    htitle = json['htitle'];
    authorUrl = json['authorUrl'];
    transUrl = json['transUrl'];
    url = json['url'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['idx'] = this.idx;
    data['author'] = this.author;
    data['transmit'] = this.transmit;
    data['picture'] = this.picture;
    data['addtime'] = this.addtime;
    data['isFinished'] = this.isFinished;
    data['htitle'] = this.htitle;
    data['authorUrl'] = this.authorUrl;
    data['transUrl'] = this.transUrl;
    data['url'] = this.url;
    data['position'] = this.position!.inMilliseconds;
    data['duration'] = this.duration!.inMilliseconds;
    return data;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['idx'] = this.idx ?? 0;
    data['author'] = this.author;
    data['transmit'] = this.transmit;
    data['picture'] = this.picture;
    data['url'] = this.url;
    data['position'] = this.position!.inMilliseconds;
    data['duration'] = this.duration?.inSeconds ?? 1;
    data['lasttime'] = DateUtil.getNowDateMs();
    data['addtime'] = this.addtime;
    data['count'] = this.count;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        transmit,
        picture,
        addtime,
        isFinished,
        htitle,
        authorUrl,
        transUrl,
        url,
        idx,
        position,
        duration,
      ];
}

class Item {
  String? title;
  String? link;

  Item({
    this.link,
    this.title,
  });

  Item.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    title = json['title'];

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['link'] = this.link;
      data['title'] = this.title;

      return data;
    }
  }
}
