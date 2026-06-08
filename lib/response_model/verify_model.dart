class VerifyModel {
  bool? status;
  String? message;
  String? token;
  String? tokenType;

  VerifyModel({this.status, this.message, this.token, this.tokenType});

  VerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['token_type'] = this.tokenType;
    return data;
  }
}
