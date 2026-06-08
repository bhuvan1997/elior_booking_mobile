class BookingHistoryDetails {
  bool? status;
  String? message;
  Data? data;

  BookingHistoryDetails({this.status, this.message, this.data});

  BookingHistoryDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Booking>? booking;
  List<Payments>? payments;
  List<String>? rules;
  List<String>? facilities;
  List<Review>? review;

  Data({this.booking, this.payments, this.rules, this.facilities, this.review});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['booking'] != null) {
      booking = <Booking>[];
      json['booking'].forEach((v) {
        booking!.add(new Booking.fromJson(v));
      });
    }
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) {
        payments!.add(new Payments.fromJson(v));
      });
    }
    rules = json['rules'].cast<String>();
    facilities = json['facilities'].cast<String>();
    if (json['review'] != null) {
      review = <Review>[];
      json['review'].forEach((v) {
        review!.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.booking != null) {
      data['booking'] = this.booking!.map((v) => v.toJson()).toList();
    }
    if (this.payments != null) {
      data['payments'] = this.payments!.map((v) => v.toJson()).toList();
    }
    data['rules'] = this.rules;
    data['facilities'] = this.facilities;
    if (this.review != null) {
      data['review'] = this.review!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booking {
  int? bookingId;
  String? bookingNo;
  String? propertyType;
  String? propertyName;
  String? propertyAddress;
  String? checkInDate;
  String? checkInTime;
  String? checkOutDate;
  String? checkOutTime;
  String? nights;
  String? stayDetails;
  List<String>? rules;
  List<String>? images;
  String? userName;
  String? status;

  Booking(
      {this.bookingId,
        this.bookingNo,
        this.propertyType,
        this.propertyName,
        this.propertyAddress,
        this.checkInDate,
        this.checkInTime,
        this.checkOutDate,
        this.checkOutTime,
        this.nights,
        this.stayDetails,
        this.rules,
        this.images,
        this.userName,
        this.status});

  Booking.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingNo = json['booking_no'];
    propertyType = json['property_type'];
    propertyName = json['property_name'];
    propertyAddress = json['property_address'];
    checkInDate = json['check_in_date'];
    checkInTime = json['check_in_time'];
    checkOutDate = json['check_out_date'];
    checkOutTime = json['check_out_time'];
    nights = json['nights'];
    stayDetails = json['stay_details'];
    rules = json['rules'].cast<String>();
    images = json['images'].cast<String>();
    userName = json['user_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_no'] = this.bookingNo;
    data['property_type'] = this.propertyType;
    data['property_name'] = this.propertyName;
    data['property_address'] = this.propertyAddress;
    data['check_in_date'] = this.checkInDate;
    data['check_in_time'] = this.checkInTime;
    data['check_out_date'] = this.checkOutDate;
    data['check_out_time'] = this.checkOutTime;
    data['nights'] = this.nights;
    data['stay_details'] = this.stayDetails;
    data['rules'] = this.rules;
    data['images'] = this.images;
    data['user_name'] = this.userName;
    data['status'] = this.status;
    return data;
  }
}

class Payments {
  int? id;
  String? bookingId;
  String? currency;
  String? gateway;
  String? gatewayTransactionId;
  String? paymentType;
  String? basePrice;
  String? miscFee;
  String? discount;
  String? totalAmount;
  String? advanceAmount;
  String? balanceAmount;
  String? balanceCollectAt;

  Payments(
      {this.id,
        this.bookingId,
        this.currency,
        this.gateway,
        this.gatewayTransactionId,
        this.paymentType,
        this.basePrice,
        this.miscFee,
        this.discount,
        this.totalAmount,
        this.advanceAmount,
        this.balanceAmount,
        this.balanceCollectAt});

  Payments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    currency = json['currency'];
    gateway = json['gateway'];
    gatewayTransactionId = json['gateway_transaction_id'];
    paymentType = json['payment_type'];
    basePrice = json['base_price'];
    miscFee = json['misc_fee'];
    discount = json['discount'];
    totalAmount = json['total_amount'];
    advanceAmount = json['advance_amount'];
    balanceAmount = json['balance_amount'];
    balanceCollectAt = json['balance_collect_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['currency'] = this.currency;
    data['gateway'] = this.gateway;
    data['gateway_transaction_id'] = this.gatewayTransactionId;
    data['payment_type'] = this.paymentType;
    data['base_price'] = this.basePrice;
    data['misc_fee'] = this.miscFee;
    data['discount'] = this.discount;
    data['total_amount'] = this.totalAmount;
    data['advance_amount'] = this.advanceAmount;
    data['balance_amount'] = this.balanceAmount;
    data['balance_collect_at'] = this.balanceCollectAt;
    return data;
  }
}

class Review {
  int? id;
  int? rating;
  String? title;
  String? review;

  Review({this.id, this.rating, this.title, this.review});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    title = json['title'];
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['title'] = this.title;
    data['review'] = this.review;
    return data;
  }
}
