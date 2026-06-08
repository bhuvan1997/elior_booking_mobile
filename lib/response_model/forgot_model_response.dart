class ForgotModel {
  bool? status;
  String? message;
  int? id;

  ForgotModel({this.status, this.message, this.id});

  ForgotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['id'] = this.id;
    return data;
  }
}
