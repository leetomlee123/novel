class UserProfileModel {
  String? username;
  String? email;
  String? token;
  String? pwd;
  String? iconPath;

  UserProfileModel(
      {this.username, this.email, this.token, this.pwd, this.iconPath});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    token = json['token'];
    pwd = json['pwd'];
    iconPath = json['iconPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['token'] = this.token;
    data['pwd'] = this.pwd;
    data['iconPath'] = this.iconPath;
    return data;
  }
}
