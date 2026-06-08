class TravelVlogsModel {
  bool? status;
  String? message;
  List<Datam>? data;

  TravelVlogsModel({this.status, this.message, this.data});

  TravelVlogsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Datam>[];
      json['data'].forEach((v) {
        data!.add(new Datam.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datam {
  int? id;
  String? category;
  String? title;
  String? content;
  List<String>? image;
  String? coverImage;

  Datam(
      {this.id,
        this.category,
        this.title,
        this.content,
        this.image,
        this.coverImage});

  Datam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    content = json['content'];
    image = json['image'].cast<String>();
    coverImage = json['cover_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['title'] = this.title;
    data['content'] = this.content;
    data['image'] = this.image;
    data['cover_image'] = this.coverImage;
    return data;
  }
}
