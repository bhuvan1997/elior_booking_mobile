import 'dart:convert';

class BusListResponse {
  final bool? status;
  final String? message;
  final List<BusModel>? data;

  BusListResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BusListResponse.fromJson(Map<String, dynamic> json) {
    return BusListResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => BusModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class BusModel {
  final int? busRouteId;
  final String? companyName;
  final String? companyLogo;
  final String? busTypeName;
  final int? busId;
  final String? registrationNo;
  final String? model;
  final int? totalSeats;

  final List<String>? images;
  final List<String>? features;

  final String? origin;
  final String? destination;
  final String? distanceKm;

  final String? departureDatetime;
  final String? arrivalDatetime;

  final String? currency;
  final num? fareBase;

  final int? durationMinutes;
  final String? durationHuman;

  BusModel({
    this.busRouteId,
    this.companyName,
    this.companyLogo,
    this.busTypeName,
    this.busId,
    this.registrationNo,
    this.model,
    this.totalSeats,
    this.images,
    this.features,
    this.origin,
    this.destination,
    this.distanceKm,
    this.departureDatetime,
    this.arrivalDatetime,
    this.currency,
    this.fareBase,
    this.durationMinutes,
    this.durationHuman,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      busRouteId: json['bus_routeId'],
      companyName: json['company_name'],
      companyLogo: json['company_logo'],
      busTypeName: json['bus_type_name'],
      busId: json['busId'],
      registrationNo: json['registration_no'],
      model: json['model'],
      totalSeats: json['total_seats'],

      images: _parseStringList(json['image']),
      features: _parseStringList(json['features']),

      origin: json['origin'],
      destination: json['destination'],
      distanceKm: json['distance_km'],
      departureDatetime: json['departure_datetime'],
      arrivalDatetime: json['arrival_datetime'],
      currency: json['currency'],
      fareBase: json['fare_base'],
      durationMinutes: json['duration_minutes'],
      durationHuman: json['duration_human'],
    );
  }

  Map<String, dynamic> toJson() => {
    'bus_routeId': busRouteId,
    'company_name': companyName,
    'company_logo': companyLogo,
    'bus_type_name': busTypeName,
    'busId': busId,
    'registration_no': registrationNo,
    'model': model,
    'total_seats': totalSeats,
    'image': images,
    'features': features,
    'origin': origin,
    'destination': destination,
    'distance_km': distanceKm,
    'departure_datetime': departureDatetime,
    'arrival_datetime': arrivalDatetime,
    'currency': currency,
    'fare_base': fareBase,
    'duration_minutes': durationMinutes,
    'duration_human': durationHuman,
  };

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return List<String>.from(value);
    }

    try {
      return List<String>.from(jsonDecode(value));
    } catch (_) {
      return [];
    }
  }
}

extension BusModelExtension on BusModel {
  String get route => '$origin → $destination';

  String get fareText => '$currency $fareBase';

  String get busName => '$companyName • $model';

  String get departureTime =>
      departureDatetime?.split(' ').last.substring(0, 5) ?? '';

  String get arrivalTime =>
      arrivalDatetime?.split(' ').last.substring(0, 5) ?? '';
}