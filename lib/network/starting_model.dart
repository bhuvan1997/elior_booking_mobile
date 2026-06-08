class StartingModel {
  String? appLogo;
  String? title;
  String? subtitle;
  List<String>? images;
  String? aboutUs;
  String? noticeBoard;

  StartingModel({
    this.appLogo,
    this.title,
    this.subtitle,
    this.images,
    this.aboutUs,
    this.noticeBoard,
  });

  StartingModel.fromJson(Map<String, dynamic> json) {
    appLogo = json['App Logo '];
    title = json['title '];
    subtitle = json['subtitle'];
    images = json['Images'].cast<String>();
    aboutUs = json['About us'];
    noticeBoard = json['Notice Board'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['App Logo '] = this.appLogo;
    data['title '] = this.title;
    data['subtitle'] = this.subtitle;
    data['Images'] = this.images;
    data['About us'] = this.aboutUs;
    data['Notice Board'] = this.noticeBoard;
    return data;
  }
}
