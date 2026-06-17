import 'dart:convert';

UnifiedDetailModel unifiedDetailModelFromJson(String str) =>
    UnifiedDetailModel.fromJson(json.decode(str));

String unifiedDetailModelToJson(UnifiedDetailModel data) =>
    json.encode(data.toJson());

class UnifiedDetailModel {
  bool? status;
  String? message;
  List<UnifiedData>? data;

  UnifiedDetailModel({
    this.status,
    this.message,
    this.data,
  });

  factory UnifiedDetailModel.fromJson(Map<String, dynamic> json) =>
      UnifiedDetailModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<UnifiedData>.from(
            json["data"].map((x) => UnifiedData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UnifiedData {
  // Core fields (common to both)
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
  String? checkInTime;
  String? checkOutTime;
  List<String>? facilities;
  List<String>? rules;
  List<String>? images;
  String? status;

  // Rating and reviews (union of both types)
  List<RatingReview>? ratingReviews;
  double? averageRating; // Using double to handle both int and double

  // Fields with type differences (union types)
  dynamic specialOffer; // Can be null, int, or other types
  dynamic isFeatured; // Can be String or int

  // Translator fields (common to both)
  String? translatedName;
  String? translatedCityCountry;
  String? translatedDescription;
  String? translatedAddress;
  String? translatedFacilities;

  UnifiedData({
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

  factory UnifiedData.fromJson(Map<String, dynamic> json) => UnifiedData(
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
        : List<RatingReview>.from(
        json["ratingReviews"].map((x) => RatingReview.fromJson(x))),
    averageRating: _parseAverageRating(json["average_rating"]),
    translatedName: json["translatedName"],
    translatedCityCountry: json["translatedCityCountry"],
    translatedDescription: json["translatedDescription"],
    translatedAddress: json["translatedAddress"],
    translatedFacilities: json["translatedFacilities"],
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
    "rules": rules == null ? [] : List<dynamic>.from(rules!.map((x) => x)),
    "images": images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x)),
    "status": status,
    "ratingReviews": ratingReviews == null
        ? []
        : List<dynamic>.from(ratingReviews!.map((x) => x.toJson())),
    "average_rating": averageRating,
    "translatedName": translatedName,
    "translatedCityCountry": translatedCityCountry,
    "translatedDescription": translatedDescription,
    "translatedAddress": translatedAddress,
    "translatedFacilities": translatedFacilities,
  };

  // Helper method to parse average rating (handles both int and double)
  static double? _parseAverageRating(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Helper method to safely get special offer as int (if needed)
  int? get specialOfferAsInt {
    if (specialOffer == null) return null;
    if (specialOffer is int) return specialOffer;
    if (specialOffer is String) return int.tryParse(specialOffer);
    return null;
  }

  // Helper method to safely get isFeatured as bool
  bool? get isFeaturedAsBool {
    if (isFeatured == null) return null;
    if (isFeatured is bool) return isFeatured;
    if (isFeatured is int) return isFeatured == 1;
    if (isFeatured is String) {
      return isFeatured.toLowerCase() == 'true' || isFeatured == '1';
    }
    return null;
  }

  // Helper method to get clean rating reviews
  List<RatingReview> get getRatingReviews => ratingReviews ?? [];
}

class RatingReview {
  String? title;
  int? rating;
  String? createdAt;
  String? name;
  String? review;

  RatingReview({
    this.title,
    this.rating,
    this.createdAt,
    this.name,
    this.review,
  });

  factory RatingReview.fromJson(Map<String, dynamic> json) => RatingReview(
    title: json["title"],
    rating: json["rating"],
    createdAt: json["created_at"],
    name: json["name"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "rating": rating,
    "created_at": createdAt,
    "name": name,
    "review": review,
  };
}

// Utility extension for easier access to type-specific properties
extension UnifiedDataExtensions on UnifiedData {
  bool get hasSpecialOffer => specialOffer != null;

  bool get isFeaturedPromoted {
    if (isFeatured == null) return false;
    if (isFeatured is String) {
      return isFeatured.toLowerCase() == 'true' || isFeatured == '1';
    }
    if (isFeatured is int) return isFeatured == 1;
    if (isFeatured is bool) return isFeatured;
    return false;
  }

  double get getAverageRating => averageRating ?? 0.0;

  bool get hasRatingReviews => ratingReviews?.isNotEmpty ?? false;
}