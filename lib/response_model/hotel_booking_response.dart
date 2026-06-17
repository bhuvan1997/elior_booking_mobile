import 'booking_data.dart';

/// Response wrapper for hotel/room booking API calls.
/// Previously named [RoomBookingModel].
class HotelBookingModel {
  final bool? status;
  final HotelBookingData? data;

  HotelBookingModel({this.status, this.data});

  HotelBookingModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = json['data'] != null
            ? HotelBookingData.fromJson(json['data'])
            : null;

  Map<String, dynamic> toJson() => {
    'status': status,
    if (data != null) 'data': data!.toJson(),
  };
}

/// Hotel/room booking detail data.
/// Previously named [Data] — renamed to [HotelBookingData] for clarity.
class HotelBookingData {
  final int? propertyId;
  final String? hotelName;
  final String? hotelAddress;
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
  final int? totalCapacity;
  final int? bedroom;
  final int? beds;
  final int? bathroom;
  final String? currency;
  final int? basePrice;
  final int? totalPrice;
  final dynamic taxPrice;
  final List<String>? hotelImages;
  final List<BookingCoupon>? coupons;

  const HotelBookingData({
    this.propertyId,
    this.hotelName,
    this.hotelAddress,
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
    this.totalCapacity,
    this.bedroom,
    this.beds,
    this.bathroom,
    this.currency,
    this.basePrice,
    this.totalPrice,
    this.taxPrice,
    this.hotelImages,
    this.coupons,
  });

  HotelBookingData.fromJson(Map<String, dynamic> json)
      : propertyId = json['property_id'],
        hotelName = json['hotel_name'],
        hotelAddress = json['hotel_address'],
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
        totalCapacity = json['total_capacity'],
        bedroom = json['bedroom'],
        beds = json['beds'],
        bathroom = json['bathroom'],
        currency = json['currency'],
        basePrice = json['base_price'],
        totalPrice = json['total_price'],
        taxPrice = json['tax_price'],
        hotelImages = (json['hotel_images'] as List?)?.cast<String>(),
        coupons = (json['coupons'] as List?)
            ?.map((c) => BookingCoupon.fromJson(c))
            .toList();

  Map<String, dynamic> toJson() => {
    'property_id': propertyId,
    'hotel_name': hotelName,
    'hotel_address': hotelAddress,
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
    'total_capacity': totalCapacity,
    'bedroom': bedroom,
    'beds': beds,
    'bathroom': bathroom,
    'currency': currency,
    'base_price': basePrice,
    'total_price': totalPrice,
    'tax_price': taxPrice,
    'hotel_images': hotelImages,
    if (coupons != null)
      'coupons': coupons!.map((c) => c.toJson()).toList(),
  };

  /// Convert to the unified [BookingData] for use in screens/widgets.
  BookingData toBookingData() => BookingData(
    propertyId: propertyId,
    propertyName: hotelName,
    propertyAddress: hotelAddress,
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
    totalCapacity: totalCapacity,
    bedroom: bedroom,
    beds: beds,
    bathroom: bathroom,
    currency: currency,
    basePrice: basePrice,
    totalPrice: totalPrice,
    taxPrice: taxPrice,
    propertyImages: hotelImages,
    coupons: coupons,
    propertyType: BookingPropertyType.hotel,
  );
}