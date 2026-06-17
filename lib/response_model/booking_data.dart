/// A unified booking data model used across the app (screens, widgets, services).
/// Both [HotelBookingData] and [AccommodationBookingData] convert into this.
class BookingData {
  final int? propertyId;
  final String? propertyName; // hotel_name OR homestay_name
  final String? propertyAddress; // hotel_address OR homestay_address
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
  final String? accommodation; // null for hotels
  final int? totalCapacity;
  final int? bedroom;
  final int? beds;
  final int? bathroom;
  final String? currency;
  final int? basePrice;
  final int? totalPrice;
  final dynamic taxPrice;
  final List<String>? propertyImages; // hotel_images OR homestay_images
  final List<BookingCoupon>? coupons;
  final BookingPropertyType propertyType;

  const BookingData({
    this.propertyId,
    this.propertyName,
    this.propertyAddress,
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
    this.propertyImages,
    this.coupons,
    this.propertyType = BookingPropertyType.hotel,
  });
}

enum BookingPropertyType { hotel, accommodation }

/// Shared coupon model (identical structure in both source models).
class BookingCoupon {
  final String? name;
  final String? description;
  final String? value;
  final int? valueInPercent;

  const BookingCoupon({
    this.name,
    this.description,
    this.value,
    this.valueInPercent,
  });

  BookingCoupon.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        value = json['value'],
        valueInPercent = json['value_in_percent'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'value': value,
    'value_in_percent': valueInPercent,
  };
}