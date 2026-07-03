class BusBookingResponse {
  final bool? status;
  final String? message;
  final BookingData? data;

  BusBookingResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BusBookingResponse.fromJson(Map<String, dynamic> json) {
    return BusBookingResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? BookingData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class BookingData {
  final int? type;
  final int? bookingId;
  final int? busRouteId;
  final int? busId;
  final String? bookingNo;
  final String? companyName;
  final String? boardingCity;
  final String? droppingCity;
  final BoardingPoint? boardingPoint;
  final DroppingPoint? droppingPoint;
  final List<String>? selectedSeats;
  final int? selectedSeatCount;
  final String? currency;
  final int? seatPrice;
  final List<PassengerData>? passengerData;
  final String? bookingTime;

  BookingData({
    this.type,
    this.bookingId,
    this.busRouteId,
    this.busId,
    this.bookingNo,
    this.companyName,
    this.boardingCity,
    this.droppingCity,
    this.boardingPoint,
    this.droppingPoint,
    this.selectedSeats,
    this.selectedSeatCount,
    this.currency,
    this.seatPrice,
    this.passengerData,
    this.bookingTime,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      type: json['type'],
      bookingId: json['bookingId'],
      busRouteId: json['bus_route_id'],
      busId: json['bus_id'],
      bookingNo: json['booking_no'],
      companyName: json['company_name'],
      boardingCity: json['boarding_city'],
      droppingCity: json['dropping_city'],
      boardingPoint: json['boarding_point'] != null
          ? BoardingPoint.fromJson(json['boarding_point'])
          : null,
      droppingPoint: json['dropping_point'] != null
          ? DroppingPoint.fromJson(json['dropping_point'])
          : null,
      selectedSeats: json['selected_seats'] != null
          ? List<String>.from(json['selected_seats'])
          : [],
      selectedSeatCount: json['selected_seat_count'],
      currency: json['currency'],
      seatPrice: json['seat_price'],
      passengerData: json['passenger_data'] != null
          ? (json['passenger_data'] as List)
          .map((e) => PassengerData.fromJson(e))
          .toList()
          : [],
      bookingTime: json['booking_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'bookingId': bookingId,
      'bus_route_id': busRouteId,
      'bus_id': busId,
      'booking_no': bookingNo,
      'company_name': companyName,
      'boarding_city': boardingCity,
      'dropping_city': droppingCity,
      'boarding_point': boardingPoint?.toJson(),
      'dropping_point': droppingPoint?.toJson(),
      'selected_seats': selectedSeats,
      'selected_seat_count': selectedSeatCount,
      'currency': currency,
      'seat_price': seatPrice,
      'passenger_data': passengerData?.map((e) => e.toJson()).toList(),
      'booking_time': bookingTime,
    };
  }
}

class BoardingPoint {
  final int? id;
  final String? name;
  final String? date;
  final String? time;
  final String? address;

  BoardingPoint({
    this.id,
    this.name,
    this.date,
    this.time,
    this.address,
  });

  factory BoardingPoint.fromJson(Map<String, dynamic> json) {
    return BoardingPoint(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'address': address,
    };
  }
}

class DroppingPoint {
  final int? id;
  final String? name;
  final String? date;
  final String? time;
  final String? address;

  DroppingPoint({
    this.id,
    this.name,
    this.date,
    this.time,
    this.address,
  });

  factory DroppingPoint.fromJson(Map<String, dynamic> json) {
    return DroppingPoint(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'address': address,
    };
  }
}

class PassengerData {
  final String? seatNo;
  final String? name;
  final String? age;
  final String? gender;

  PassengerData({
    this.seatNo,
    this.name,
    this.age,
    this.gender,
  });

  factory PassengerData.fromJson(Map<String, dynamic> json) {
    return PassengerData(
      seatNo: json['seat_no'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seat_no': seatNo,
      'name': name,
      'age': age,
      'gender': gender,
    };
  }
}