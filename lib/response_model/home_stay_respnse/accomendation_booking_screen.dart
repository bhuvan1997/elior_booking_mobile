class AccomendationBookingModel {
  bool? status;
  AccData? data;

  AccomendationBookingModel({this.status, this.data});

  AccomendationBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new AccData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AccData {
  int? propertyId;
  String? homestayName;
  String? homestayAddress;
  String? city;
  String? state;
  String? country;
  int? starRating;
  String? checkInTime;
  String? checkOutTime;
  String? checkinDate;
  String? checkoutDate;
  int? nights;
  int? guest;
  int? roomsCount;
  String? allotRooms;
  String? accomodation;
  int? totalCapacity;
  int? bedroom;
  int? beds;
  int? bathroom;
  String? currency;
  int? basePrice;
  int? totalPrice;
  dynamic taxPrice;
  List<String>? homestayImages;
  List<Coupons>? coupons;

  AccData({
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
    this.accomodation,
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

  AccData.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    homestayName = json['homestay_name'];
    homestayAddress = json['homestay_address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    starRating = json['star_rating'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    checkinDate = json['checkin_date'];
    checkoutDate = json['checkout_date'];
    nights = json['nights'];
    guest = json['guest'];
    roomsCount = json['rooms_count'];
    allotRooms = json['allot_rooms'];
    accomodation = json['accomodation'];
    totalCapacity = json['total_capacity'];
    bedroom = json['bedroom'];
    beds = json['beds'];
    bathroom = json['bathroom'];
    currency = json['currency'];
    basePrice = json['base_price'];
    totalPrice = json['total_price'];
    taxPrice = json['tax_price'];
    homestayImages = json['homestay_images'].cast<String>();
    if (json['coupons'] != null) {
      coupons = <Coupons>[];
      json['coupons'].forEach((v) {
        coupons!.add(new Coupons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['homestay_name'] = this.homestayName;
    data['homestay_address'] = this.homestayAddress;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['star_rating'] = this.starRating;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['checkin_date'] = this.checkinDate;
    data['checkout_date'] = this.checkoutDate;
    data['nights'] = this.nights;
    data['guest'] = this.guest;
    data['rooms_count'] = this.roomsCount;
    data['allot_rooms'] = this.allotRooms;
    data['accomodation'] = this.accomodation;
    data['total_capacity'] = this.totalCapacity;
    data['bedroom'] = this.bedroom;
    data['beds'] = this.beds;
    data['bathroom'] = this.bathroom;
    data['currency'] = this.currency;
    data['base_price'] = this.basePrice;
    data['total_price'] = this.totalPrice;
    data['tax_price'] = this.taxPrice;
    data['homestay_images'] = this.homestayImages;
    if (this.coupons != null) {
      data['coupons'] = this.coupons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupons {
  String? name;
  String? description;
  String? value;
  int? valueInPercent;

  Coupons({this.name, this.description, this.value, this.valueInPercent});

  Coupons.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    value = json['value'];
    valueInPercent = json['value_in_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['value'] = this.value;
    data['value_in_percent'] = this.valueInPercent;
    return data;
  }
}
