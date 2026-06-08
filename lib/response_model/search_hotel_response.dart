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
  AllStars? allStars;

  SearchParams(
      {this.search,
        this.startDate,
        this.endDate,
        this.allAmenities,
        this.allRules,
        this.allStars});

  SearchParams.fromJson(Map<String, dynamic> json) {
    search = json['search'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    allAmenities = json['all_amenities'].cast<String>();
    allRules = json['all_rules'].cast<String>();
    allStars = json['all_stars'] != null
        ? new AllStars.fromJson(json['all_stars'])
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
      data['all_stars'] = this.allStars!.toJson();
    }
    return data;
  }
}

class AllStars {
  int? i1Star;
  int? i2Star;
  int? i3Star;
  int? i4Star;
  int? i5Star;

  AllStars({this.i1Star, this.i2Star, this.i3Star, this.i4Star, this.i5Star});

  AllStars.fromJson(Map<String, dynamic> json) {
    i1Star = json['1 Star'];
    i2Star = json['2 Star'];
    i3Star = json['3 Star'];
    i4Star = json['4 Star'];
    i5Star = json['5 Star'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1 Star'] = this.i1Star;
    data['2 Star'] = this.i2Star;
    data['3 Star'] = this.i3Star;
    data['4 Star'] = this.i4Star;
    data['5 Star'] = this.i5Star;
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
  factory Data.fromDatam(Datams d) {
    // Safe parsing for pricePerNight
    int? parsedPrice;
    if (d.pricePerNight != null) {
      // We already know d.pricePerNight is int? from the Datams model
      parsedPrice = d.pricePerNight;
    }

    // Safe list assignment
    List<String>? hotelImages = d.images;

    return Data(
      id: d.id,
      name: d.name,
      city: d.city,
      country: d.country,
      // Use the safely parsed price
      pricePerNight: parsedPrice,
      starRating: d.starRating,
      images: hotelImages,
      currency: d.currency,
      checkInTime: d.checkInTime,
      checkOutTime: d.checkOutTime

    );
  }
factory Data.fromDatams(DataSort d) {
    // Safe parsing for pricePerNight
    int? parsedPrice;
    if (d.pricePerNight != null) {
      // We already know d.pricePerNight is int? from the Datams model
      parsedPrice = d.pricePerNight;
    }

    // Safe list assignment
    List<String>? hotelImages = d.images;

    return Data(
      id: d.id,
      name: d.name,
      city: d.city,
      country: d.country,
      // Use the safely parsed price
      pricePerNight: parsedPrice,
      starRating: d.starRating,
      images: hotelImages,
        currency: d.currency,
        checkInTime: d.checkInTime,
        checkOutTime: d.checkOutTime
    );
  }

}
