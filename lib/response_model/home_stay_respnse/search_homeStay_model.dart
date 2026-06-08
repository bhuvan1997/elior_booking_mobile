class SearchHomestayModel {
  bool? status;
  String? message;
  SearchParams? searchParams;
  List<Data>? data;

  SearchHomestayModel(
      {this.status, this.message, this.searchParams, this.data});

  SearchHomestayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    searchParams = json['search_params'] != null
        ? new SearchParams.fromJson(json['search_params'])
        : null;
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
    if (this.searchParams != null) {
      data['search_params'] = this.searchParams!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchParams {
  String? search;
  String? startDate;
  String? endDate;

  SearchParams({this.search, this.startDate, this.endDate});

  SearchParams.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class Data {
  int? id;
  int? merchantId;
  String? name;
  String? category;
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
  String? currency;
  int? pricePerNight;
  int? specialOffer;
  Null? isFeatured;
  String? checkInTime;
  String? checkOutTime;
  List<String>? facilities;
  List<String>? rules;
  List<String>? images;
  String? status;

  Data(
      {this.id,
        this.merchantId,
        this.name,
        this.category,
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
        this.currency,
        this.pricePerNight,
        this.specialOffer,
        this.isFeatured,
        this.checkInTime,
        this.checkOutTime,
        this.facilities,
        this.rules,
        this.images,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    name = json['name'];
    category = json['category'];
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
    currency = json['currency'];
    pricePerNight = json['price_per_night'];
    specialOffer = json['special_offer'];
    isFeatured = json['is_featured'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    facilities = json['facilities'].cast<String>();
    rules = json['rules'].cast<String>();
    images = json['images'].cast<String>();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_id'] = this.merchantId;
    data['name'] = this.name;
    data['category'] = this.category;
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
    data['currency'] = this.currency;
    data['price_per_night'] = this.pricePerNight;
    data['special_offer'] = this.specialOffer;
    data['is_featured'] = this.isFeatured;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['facilities'] = this.facilities;
    data['rules'] = this.rules;
    data['images'] = this.images;
    data['status'] = this.status;
    return data;
  }
}
