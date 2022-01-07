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
  int? position;

  ListenSearchModel(
      {this.id,
      this.title,
      this.idx,
      this.position,
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
    position = json['position'];
    transmit = json['transmit'];
    picture = json['picture'];
    addtime = json['addtime'];
    isFinished = json['isFinished'];
    htitle = json['htitle'];
    authorUrl = json['authorUrl'];
    transUrl = json['transUrl'];
    url = json['url'];
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
    data['position'] = this.position;

    
    return data;
  }
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
