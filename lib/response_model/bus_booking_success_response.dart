class BusBookingSuccessResponse {
  final bool? status;
  final String? message;
  final BookingResult? result;

  BusBookingSuccessResponse({
    this.status,
    this.message,
    this.result,
  });

  factory BusBookingSuccessResponse.fromJson(Map<String, dynamic> json) {
    return BusBookingSuccessResponse(
      status: json['status'],
      message: json['message'],
      result: json['result'] != null
          ? BookingResult.fromJson(json['result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result?.toJson(),
    };
  }
}

class BookingResult {
  final String? transactionId;
  final String? bookingAt;
  final String? bookingNo;
  final BookingData? data;

  BookingResult({
    this.transactionId,
    this.bookingAt,
    this.bookingNo,
    this.data,
  });

  factory BookingResult.fromJson(Map<String, dynamic> json) {
    return BookingResult(
      transactionId: json['transactionId'],
      bookingAt: json['booking_at'],
      bookingNo: json['bookingno'],
      data: json['data'] != null
          ? BookingData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'booking_at': bookingAt,
      'bookingno': bookingNo,
      'data': data?.toJson(),
    };
  }
}

class BookingData {
  final String? pnr;
  final String? origin;
  final String? destination;
  final String? companyName;
  final String? model;
  final String? currency;
  final String? fareTotal;
  final String? departureDatetime;

  BookingData({
    this.pnr,
    this.origin,
    this.destination,
    this.companyName,
    this.model,
    this.currency,
    this.fareTotal,
    this.departureDatetime,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      pnr: json['pnr'],
      origin: json['origin'],
      destination: json['destination'],
      companyName: json['company_name'],
      model: json['model'],
      currency: json['currency'],
      fareTotal: json['fare_total'],
      departureDatetime: json['departure_datetime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pnr': pnr,
      'origin': origin,
      'destination': destination,
      'company_name': companyName,
      'model': model,
      'currency': currency,
      'fare_total': fareTotal,
      'departure_datetime': departureDatetime,
    };
  }
}