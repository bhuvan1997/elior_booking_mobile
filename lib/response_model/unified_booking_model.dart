// unified_booking_model.dart
import 'dart:convert';

UnifiedBookingModel unifiedBookingModelFromJson(String str) =>
    UnifiedBookingModel.fromJson(json.decode(str));

String unifiedBookingModelToJson(UnifiedBookingModel data) =>
    json.encode(data.toJson());

class UnifiedBookingModel {
  bool? status;
  UnifiedBookingData? data;

  UnifiedBookingModel({this.status, this.data});

  factory UnifiedBookingModel.fromJson(Map<String, dynamic> json) =>
      UnifiedBookingModel(
        status: json['status'],
        data: json['data'] != null
            ? UnifiedBookingData.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.toJson(),
  };
}

class UnifiedBookingData {
  // Core fields (common to both)
  int? propertyId;
  String? checkInTime;
  String? checkOutTime;
  String? checkinDate;
  String? checkoutDate;
  int? nights;
  int? guest;
  int? roomsCount;
  String? allotRooms;
  String? totalCapacity;
  int? bedroom;
  int? beds;
  int? bathroom;
  String? currency;
  int? basePrice;
  int? totalPrice;
  dynamic taxPrice;
  List<UnifiedCoupon>? coupons;

  // Hotel specific fields
  String? hotelName;
  String? hotelAddress;
  int? starRating;
  List<String>? hotelImages;

  // Homestay specific fields
  String? homestayName;
  String? homestayAddress;
  List<String>? homestayImages;
  String? accomodation;

  // Type identifier
  String? propertyType; // 'hotel' or 'homestay'

  UnifiedBookingData({
    this.propertyId,
    this.checkInTime,
    this.checkOutTime,
    this.checkinDate,
    this.checkoutDate,
    this.nights,
    this.guest,
    this.roomsCount,
    this.allotRooms,
    this.totalCapacity,
    this.bedroom,
    this.beds,
    this.bathroom,
    this.currency,
    this.basePrice,
    this.totalPrice,
    this.taxPrice,
    this.coupons,
    this.hotelName,
    this.hotelAddress,
    this.starRating,
    this.hotelImages,
    this.homestayName,
    this.homestayAddress,
    this.homestayImages,
    this.accomodation,
    this.propertyType,
  });

  factory UnifiedBookingData.fromJson(Map<String, dynamic> json) {
    // Detect property type
    String? type = 'hotel';
    if (json['homestay_name'] != null) {
      type = 'homestay';
    } else if (json['hotel_name'] != null) {
      type = 'hotel';
    }

    return UnifiedBookingData(
      propertyId: json['property_id'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      checkinDate: json['checkin_date'],
      checkoutDate: json['checkout_date'],
      nights: json['nights'],
      guest: json['guest'],
      roomsCount: json['rooms_count'],
      allotRooms: json['allot_rooms'],
      totalCapacity: json['total_capacity'],
      bedroom: json['bedroom'],
      beds: json['beds'],
      bathroom: json['bathroom'],
      currency: json['currency'],
      basePrice: json['base_price'],
      totalPrice: json['total_price'],
      taxPrice: json['tax_price'],
      coupons: json['coupons'] != null
          ? List<UnifiedCoupon>.from(
          json['coupons'].map((x) => UnifiedCoupon.fromJson(x)))
          : null,
      hotelName: json['hotel_name'],
      hotelAddress: json['hotel_address'],
      starRating: json['star_rating'],
      hotelImages: json['hotel_images'] != null
          ? List<String>.from(json['hotel_images'])
          : null,
      homestayName: json['homestay_name'],
      homestayAddress: json['homestay_address'],
      homestayImages: json['homestay_images'] != null
          ? List<String>.from(json['homestay_images'])
          : null,
      accomodation: json['accomodation'],
      propertyType: type,
    );
  }

  Map<String, dynamic> toJson() => {
    'property_id': propertyId,
    'check_in_time': checkInTime,
    'check_out_time': checkOutTime,
    'checkin_date': checkinDate,
    'checkout_date': checkoutDate,
    'nights': nights,
    'guest': guest,
    'rooms_count': roomsCount,
    'allot_rooms': allotRooms,
    'total_capacity': totalCapacity,
    'bedroom': bedroom,
    'beds': beds,
    'bathroom': bathroom,
    'currency': currency,
    'base_price': basePrice,
    'total_price': totalPrice,
    'tax_price': taxPrice,
    'coupons': coupons?.map((e) => e.toJson()).toList(),
    'hotel_name': hotelName,
    'hotel_address': hotelAddress,
    'star_rating': starRating,
    'hotel_images': hotelImages,
    'homestay_name': homestayName,
    'homestay_address': homestayAddress,
    'homestay_images': homestayImages,
    'accomodation': accomodation,
    'property_type': propertyType,
  };

  // Helper getters for common fields
  String get displayName => propertyType == 'homestay'
      ? homestayName ?? 'Homestay'
      : hotelName ?? 'Hotel';

  String get displayAddress => propertyType == 'homestay'
      ? homestayAddress ?? ''
      : hotelAddress ?? '';

  List<String> get displayImages => propertyType == 'homestay'
      ? homestayImages ?? []
      : hotelImages ?? [];

  int get displayStarRating => starRating ?? 0;
}

class UnifiedCoupon {
  String? name;
  String? description;
  String? value;
  int? valueInPercent;

  UnifiedCoupon({this.name, this.description, this.value, this.valueInPercent});

  factory UnifiedCoupon.fromJson(Map<String, dynamic> json) => UnifiedCoupon(
    name: json['name'],
    description: json['description'],
    value: json['value'],
    valueInPercent: json['value_in_percent'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'value': value,
    'value_in_percent': valueInPercent,
  };
}