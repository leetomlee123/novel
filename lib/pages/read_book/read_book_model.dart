class ReadPage {
  List<TextPage>? pages;
  String? chapterContent;
  double? height;
  String? chapterName;
}

class TextPage {
  double? height;
  List<Lines>? lines;

  TextPage({this.height, this.lines});

  TextPage.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    if (json['lines'] != null) {
      lines = <Lines>[];
      json['lines'].forEach((v) {
        lines!.add(new Lines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    if (this.lines != null) {
      data['lines'] = this.lines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lines {
  String? text;
  double? dy;
  double? dx;
  double? spacing;
  justifyDy(double offsetDy) {
    dy = dy ?? .0 + offsetDy;
  }

  Lines({this.text, this.dy, this.dx, this.spacing});

  Lines.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    dy = json['dy'];
    dx = json['dx'];
    spacing = json['spacing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['dy'] = this.dy;
    data['dx'] = this.dx;
    data['spacing'] = this.spacing;
    return data;
  }
}
