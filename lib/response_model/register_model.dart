class RegisterModel {
  bool? status;
  String? message;
  String? otp;
  String? token;
  Map<String, List<String>>? errors;

  RegisterModel({this.status, this.message, this.otp, this.token, this.errors});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
    token = json['token'];

    if (json['errors'] != null) {
      errors = (json['errors'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          List<String>.from(value),
        ),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['otp'] = this.otp;
    data['token'] = this.token;
    data['errors']= this.errors;
    return data;
  }
}
