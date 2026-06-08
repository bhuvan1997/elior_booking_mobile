class BusPikUpModel {
  bool? status;
  String? message;
  Data? data;

  BusPikUpModel({this.status, this.message, this.data});

  BusPikUpModel.fromJson(Map<String, dynamic> json) {
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
  String? boardingCity;
  String? droppingCity;
  BoardingPoint? boardingPoint;
  DroppingPoint? droppingPoint;

  Data(
      {this.busRouteId,
        this.busId,
        this.boardingCity,
        this.droppingCity,
        this.boardingPoint,
        this.droppingPoint});

  Data.fromJson(Map<String, dynamic> json) {
    busRouteId = json['bus_route_id'];
    busId = json['bus_id'];
    boardingCity = json['boardingCity'];
    droppingCity = json['droppingCity'];
    boardingPoint = json['boardingPoint'] != null
        ? new BoardingPoint.fromJson(json['boardingPoint'])
        : null;
    droppingPoint = json['droppingPoint'] != null
        ? new DroppingPoint.fromJson(json['droppingPoint'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bus_route_id'] = this.busRouteId;
    data['bus_id'] = this.busId;
    data['boardingCity'] = this.boardingCity;
    data['droppingCity'] = this.droppingCity;
    if (this.boardingPoint != null) {
      data['boardingPoint'] = this.boardingPoint!.toJson();
    }
    if (this.droppingPoint != null) {
      data['droppingPoint'] = this.droppingPoint!.toJson();
    }
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
