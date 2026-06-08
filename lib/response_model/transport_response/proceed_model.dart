class ProceedModel {
  bool? status;
  String? message;
  Data? data;

  ProceedModel({this.status, this.message, this.data});

  ProceedModel.fromJson(Map<String, dynamic> json) {
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
  String? boardingCity;
  String? droppingCity;
  BoardingPoint? boardingPoint;
  BoardingPoint? droppingPoint;
  List<String>? selectedSeats;
  int? selectedSeatCount;
  String? currency;
  int? seatPrice;

  Data(
      {this.busRouteId,
        this.busId,
        this.companyName,
        this.boardingCity,
        this.droppingCity,
        this.boardingPoint,
        this.droppingPoint,
        this.selectedSeats,
        this.selectedSeatCount,
        this.currency,
        this.seatPrice});

  Data.fromJson(Map<String, dynamic> json) {
    busRouteId = json['bus_route_id'];
    busId = json['bus_id'];
    companyName = json['company_name'];
    boardingCity = json['boarding_city'];
    droppingCity = json['dropping_city'];
    boardingPoint = json['boarding_point'] != null
        ? new BoardingPoint.fromJson(json['boarding_point'])
        : null;
    droppingPoint = json['dropping_point'] != null
        ? new BoardingPoint.fromJson(json['dropping_point'])
        : null;
    selectedSeats = json['selected_seats'].cast<String>();
    selectedSeatCount = json['selected_seat_count'];
    currency = json['currency'];
    seatPrice = json['seat_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bus_route_id'] = this.busRouteId;
    data['bus_id'] = this.busId;
    data['company_name'] = this.companyName;
    data['boarding_city'] = this.boardingCity;
    data['dropping_city'] = this.droppingCity;
    if (this.boardingPoint != null) {
      data['boarding_point'] = this.boardingPoint!.toJson();
    }
    if (this.droppingPoint != null) {
      data['dropping_point'] = this.droppingPoint!.toJson();
    }
    data['selected_seats'] = this.selectedSeats;
    data['selected_seat_count'] = this.selectedSeatCount;
    data['currency'] = this.currency;
    data['seat_price'] = this.seatPrice;
    return data;
  }
}

class BoardingPoint {
  int? id;
  String? name;
  String? date;
  String? time;
  String? address;

  BoardingPoint({this.id, this.name, this.date, this.time, this.address});

  BoardingPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['date'];
    time = json['time'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['date'] = this.date;
    data['time'] = this.time;
    data['address'] = this.address;
    return data;
  }
}
