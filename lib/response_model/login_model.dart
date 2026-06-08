class LoginModel {
  bool? status;
  String? message;
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? role;
  String? dob;
  String? address;
  String? token;
  String? mobileCode;
  String? gender;
  String? maritalStatus;
  String? country;
  String? district;
  String? city;
  String? postalCode;
  String? passportNumber;
  String? expiryDate;
  String? issuingCountry;
  String? profileImage;
  String? passportImg;
  String? createdAt;
  String? updatedAt;

  LoginModel(
      {this.status,
        this.message,
        this.id,
        this.name,
        this.email,
        this.mobile,
        this.role,
        this.dob,
        this.address,
        this.token,
        this.mobileCode,
        this.gender,
        this.maritalStatus,
        this.country,
        this.district,
        this.city,
        this.postalCode,
        this.passportNumber,
        this.expiryDate,
        this.issuingCountry,
        this.profileImage,
        this.passportImg,
        this.createdAt,
        this.updatedAt});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    role = json['role'];
    dob = json['dob'];
    address = json['address'];
    token = json['token'];
    mobileCode = json['mobile_code'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    country = json['country'];
    district = json['district'];
    city = json['city'];
    postalCode = json['postal_code'];
    passportNumber = json['passport_number'];
    expiryDate = json['expiry_date'];
    issuingCountry = json['issuing_country'];
    profileImage = json['profile_image'];
    passportImg = json['passport_img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['token'] = this.token;
    data['mobile_code'] = this.mobileCode;
    data['gender'] = this.gender;
    data['marital_status'] = this.maritalStatus;
    data['country'] = this.country;
    data['district'] = this.district;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['passport_number'] = this.passportNumber;
    data['expiry_date'] = this.expiryDate;
    data['issuing_country'] = this.issuingCountry;
    data['profile_image'] = this.profileImage;
    data['passport_img'] = this.passportImg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
