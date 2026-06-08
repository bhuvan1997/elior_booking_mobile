class EditProfileModel {
  bool? status;
  String? message;
  Data? data;

  EditProfileModel({this.status, this.message, this.data});

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? mobileCode;
  String? mobile;
  String? dob;
  String? gender;
  String? city;
  String? maritalStatus;
  String? address;
  String? country;
  String? district;
  String? postalCode;
  String? passportNumber;
  String? profileImage;
  String? passportImg;

  Data({
    this.id,
    this.name,
    this.email,
    this.mobileCode,
    this.mobile,
    this.dob,
    this.gender,
    this.city,
    this.maritalStatus,
    this.address,
    this.country,
    this.district,
    this.postalCode,
    this.passportNumber,
    this.profileImage,
    this.passportImg,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileCode = json['mobile_code'];
    mobile = json['mobile'];
    dob = json['dob'];
    gender = json['gender'];
    city = json['city'];
    maritalStatus = json['marital_status'];
    address = json['address'];
    country = json['country'];
    district = json['district'];
    postalCode = json['postal_code'];
    passportNumber = json['passport_number'];
    profileImage = json['profile_image'];
    passportImg = json['passport_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_code'] = this.mobileCode;
    data['mobile'] = this.mobile;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['marital_status'] = this.maritalStatus;
    data['address'] = this.address;
    data['country'] = this.country;
    data['district'] = this.district;
    data['postal_code'] = this.postalCode;
    data['passport_number'] = this.passportNumber;
    data['profile_image'] = this.profileImage;
    data['passport_img'] = this.passportImg;
    return data;
  }
}
