class TripModel {
  bool? status;
  String? message;
  List<Data>? data;

  TripModel({this.status, this.message, this.data});

  TripModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? name;
  String? description;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  int? starRating;
  String? currency;
  int? pricePerNight;
  String? checkInTime;
  String? checkOutTime;
  List<String>? images;

  Data(
      {this.id,
        this.name,
        this.description,
        this.address,
        this.city,
        this.state,
        this.country,
        this.zipcode,
        this.starRating,
        this.currency,
        this.pricePerNight,
        this.checkInTime,
        this.checkOutTime,
        this.images});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
    starRating = json['star_rating'];
    currency = json['currency'];
    pricePerNight = json['price_per_night'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zipcode'] = this.zipcode;
    data['star_rating'] = this.starRating;
    data['currency'] = this.currency;
    data['price_per_night'] = this.pricePerNight;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['images'] = this.images;
    return data;
  }
}
