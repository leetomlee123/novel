class MovieSearchModel {
  String? cover;
  String? id;
  String? name;

  MovieSearchModel({this.cover, this.id, this.name});

  MovieSearchModel.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover'] = this.cover;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}