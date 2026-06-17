import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../hotel_booking/hotel_detail.dart';
import '../utils/translator_service.dart';

NearbyPropertiesResponse nearbyPropertiesResponseFromJson(String str) =>
    NearbyPropertiesResponse.fromJson(json.decode(str));

String nearbyPropertiesResponseToJson(NearbyPropertiesResponse data) =>
    json.encode(data.toJson());

class NearbyPropertiesResponse {
  bool? status;
  String? message;
  List<NearbyProperty>? data;

  NearbyPropertiesResponse({
    this.status,
    this.message,
    this.data,
  });

  factory NearbyPropertiesResponse.fromJson(Map<String, dynamic> json) =>
      NearbyPropertiesResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<NearbyProperty>.from(json["data"].map((x) => NearbyProperty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NearbyProperty {
  int? id;
  String? name;
  String? type; // "hotel" or "homestay"
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

  // Translation fields (optional, can be populated later)
  String? translatedName;
  String? translatedDescription;
  String? translatedAddress;

  NearbyProperty({
    this.id,
    this.name,
    this.type,
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
    this.images,
    this.translatedName,
    this.translatedDescription,
    this.translatedAddress,
  });

  factory NearbyProperty.fromJson(Map<String, dynamic> json) => NearbyProperty(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    description: json["description"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipcode: json["zipcode"],
    starRating: json["star_rating"],
    currency: json["currency"],
    pricePerNight: json["price_per_night"],
    checkInTime: json["check_in_time"],
    checkOutTime: json["check_out_time"],
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"].map((x) => x)),
    translatedName: json["translatedName"],
    translatedDescription: json["translatedDescription"],
    translatedAddress: json["translatedAddress"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "description": description,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "zipcode": zipcode,
    "star_rating": starRating,
    "currency": currency,
    "price_per_night": pricePerNight,
    "check_in_time": checkInTime,
    "check_out_time": checkOutTime,
    "images": images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x)),
    "translatedName": translatedName,
    "translatedDescription": translatedDescription,
    "translatedAddress": translatedAddress,
  };

  // Helper method to get the display name (translated or original)
  String get displayName => translatedName ?? name ?? '';

  // Helper method to get the display description (translated or original)
  String get displayDescription => translatedDescription ?? description ?? '';

  // Helper method to get the display address (translated or original)
  String get displayAddress => translatedAddress ?? address ?? '';

  // Helper method to get the full location string
  String get fullLocation {
    List<String> parts = [];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }

  // Helper method to get the first image URL
  String? get firstImage => images?.isNotEmpty == true ? images!.first : null;

  // Helper method to get star rating as a list of booleans for UI
  List<bool> get starRatingList {
    if (starRating == null) return List.filled(5, false);
    return List.generate(5, (index) => index < starRating!);
  }

  // Helper method to check if property is a hotel
  bool get isHotel => type?.toLowerCase() == 'hotel';

  // Helper method to check if property is a homestay
  bool get isHomestay => type?.toLowerCase() == 'homestay';

  // Helper method to get formatted price
  String get formattedPrice {
    if (currency == null || pricePerNight == null) return 'N/A';
    return '$currency ${pricePerNight!.toString()}';
  }

  // Helper method to navigate to property detail
  void navigateToDetail(BuildContext context) {
    Get.to(
          () => UnifiedPropertyDetailsScreen(
        id: id ?? 0,
        fac: '', // You can pass appropriate value if needed
        slug: type ?? 'hotel',
      ),
    );
  }
}

// Extension for list of nearby properties
extension NearbyPropertyListExtension on List<NearbyProperty> {
  // Filter hotels only
  List<NearbyProperty> get hotels => where((p) => p.isHotel).toList();

  // Filter homestays only
  List<NearbyProperty> get homestays => where((p) => p.isHomestay).toList();

  // Sort by price (low to high)
  List<NearbyProperty> sortByPriceAsc() {
    sort((a, b) => (a.pricePerNight ?? 0).compareTo(b.pricePerNight ?? 0));
    return this;
  }

  // Sort by price (high to low)
  List<NearbyProperty> sortByPriceDesc() {
    sort((a, b) => (b.pricePerNight ?? 0).compareTo(a.pricePerNight ?? 0));
    return this;
  }

  // Sort by star rating (high to low)
  List<NearbyProperty> sortByRatingDesc() {
    sort((a, b) => (b.starRating ?? 0).compareTo(a.starRating ?? 0));
    return this;
  }

  // Filter by type
  List<NearbyProperty> filterByType(String type) {
    return where((p) => p.type?.toLowerCase() == type.toLowerCase()).toList();
  }

  // Filter by minimum star rating
  List<NearbyProperty> filterByMinRating(int minRating) {
    return where((p) => (p.starRating ?? 0) >= minRating).toList();
  }

  // Filter by maximum price
  List<NearbyProperty> filterByMaxPrice(int maxPrice) {
    return where((p) => (p.pricePerNight ?? 0) <= maxPrice).toList();
  }

  // Filter by minimum price
  List<NearbyProperty> filterByMinPrice(int minPrice) {
    return where((p) => (p.pricePerNight ?? 0) >= minPrice).toList();
  }

  // Get price range
  (int? min, int? max) get priceRange {
    if (isEmpty) return (null, null);
    int? min = first.pricePerNight;
    int? max = first.pricePerNight;
    for (var p in this) {
      if (p.pricePerNight != null) {
        if (min == null || p.pricePerNight! < min) min = p.pricePerNight;
        if (max == null || p.pricePerNight! > max) max = p.pricePerNight;
      }
    }
    return (min, max);
  }
}

// Translator for nearby properties
class NearbyPropertyTranslator {
  static Future<void> translateProperties(
      List<NearbyProperty> properties,
      String langCode,
      ) async {
    final translator = TranslationService();

    for (var property in properties) {
      property.translatedName = await translator.translateText(
        property.name ?? '',
        langCode,
      );

      property.translatedDescription = await translator.translateText(
        property.description ?? '',
        langCode,
      );

      property.translatedAddress = await translator.translateText(
        property.address ?? '',
        langCode,
      );
    }
  }
}