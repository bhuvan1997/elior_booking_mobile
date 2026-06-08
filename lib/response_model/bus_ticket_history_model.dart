class BusIicketHistoryModel {
  bool? status;
  String? message;
  Data? data;

  BusIicketHistoryModel({this.status, this.message, this.data});

  BusIicketHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<Review>? review;

  Data({this.booking, this.review});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['booking'] != null) {
      booking = <Booking>[];
      json['booking'].forEach((v) {
        booking!.add(new Booking.fromJson(v));
      });
    }
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
    if (this.review != null) {
      data['review'] = this.review!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booking {
  int? bookingId;
  String? bookingNo;
  String? bookingStatus;
  String? originname;
  String? boardingName;
  String? destinantionname;
  String? droppingName;
  String? departureTime;
  String? departureDatetime;
  String? arrivalTime;
  String? arrivalDatetime;
  String? companyName;
  String? busType;
  String? registrationNo;
  int? seatCount;
  String? gateway;
  String? gatewayTransactionId;
  String? currency;
  String? fareTotal;
  List<PassengersFormatted>? passengersFormatted;

  Booking({
    this.bookingId,
    this.bookingNo,
    this.bookingStatus,
    this.originname,
    this.boardingName,
    this.destinantionname,
    this.droppingName,
    this.departureTime,
    this.departureDatetime,
    this.arrivalTime,
    this.arrivalDatetime,
    this.companyName,
    this.busType,
    this.registrationNo,
    this.seatCount,
    this.gateway,
    this.gatewayTransactionId,
    this.currency,
    this.fareTotal,
    this.passengersFormatted,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingNo = json['booking_no'];
    bookingStatus = json['booking_status'];
    originname = json['originname'];
    boardingName = json['boarding_name'];
    destinantionname = json['destinantionname'];
    droppingName = json['dropping_name'];
    departureTime = json['departure_time'];
    departureDatetime = json['departure_datetime'];
    arrivalTime = json['arrival_time'];
    arrivalDatetime = json['arrival_datetime'];
    companyName = json['company_name'];
    busType = json['bus_type'];
    registrationNo = json['registration_no'];
    seatCount = json['seat_count'];
    gateway = json['gateway'];
    gatewayTransactionId = json['gateway_transaction_id'];
    currency = json['currency'];
    fareTotal = json['fare_total'];
    if (json['passengers_formatted'] != null) {
      passengersFormatted = <PassengersFormatted>[];
      json['passengers_formatted'].forEach((v) {
        passengersFormatted!.add(new PassengersFormatted.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_no'] = this.bookingNo;
    data['booking_status'] = this.bookingStatus;
    data['originname'] = this.originname;
    data['boarding_name'] = this.boardingName;
    data['destinantionname'] = this.destinantionname;
    data['dropping_name'] = this.droppingName;
    data['departure_time'] = this.departureTime;
    data['departure_datetime'] = this.departureDatetime;
    data['arrival_time'] = this.arrivalTime;
    data['arrival_datetime'] = this.arrivalDatetime;
    data['company_name'] = this.companyName;
    data['bus_type'] = this.busType;
    data['registration_no'] = this.registrationNo;
    data['seat_count'] = this.seatCount;
    data['gateway'] = this.gateway;
    data['gateway_transaction_id'] = this.gatewayTransactionId;
    data['currency'] = this.currency;
    data['fare_total'] = this.fareTotal;
    if (this.passengersFormatted != null) {
      data['passengers_formatted'] = this.passengersFormatted!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class PassengersFormatted {
  String? text;

  PassengersFormatted({this.text});

  PassengersFormatted.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
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
