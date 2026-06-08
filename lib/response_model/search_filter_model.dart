class SearchFilterModel {
  bool? status;
  String? message;
  SearchParams? searchParams;
  List<Datams>? data;

  SearchFilterModel({this.status, this.message, this.searchParams, this.data});

  SearchFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    searchParams = json['search_params'] != null
        ? new SearchParams.fromJson(json['search_params'])
        : null;
    if (json['data'] != null) {
      data = <Datams>[];
      json['data'].forEach((v) {
        data!.add(new Datams.fromJson(v));
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
  List<int>? starRatings;
  List<String>? amenities;
  List<String>? rules;
  List<String>? pricing;

  SearchParams({
    this.search,
    this.startDate,
    this.endDate,
    this.starRatings,
    this.amenities,
    this.rules,
    this.pricing,
  });

  SearchParams.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    starRatings = json['star_ratings'] is List
        ? List<int>.from(json['star_ratings'])
        : null;

    amenities = json['amenities'] is List
        ? List<String>.from(json['amenities'])
        : null;

    rules = json['rules'] is List ? List<String>.from(json['rules']) : null;
    pricing = json['pricing'] is List
        ? List<String>.from(json['pricing'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['star_ratings'] = this.starRatings;
    data['amenities'] = this.amenities;
    data['rules'] = this.rules;
    data['pricing'] = this.pricing;
    return data;
  }
}

class Datams {
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
  dynamic isFeatured;
  String? checkInTime;
  String? checkOutTime;
  List<String>? facilities;
  List<String>? rules;
  List<String>? images;
  String? status;

  Datams({
    this.id,
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
    this.status,
  });

  Datams.fromJson(Map<String, dynamic> json) {
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
    facilities = json['facilities'] is List
        ? List<String>.from(json['facilities'])
        : null;

    // ✅ FIX 2: Safely parse rules
    rules = json['rules'] is List ? List<String>.from(json['rules']) : null;

    // ✅ FIX 3: Safely parse images
    images = json['images'] is List ? List<String>.from(json['images']) : null;
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
