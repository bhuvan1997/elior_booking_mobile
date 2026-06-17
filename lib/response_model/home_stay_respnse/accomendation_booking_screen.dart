import '../booking_data.dart';

/// Response wrapper for accommodation/homestay booking API calls.
/// Previously named [AccomendationBookingModel] (note: fixes the typo too).
class AccommodationBookingModel {
  final bool? status;
  final AccommodationBookingData? data;

  AccommodationBookingModel({this.status, this.data});

  AccommodationBookingModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = json['data'] != null
            ? AccommodationBookingData.fromJson(json['data'])
            : null;

  Map<String, dynamic> toJson() => {
    'status': status,
    if (data != null) 'data': data!.toJson(),
  };
}

/// Accommodation/homestay booking detail data.
/// Previously named [AccData] — renamed to [AccommodationBookingData] for clarity.
class AccommodationBookingData {
  final int? propertyId;
  final String? homestayName;
  final String? homestayAddress;
  final String? city;
  final String? state;
  final String? country;
  final int? starRating;
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkinDate;
  final String? checkoutDate;
  final int? nights;
  final int? guest;
  final int? roomsCount;
  final String? allotRooms;
  final String? accommodation;
  final int? totalCapacity;
  final int? bedroom;
  final int? beds;
  final int? bathroom;
  final String? currency;
  final int? basePrice;
  final int? totalPrice;
  final dynamic taxPrice;
  final List<String>? homestayImages;
  final List<BookingCoupon>? coupons;

  const AccommodationBookingData({
    this.propertyId,
    this.homestayName,
    this.homestayAddress,
    this.city,
    this.state,
    this.country,
    this.starRating,
    this.checkInTime,
    this.checkOutTime,
    this.checkinDate,
    this.checkoutDate,
    this.nights,
    this.guest,
    this.roomsCount,
    this.allotRooms,
    this.accommodation,
    this.totalCapacity,
    this.bedroom,
    this.beds,
    this.bathroom,
    this.currency,
    this.basePrice,
    this.totalPrice,
    this.taxPrice,
    this.homestayImages,
    this.coupons,
  });

  AccommodationBookingData.fromJson(Map<String, dynamic> json)
      : propertyId = json['property_id'],
        homestayName = json['homestay_name'],
        homestayAddress = json['homestay_address'],
        city = json['city'],
        state = json['state'],
        country = json['country'],
        starRating = json['star_rating'],
        checkInTime = json['check_in_time'],
        checkOutTime = json['check_out_time'],
        checkinDate = json['checkin_date'],
        checkoutDate = json['checkout_date'],
        nights = json['nights'],
        guest = json['guest'],
        roomsCount = json['rooms_count'],
        allotRooms = json['allot_rooms'],
        accommodation = json['accomodation'], // matches API key (typo in API)
        totalCapacity = json['total_capacity'],
        bedroom = json['bedroom'],
        beds = json['beds'],
        bathroom = json['bathroom'],
        currency = json['currency'],
        basePrice = json['base_price'],
        totalPrice = json['total_price'],
        taxPrice = json['tax_price'],
        homestayImages = (json['homestay_images'] as List?)?.cast<String>(),
        coupons = (json['coupons'] as List?)
            ?.map((c) => BookingCoupon.fromJson(c))
            .toList();

  Map<String, dynamic> toJson() => {
    'property_id': propertyId,
    'homestay_name': homestayName,
    'homestay_address': homestayAddress,
    'city': city,
    'state': state,
    'country': country,
    'star_rating': starRating,
    'check_in_time': checkInTime,
    'check_out_time': checkOutTime,
    'checkin_date': checkinDate,
    'checkout_date': checkoutDate,
    'nights': nights,
    'guest': guest,
    'rooms_count': roomsCount,
    'allot_rooms': allotRooms,
    'accomodation': accommodation, // matches API key
    'total_capacity': totalCapacity,
    'bedroom': bedroom,
    'beds': beds,
    'bathroom': bathroom,
    'currency': currency,
    'base_price': basePrice,
    'total_price': totalPrice,
    'tax_price': taxPrice,
    'homestay_images': homestayImages,
    if (coupons != null)
      'coupons': coupons!.map((c) => c.toJson()).toList(),
  };

  /// Convert to the unified [BookingData] for use in screens/widgets.
  BookingData toBookingData() => BookingData(
    propertyId: propertyId,
    propertyName: homestayName,
    propertyAddress: homestayAddress,
    city: city,
    state: state,
    country: country,
    starRating: starRating,
    checkInTime: checkInTime,
    checkOutTime: checkOutTime,
    checkinDate: checkinDate,
    checkoutDate: checkoutDate,
    nights: nights,
    guest: guest,
    roomsCount: roomsCount,
    allotRooms: allotRooms,
    accommodation: accommodation,
    totalCapacity: totalCapacity,
    bedroom: bedroom,
    beds: beds,
    bathroom: bathroom,
    currency: currency,
    basePrice: basePrice,
    totalPrice: totalPrice,
    taxPrice: taxPrice,
    propertyImages: homestayImages,
    coupons: coupons,
    propertyType: BookingPropertyType.accommodation,
  );
}