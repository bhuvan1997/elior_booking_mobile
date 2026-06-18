class BusSeatLayoutResponse {
  final bool? status;
  final String? message;
  final BusSeatLayoutData? data;

  BusSeatLayoutResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BusSeatLayoutResponse.fromJson(Map<String, dynamic> json) {
    return BusSeatLayoutResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? BusSeatLayoutData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

class BusSeatLayoutData {
  final int? busRouteId;
  final int? busId;
  final String? companyName;
  final String? busModel;
  final String? busType;
  final String? currency;
  final int? fare;

  final List<SeatModel>? seats;
  final BusBookHighlight? busBookHighlight;
  final BusRouteModel? busRoute;
  final BoardingPointModel? boardingPoint;
  final DroppingPointModel? droppingPoint;
  final List<String>? busFeatures;

  BusSeatLayoutData({
    this.busRouteId,
    this.busId,
    this.companyName,
    this.busModel,
    this.busType,
    this.currency,
    this.fare,
    this.seats,
    this.busBookHighlight,
    this.busRoute,
    this.boardingPoint,
    this.droppingPoint,
    this.busFeatures,
  });

  factory BusSeatLayoutData.fromJson(Map<String, dynamic> json) {
    return BusSeatLayoutData(
      busRouteId: json['bus_route_id'],
      busId: json['bus_id'],
      companyName: json['company_name'],
      busModel: json['bus_model'],
      busType: json['bus_type'],
      currency: json['currency'],
      fare: json['fare'],
      seats: (json['seats'] as List?)
          ?.map((e) => SeatModel.fromJson(e))
          .toList(),
      busBookHighlight: json['busBookHighlight'] != null
          ? BusBookHighlight.fromJson(json['busBookHighlight'])
          : null,
      busRoute: json['busRoute'] != null
          ? BusRouteModel.fromJson(json['busRoute'])
          : null,
      boardingPoint: json['boardingPoint'] != null
          ? BoardingPointModel.fromJson(json['boardingPoint'])
          : null,
      droppingPoint: json['droppingPoint'] != null
          ? DroppingPointModel.fromJson(json['droppingPoint'])
          : null,
      busFeatures: List<String>.from(json['bus_features'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'bus_route_id': busRouteId,
    'bus_id': busId,
    'company_name': companyName,
    'bus_model': busModel,
    'bus_type': busType,
    'currency': currency,
    'fare': fare,
    'seats': seats?.map((e) => e.toJson()).toList(),
    'busBookHighlight': busBookHighlight?.toJson(),
    'busRoute': busRoute?.toJson(),
    'boardingPoint': boardingPoint?.toJson(),
    'droppingPoint': droppingPoint?.toJson(),
    'bus_features': busFeatures,
  };
}

class SeatModel {
  final String? seatNo;
  final String? type;
  final String? deck;
  final int? row;
  final int? col;
  final bool? isWindow;
  final int? extraFare;
  final String? status;
  final bool? isBooked;

  SeatModel({
    this.seatNo,
    this.type,
    this.deck,
    this.row,
    this.col,
    this.isWindow,
    this.extraFare,
    this.status,
    this.isBooked,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      seatNo: json['seat_no'],
      type: json['type'],
      deck: json['deck'],
      row: json['row'],
      col: json['col'],
      isWindow: json['is_window'],
      extraFare: json['extra_fare'],
      status: json['status'],
      isBooked: json['is_booked'],
    );
  }

  Map<String, dynamic> toJson() => {
    'seat_no': seatNo,
    'type': type,
    'deck': deck,
    'row': row,
    'col': col,
    'is_window': isWindow,
    'extra_fare': extraFare,
    'status': status,
    'is_booked': isBooked,
  };
}

class BusBookHighlight {
  final String? departureTime;
  final String? arrivalTime;
  final String? departureDate;
  final List<String>? busImages;

  BusBookHighlight({
    this.departureTime,
    this.arrivalTime,
    this.departureDate,
    this.busImages,
  });

  factory BusBookHighlight.fromJson(Map<String, dynamic> json) {
    return BusBookHighlight(
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
      departureDate: json['departure_date'],
      busImages: List<String>.from(json['busImages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'departure_time': departureTime,
    'arrival_time': arrivalTime,
    'departure_date': departureDate,
    'busImages': busImages,
  };
}

class BusRouteModel {
  final String? routeName;
  final String? arrivalTime;
  final String? timeDifference;

  BusRouteModel({
    this.routeName,
    this.arrivalTime,
    this.timeDifference,
  });

  factory BusRouteModel.fromJson(Map<String, dynamic> json) {
    return BusRouteModel(
      routeName: json['route_name'],
      arrivalTime: json['arrival_time'],
      timeDifference: json['time_difference'],
    );
  }

  Map<String, dynamic> toJson() => {
    'route_name': routeName,
    'arrival_time': arrivalTime,
    'time_difference': timeDifference,
  };
}

class BoardingPointModel {
  final String? boardingPointCity;
  final List<PointStop>? boardingPointStops;

  BoardingPointModel({
    this.boardingPointCity,
    this.boardingPointStops,
  });

  factory BoardingPointModel.fromJson(Map<String, dynamic> json) {
    return BoardingPointModel(
      boardingPointCity: json['boarding_point_city'],
      boardingPointStops: (json['boardingPointStops'] as List?)
          ?.map((e) => PointStop.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'boarding_point_city': boardingPointCity,
    'boardingPointStops':
    boardingPointStops?.map((e) => e.toJson()).toList(),
  };
}

class DroppingPointModel {
  final String? droppingPointCity;
  final List<PointStop>? droppingPointStops;

  DroppingPointModel({
    this.droppingPointCity,
    this.droppingPointStops,
  });

  factory DroppingPointModel.fromJson(Map<String, dynamic> json) {
    return DroppingPointModel(
      droppingPointCity: json['dropping_point_city'],
      droppingPointStops: (json['droppingPointStops'] as List?)
          ?.map((e) => PointStop.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'dropping_point_city': droppingPointCity,
    'droppingPointStops':
    droppingPointStops?.map((e) => e.toJson()).toList(),
  };
}

class PointStop {
  final int? pointId;
  final String? pointName;
  final String? date;
  final String? time;
  final String? address;

  PointStop({
    this.pointId,
    this.pointName,
    this.date,
    this.time,
    this.address,
  });

  factory PointStop.fromJson(Map<String, dynamic> json) {
    return PointStop(
      pointId: json['point_id'],
      pointName: json['pointname'],
      date: json['date'],
      time: json['time'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
    'point_id': pointId,
    'pointname': pointName,
    'date': date,
    'time': time,
    'address': address,
  };
}

extension SeatLayoutExtension on List<SeatModel> {
  int get maxRow =>
      isEmpty ? 0 : map((e) => e.row ?? 0).reduce((a, b) => a > b ? a : b);

  int get maxCol =>
      isEmpty ? 0 : map((e) => e.col ?? 0).reduce((a, b) => a > b ? a : b);
}