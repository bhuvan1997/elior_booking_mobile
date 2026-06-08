import 'dart:convert';

HomeStayDetailModel homeStayDetailModelFromJson(String str) =>
    HomeStayDetailModel.fromJson(json.decode(str));

String homeStayDetailModelToJson(HomeStayDetailModel data) =>
    json.encode(data.toJson());

class HomeStayDetailModel {
  bool? status;
  String? message;
  List<HomestayData>? data;

  HomeStayDetailModel({
    this.status,
    this.message,
    this.data,
  });

  factory HomeStayDetailModel.fromJson(Map<String, dynamic> json) =>
      HomeStayDetailModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<HomestayData>.from(
            json["data"].map((x) => HomestayData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HomestayData {
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
  dynamic specialOffer;
  String? isFeatured;
  String? checkInTime;
  String? checkOutTime;
  List<String>? facilities;
  List<String>? rules;
  List<String>? images;
  String? status;
  List<dynamic>? ratingReviews;
  double? averageRating;

  // For translator
  String? translatedName;
  String? translatedCityCountry;
  String? translatedDescription;
  String? translatedAddress;
  String? translatedFacilities;

  HomestayData({
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
    this.ratingReviews,
    this.averageRating,
    this.translatedName,
    this.translatedCityCountry,
    this.translatedDescription,
    this.translatedAddress,
    this.translatedFacilities,
  });

  factory HomestayData.fromJson(Map<String, dynamic> json) => HomestayData(
    id: json["id"],
    merchantId: json["merchant_id"],
    name: json["name"],
    category: json["category"],
    description: json["description"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipcode: json["zipcode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    phone: json["phone"],
    email: json["email"],
    website: json["website"],
    starRating: json["star_rating"],
    currency: json["currency"],
    pricePerNight: json["price_per_night"],
    specialOffer: json["special_offer"],
    isFeatured: json["is_featured"],
    checkInTime: json["check_in_time"],
    checkOutTime: json["check_out_time"],
    facilities: json["facilities"] == null
        ? []
        : List<String>.from(json["facilities"].map((x) => x)),
    rules: json["rules"] == null
        ? []
        : List<String>.from(json["rules"].map((x) => x)),
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"].map((x) => x)),
    status: json["status"],
    ratingReviews: json["ratingReviews"] == null
        ? []
        : List<dynamic>.from(json["ratingReviews"].map((x) => x)),
    averageRating: (json["average_rating"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "merchant_id": merchantId,
    "name": name,
    "category": category,
    "description": description,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "zipcode": zipcode,
    "latitude": latitude,
    "longitude": longitude,
    "phone": phone,
    "email": email,
    "website": website,
    "star_rating": starRating,
    "currency": currency,
    "price_per_night": pricePerNight,
    "special_offer": specialOffer,
    "is_featured": isFeatured,
    "check_in_time": checkInTime,
    "check_out_time": checkOutTime,
    "facilities": facilities == null
        ? []
        : List<dynamic>.from(facilities!.map((x) => x)),
    "rules":
    rules == null ? [] : List<dynamic>.from(rules!.map((x) => x)),
    "images":
    images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "status": status,
    "ratingReviews": ratingReviews == null
        ? []
        : List<dynamic>.from(ratingReviews!.map((x) => x)),
    "average_rating": averageRating,
  };
}
