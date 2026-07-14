import 'package:elior/response_model/search_filter_model.dart';
import 'package:elior/response_model/search_sorting_model.dart';

class SearchHotelModel {
  bool? status;
  String? message;
  SearchParams? searchParams;
  List<Data>? data;

  SearchHotelModel({this.status, this.message, this.searchParams, this.data});

  SearchHotelModel.fromJson(Map<String, dynamic> json) {
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
  List<String>? allAmenities;
  List<String>? allRules;
  Map<String, int>? allStars; // Changed from AllStars to Map

  SearchParams({
    this.search,
    this.startDate,
    this.endDate,
    this.allAmenities,
    this.allRules,
    this.allStars,
  });

  SearchParams.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    allAmenities = json['all_amenities']?.cast<String>();
    allRules = json['all_rules']?.cast<String>();
    allStars = json['all_stars'] != null
        ? Map<String, int>.from(json['all_stars'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['all_amenities'] = this.allAmenities;
    data['all_rules'] = this.allRules;
    if (this.allStars != null) {
      data['all_stars'] = this.allStars;
    }
    return data;
  }
}

// Remove AllStars class as we're using Map now

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
  int? isFeatured;
  String? checkInTime;
  String? checkOutTime;
  List<String>? facilities;
  List<String>? rules;
  List<String>? images;
  String? status;
  String? translatedName;
  String? translatedDescription;
  String? translatedAddress;
  String? translatedCityCountry;
  String? translatedFacilities;

  Data({
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
    facilities = json['facilities']?.cast<String>();
    rules = json['rules']?.cast<String>();
    images = json['images']?.cast<String>();
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

  factory Data.fromDatam(Datams d) {
    return Data(
      id: d.id,
      name: d.name,
      city: d.city,
      country: d.country,
      pricePerNight: d.pricePerNight,
      starRating: d.starRating,
      images: d.images,
      currency: d.currency,
      checkInTime: d.checkInTime,
      checkOutTime: d.checkOutTime,
    );
  }

  factory Data.fromDatams(DataSort d) {
    return Data(
      id: d.id,
      name: d.name,
      city: d.city,
      country: d.country,
      pricePerNight: d.pricePerNight,
      starRating: d.starRating,
      images: d.images,
      currency: d.currency,
      checkInTime: d.checkInTime,
      checkOutTime: d.checkOutTime,
    );
  }
}

class PropertySearchResponse {
  bool? status;
  String? message;
  SearchParams? searchParams;
  List<Property>? data;

  PropertySearchResponse({
    this.status,
    this.message,
    this.searchParams,
    this.data,
  });

  PropertySearchResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    searchParams = json['search_params'] != null
        ? SearchParams.fromJson(json['search_params'])
        : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Property.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (searchParams != null) {
      map['search_params'] = searchParams?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  static List<PropertySearchResponse> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PropertySearchResponse.fromJson(json))
        .toList();
  }

  // NEW: Factory to convert from SearchHotelModel
  factory PropertySearchResponse.fromSearchHotelModel(SearchHotelModel model) {
    // Convert Data list to Property list
    List<Property>? propertyData;
    if (model.data != null) {
      propertyData = model.data!
          .map((data) => Property.fromData(data))
          .toList();
    }

    // Convert SearchParams
    SearchParams? params;
    if (model.searchParams != null) {
      params = SearchParams(
        search: model.searchParams!.search,
        startDate: model.searchParams!.startDate,
        endDate: model.searchParams!.endDate,
        allAmenities: model.searchParams!.allAmenities,
        allRules: model.searchParams!.allRules,
        allStars: model.searchParams!.allStars, // Now both use Map
      );
    }

    return PropertySearchResponse(
      status: model.status,
      message: model.message,
      searchParams: params,
      data: propertyData,
    );
  }
}

class Property {
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
  int? isFavourite;
  String? translatedName;
  String? translatedDescription;
  String? translatedAddress;
  String? translatedCityCountry;
  String? translatedFacilities;

  Property({
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
    this.isFavourite,
  });

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'] ?? 0;
    name = json['name'];
    category = json['category'] ?? "Homestay";
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
    specialOffer = json['special_offer'] ?? 0;
    isFeatured = json['is_featured'] ?? 0;
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    facilities = json['facilities'] != null
        ? List<String>.from(json['facilities'])
        : [];
    rules = json['rules'] != null
        ? List<String>.from(json['rules'])
        : [];
    images = json['images']?.cast<String>();
    status = json['status'] ?? "active";
    isFavourite = json['is_favourite'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['merchant_id'] = merchantId;
    map['name'] = name;
    map['category'] = category;
    map['description'] = description;
    map['address'] = address;
    map['city'] = city;
    map['state'] = state;
    map['country'] = country;
    map['zipcode'] = zipcode;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['phone'] = phone;
    map['email'] = email;
    map['website'] = website;
    map['star_rating'] = starRating;
    map['currency'] = currency;
    map['price_per_night'] = pricePerNight;
    map['special_offer'] = specialOffer;
    map['is_featured'] = isFeatured;
    map['check_in_time'] = checkInTime;
    map['check_out_time'] = checkOutTime;
    map['facilities'] = facilities;
    map['rules'] = rules;
    map['images'] = images;
    map['status'] = status;
    map['is_favourite'] = isFavourite;
    return map;
  }

  // NEW: Factory from Data (from SearchHotelModel)
  factory Property.fromData(Data data) {
    return Property(
      id: data.id,
      merchantId: data.merchantId,
      name: data.name,
      category: data.category,
      description: data.description,
      address: data.address,
      city: data.city,
      state: data.state,
      country: data.country,
      zipcode: data.zipcode,
      latitude: data.latitude,
      longitude: data.longitude,
      phone: data.phone,
      email: data.email,
      website: data.website,
      starRating: data.starRating,
      currency: data.currency,
      pricePerNight: data.pricePerNight,
      specialOffer: data.specialOffer,
      isFeatured: data.isFeatured,
      checkInTime: data.checkInTime,
      checkOutTime: data.checkOutTime,
      facilities: data.facilities,
      rules: data.rules,
      images: data.images,
      status: data.status,
      isFavourite: 0, // Default value since Data doesn't have this field
    );
  }

  // NEW: Factory from Datams
  factory Property.fromDatam(Datams d) {
    return Property(
      id: d.id,
      merchantId: d.merchantId,
      name: d.name,
      category: d.category,
      description: d.description,
      address: d.address,
      city: d.city,
      state: d.state,
      country: d.country,
      zipcode: d.zipcode,
      latitude: d.latitude,
      longitude: d.longitude,
      phone: d.phone,
      email: d.email,
      website: d.website,
      starRating: d.starRating,
      currency: d.currency,
      pricePerNight: d.pricePerNight,
      specialOffer: d.specialOffer,
      isFeatured: d.isFeatured,
      checkInTime: d.checkInTime,
      checkOutTime: d.checkOutTime,
      facilities: d.facilities,
      rules: d.rules,
      images: d.images,
      status: d.status,
      isFavourite: d.isFavourite,
    );
  }

  // NEW: Factory from DataSort
  factory Property.fromDataSort(DataSort d) {
    return Property(
      id: d.id,
      merchantId: d.merchantId,
      name: d.name,
      category: d.category,
      description: d.description,
      address: d.address,
      city: d.city,
      state: d.state,
      country: d.country,
      zipcode: d.zipcode,
      latitude: d.latitude,
      longitude: d.longitude,
      phone: d.phone,
      email: d.email,
      website: d.website,
      starRating: d.starRating,
      currency: d.currency,
      pricePerNight: d.pricePerNight,
      specialOffer: d.specialOffer,
      isFeatured: d.isFeatured,
      checkInTime: d.checkInTime,
      checkOutTime: d.checkOutTime,
      facilities: d.facilities,
      rules: d.rules,
      images: d.images,
      status: d.status,
      isFavourite: d.isFavourite,
    );
  }

  factory Property.fromBudgetJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      merchantId: json['merchant_id'] ?? 0,
      name: json['name'],
      category: json['category'] ?? "Homestay",
      description: json['description'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zipcode: json['zipcode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      starRating: json['star_rating'],
      currency: json['currency'],
      pricePerNight: json['price_per_night'],
      specialOffer: json['special_offer'] ?? 0,
      isFeatured: json['is_featured'] ?? 0,
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      facilities: json['facilities'] != null
          ? List<String>.from(json['facilities'])
          : [],
      rules: json['rules'] != null
          ? List<String>.from(json['rules'])
          : [],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
      status: json['status'] ?? "active",
      isFavourite: json['is_favourite'] ?? 0,
    );
  }

  // Helper methods
  bool get isHomestay => category != null && category!.isNotEmpty;
  bool get isHotel => true;

  String get starRatingString => '$starRating Star';
  String get formattedPrice => '$currency $pricePerNight';
  String get firstImage => images?.isNotEmpty == true ? images!.first : '';
}

// Extension for list operations
extension PropertyListExtension on List<Property> {
  List<Property> get favorites => where((p) => p.isFavourite == 1).toList();
  List<Property> get featured => where((p) => p.isFeatured == 1).toList();
  List<Property> get withSpecialOffer =>
      where((p) => p.specialOffer == 1).toList();

  List<Property> filterByCategory(String category) {
    return where(
      (p) => p.category?.toLowerCase() == category.toLowerCase(),
    ).toList();
  }

  List<Property> filterByStarRating(int minStars) {
    return where((p) => (p.starRating ?? 0) >= minStars).toList();
  }
}
