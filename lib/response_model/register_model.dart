class RegisterModel {
  bool? status;
  String? message;
  String? otp;
  String? token;

  RegisterModel({this.status, this.message, this.otp, this.token});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['otp'] = this.otp;
    data['token'] = this.token;
    return data;
  }
}
