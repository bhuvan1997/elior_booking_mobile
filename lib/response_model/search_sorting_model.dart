class SearchSotingModel {
  bool? status;
  String? message;
  SearchParams? searchParams;
  List<DataSort>? data;

  SearchSotingModel({this.status, this.message, this.searchParams, this.data});

  SearchSotingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    message = json['message']?.toString();
    searchParams = json['search_params'] != null
        ? SearchParams.fromJson(json['search_params'])
        : null;

    if (json['data'] is List) {
      data = (json['data'] as List)
          .map((v) => DataSort.fromJson(v))
          .toList();
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (searchParams != null) {
      data['search_params'] = searchParams!.toJson();
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
  String? sorting;

  SearchParams({this.search, this.startDate, this.endDate, this.sorting});

  SearchParams.fromJson(Map<String, dynamic> json) {
    search = json['search']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    sorting = json['sorting']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'start_date': startDate,
      'end_date': endDate,
      'sorting': sorting,
    };
  }
}

class DataSort {
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
  int? isFeatured;
  String? checkInTime;
  String? checkOutTime;
  List<String>? facilities;
  List<String>? rules;
  List<String>? images;
  String? status;

  DataSort({
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

  DataSort.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    merchantId = json['merchant_id'] is int
        ? json['merchant_id']
        : int.tryParse(json['merchant_id'].toString());
    name = json['name']?.toString();
    category = json['category']?.toString();
    description = json['description']?.toString();
    address = json['address']?.toString();
    city = json['city']?.toString();
    state = json['state']?.toString();
    country = json['country']?.toString();
    zipcode = json['zipcode']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    phone = json['phone']?.toString();
    email = json['email']?.toString();
    website = json['website']?.toString();
    starRating = json['star_rating'] is int
        ? json['star_rating']
        : int.tryParse(json['star_rating']?.toString() ?? '0');
    currency = json['currency']?.toString();
    pricePerNight = json['price_per_night'] is int
        ? json['price_per_night']
        : int.tryParse(json['price_per_night']?.toString() ?? '0');
    specialOffer = json['special_offer'] is int
        ? json['special_offer']
        : int.tryParse(json['special_offer']?.toString() ?? '0');
    isFeatured = json['is_featured'] is int
        ? json['is_featured']
        : int.tryParse(json['is_featured']?.toString() ?? '0');
    checkInTime = json['check_in_time']?.toString();
    checkOutTime = json['check_out_time']?.toString();

    // ✅ Safe list handling
    facilities = (json['facilities'] is List)
        ? (json['facilities'] as List).map((e) => e.toString()).toList()
        : [];

    rules = (json['rules'] is List)
        ? (json['rules'] as List).map((e) => e.toString()).toList()
        : [];

    images = (json['images'] is List)
        ? (json['images'] as List).map((e) => e.toString()).toList()
        : [];

    status = json['status']?.toString();
  }

  int? get isFavourite => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchant_id': merchantId,
      'name': name,
      'category': category,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zipcode': zipcode,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'website': website,
      'star_rating': starRating,
      'currency': currency,
      'price_per_night': pricePerNight,
      'special_offer': specialOffer,
      'is_featured': isFeatured,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'facilities': facilities,
      'rules': rules,
      'images': images,
      'status': status,
    };
  }
}
