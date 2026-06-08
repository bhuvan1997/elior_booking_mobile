class EditProfileModel {
  bool? status;
  String? message;
  int? id;
  String? name;
  String? email;
  String? mobileCode;
  String? mobile;
  String? gender;
  String? dob;
  String? maritalStatus;
  String? address;
  String? country;
  String? district;
  String? city;
  String? postalCode;
  String? documentType;
  String? documentNumber;
  String? expiryDate;
  String? issuingCountry;
  String? profileImage;
  String? passportImg;

  EditProfileModel(
      {this.status,
        this.message,
        this.id,
        this.name,
        this.email,
        this.mobileCode,
        this.mobile,
        this.gender,
        this.dob,
        this.maritalStatus,
        this.address,
        this.country,
        this.district,
        this.city,
        this.postalCode,
        this.documentType,
        this.documentNumber,
        this.expiryDate,
        this.issuingCountry,
        this.profileImage,
        this.passportImg});

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileCode = json['mobile_code'];
    mobile = json['mobile'];
    gender = json['gender'];
    dob = json['dob'];
    maritalStatus = json['marital_status'];
    address = json['address'];
    country = json['country'];
    district = json['district'];
    city = json['city'];
    postalCode = json['postal_code'];
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    expiryDate = json['expiry_date'];
    issuingCountry = json['issuing_country'];
    profileImage = json['profile_image'];
    passportImg = json['passport_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_code'] = this.mobileCode;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['marital_status'] = this.maritalStatus;
    data['address'] = this.address;
    data['country'] = this.country;
    data['district'] = this.district;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['document_type'] = this.documentType;
    data['document_number'] = this.documentNumber;
    data['expiry_date'] = this.expiryDate;
    data['issuing_country'] = this.issuingCountry;
    data['profile_image'] = this.profileImage;
    data['passport_img'] = this.passportImg;
    return data;
  }
}
