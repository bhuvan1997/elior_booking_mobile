class BusRouteModel {
  bool? status;
  String? message;
  List<Data>? data;

  BusRouteModel({this.status, this.message, this.data});

  BusRouteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? busRouteId;
  String? companyName;
  String? companyLogo;
  String? busTypeName;
  int? busId;
  String? registrationNo;
  String? model;
  int? totalSeats;
  String? image;
  String? features;
  String? origin;
  String? destination;
  String? distanceKm;
  String? departureDatetime;
  String? arrivalDatetime;
  String? fareBase;
  String? currency;

  Data(
      {this.busRouteId,
        this.companyName,
        this.companyLogo,
        this.busTypeName,
        this.busId,
        this.registrationNo,
        this.model,
        this.totalSeats,
        this.image,
        this.features,
        this.origin,
        this.destination,
        this.distanceKm,
        this.departureDatetime,
        this.arrivalDatetime,
        this.fareBase,
        this.currency

      });

  Data.fromJson(Map<String, dynamic> json) {
    busRouteId = json['bus_routeId'];
    companyName = json['company_name'];
    companyLogo = json['company_logo'];
    busTypeName = json['bus_type_name'];
    busId = json['busId'];
    registrationNo = json['registration_no'];
    model = json['model'];
    totalSeats = json['total_seats'];
    image = json['image'];
    features = json['features'];
    origin = json['origin'];
    destination = json['destination'];
    distanceKm = json['distance_km'];
    departureDatetime = json['departure_datetime'];
    arrivalDatetime = json['arrival_datetime'];
    fareBase = json['fare_base'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bus_routeId'] = this.busRouteId;
    data['company_name'] = this.companyName;
    data['company_logo'] = this.companyLogo;
    data['bus_type_name'] = this.busTypeName;
    data['busId'] = this.busId;
    data['registration_no'] = this.registrationNo;
    data['model'] = this.model;
    data['total_seats'] = this.totalSeats;
    data['image'] = this.image;
    data['features'] = this.features;
    data['origin'] = this.origin;
    data['destination'] = this.destination;
    data['distance_km'] = this.distanceKm;
    data['departure_datetime'] = this.departureDatetime;
    data['arrival_datetime'] = this.arrivalDatetime;
    data['currency'] = this.currency;
    return data;
  }
}
