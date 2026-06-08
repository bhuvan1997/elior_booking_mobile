class BusSeatBottomModel {
  bool? status;
  String? message;
  Data? data;

  BusSeatBottomModel({this.status, this.message, this.data});

  BusSeatBottomModel.fromJson(Map<String, dynamic> json) {
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
  int? busRouteId;
  int? busId;
  String? companyName;
  String? busModel;
  String? busType;
  String? currency;
  String? fare;
  BusBookHighlight? busBookHighlight;
  BusRoute? busRoute;
  BoardingPoint? boardingPoint;
  DroppingPoint? droppingPoint;
  List<String>? busFeatures;

  Data(
      {this.busRouteId,
        this.busId,
        this.companyName,
        this.busModel,
        this.busType,
        this.currency,
        this.fare,
        this.busBookHighlight,
        this.busRoute,
        this.boardingPoint,
        this.droppingPoint,
        this.busFeatures});

  Data.fromJson(Map<String, dynamic> json) {
    busRouteId = json['bus_route_id'];
    busId = json['bus_id'];
    companyName = json['company_name'];
    busModel = json['bus_model'];
    busType = json['bus_type'];
    currency = json['currency'];
    fare = json['fare'];
    busBookHighlight = json['busBookHighlight'] != null
        ? new BusBookHighlight.fromJson(json['busBookHighlight'])
        : null;
    busRoute = json['busRoute'] != null
        ? new BusRoute.fromJson(json['busRoute'])
        : null;
    boardingPoint = json['boardingPoint'] != null
        ? new BoardingPoint.fromJson(json['boardingPoint'])
        : null;
    droppingPoint = json['droppingPoint'] != null
        ? new DroppingPoint.fromJson(json['droppingPoint'])
        : null;
    busFeatures = json['bus_features'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bus_route_id'] = this.busRouteId;
    data['bus_id'] = this.busId;
    data['company_name'] = this.companyName;
    data['bus_model'] = this.busModel;
    data['bus_type'] = this.busType;
    data['currency'] = this.currency;
    data['fare'] = this.fare;
    if (this.busBookHighlight != null) {
      data['busBookHighlight'] = this.busBookHighlight!.toJson();
    }
    if (this.busRoute != null) {
      data['busRoute'] = this.busRoute!.toJson();
    }
    if (this.boardingPoint != null) {
      data['boardingPoint'] = this.boardingPoint!.toJson();
    }
    if (this.droppingPoint != null) {
      data['droppingPoint'] = this.droppingPoint!.toJson();
    }
    data['bus_features'] = this.busFeatures;
    return data;
  }
}

class BusBookHighlight {
  String? departureTime;
  String? arrivalTime;
  String? departureDate;
  List<String>? busImages;

  BusBookHighlight(
      {this.departureTime,
        this.arrivalTime,
        this.departureDate,
        this.busImages});

  BusBookHighlight.fromJson(Map<String, dynamic> json) {
    departureTime = json['departure_time'];
    arrivalTime = json['arrival_time'];
    departureDate = json['departure_date'];
    busImages = json['busImages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departure_time'] = this.departureTime;
    data['arrival_time'] = this.arrivalTime;
    data['departure_date'] = this.departureDate;
    data['busImages'] = this.busImages;
    return data;
  }
}

class BusRoute {
  String? routeName;
  String? arrivalTime;
  String? timeDifference;

  BusRoute({this.routeName, this.arrivalTime, this.timeDifference});

  BusRoute.fromJson(Map<String, dynamic> json) {
    routeName = json['route_name'];
    arrivalTime = json['arrival_time'];
    timeDifference = json['time_difference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route_name'] = this.routeName;
    data['arrival_time'] = this.arrivalTime;
    data['time_difference'] = this.timeDifference;
    return data;
  }
}

class BoardingPoint {
  String? boardingPointCity;
  List<BoardingPointStops>? boardingPointStops;

  BoardingPoint({this.boardingPointCity, this.boardingPointStops});

  BoardingPoint.fromJson(Map<String, dynamic> json) {
    boardingPointCity = json['boarding_point_city'];
    if (json['boardingPointStops'] != null) {
      boardingPointStops = <BoardingPointStops>[];
      json['boardingPointStops'].forEach((v) {
        boardingPointStops!.add(new BoardingPointStops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boarding_point_city'] = this.boardingPointCity;
    if (this.boardingPointStops != null) {
      data['boardingPointStops'] =
          this.boardingPointStops!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BoardingPointStops {
  int? pointId;
  String? pointname;
  String? date;
  String? time;
  String? address;

  BoardingPointStops(
      {this.pointId, this.pointname, this.date, this.time, this.address});

  BoardingPointStops.fromJson(Map<String, dynamic> json) {
    pointId = json['point_id'];
    pointname = json['pointname'];
    date = json['date'];
    time = json['time'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['point_id'] = this.pointId;
    data['pointname'] = this.pointname;
    data['date'] = this.date;
    data['time'] = this.time;
    data['address'] = this.address;
    return data;
  }
}

class DroppingPoint {
  String? droppingPointCity;
  List<DroppingPointStops>? droppingPointStops;

  DroppingPoint({this.droppingPointCity, this.droppingPointStops});

  DroppingPoint.fromJson(Map<String, dynamic> json) {
    droppingPointCity = json['dropping_point_city'];
    if (json['droppingPointStops'] != null) {
      droppingPointStops = <DroppingPointStops>[];
      json['droppingPointStops'].forEach((v) {
        droppingPointStops!.add(new DroppingPointStops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dropping_point_city'] = this.droppingPointCity;
    if (this.droppingPointStops != null) {
      data['droppingPointStops'] =
          this.droppingPointStops!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
class DroppingPointStops {
  int? pointId;
  String? pointname;
  String? date;
  String? time;
  String? address;

  DroppingPointStops({
    this.pointId,
    this.pointname,
    this.date,
    this.time,
    this.address,
  });

  DroppingPointStops.fromJson(Map<String, dynamic> json) {
    pointId = json['point_id'];
    pointname = json['pointname'];
    date = json['date'];
    time = json['time'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['point_id'] = pointId;
    data['pointname'] = pointname;
    data['date'] = date;
    data['time'] = time;
    data['address'] = address;
    return data;
  }
}

