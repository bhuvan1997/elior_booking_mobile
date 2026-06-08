class TopHotelModel {
  bool? status;
  String? message;
  List<Data>? data;
  String? token;

  TopHotelModel({this.status, this.message, this.data, this.token});

  TopHotelModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  int? merchantId;
  String? name;
  String? slug;
  String? description;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? latitude;
  String? longitude;
  String? phone;
  String? email;
  String? website;
  int? starRating;
  String? checkInTime;
  String? checkOutTime;
  String? facilities;
  List<String>? images;
  String? status;

  Data(
      {this.merchantId,
        this.name,
        this.slug,
        this.description,
        this.address,
        this.city,
        this.state,
        this.country,
        this.zipcode,
        this.latitude,
        this.longitude,
        this.phone,
        this.email,
        this.website,
        this.starRating,
        this.checkInTime,
        this.checkOutTime,
        this.facilities,
        this.images,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchant_id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
    starRating = json['star_rating'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    facilities = json['facilities'];
    images = json['images'].cast<String>();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchant_id'] = this.merchantId;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zipcode'] = this.zipcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['website'] = this.website;
    data['star_rating'] = this.starRating;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['facilities'] = this.facilities;
    data['images'] = this.images;
    data['status'] = this.status;
    return data;
  }
}
