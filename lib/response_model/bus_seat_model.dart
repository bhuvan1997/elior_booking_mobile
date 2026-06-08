class BusSeatModel {
  bool? status;
  String? message;
  Data? data;

  BusSeatModel({this.status, this.message, this.data});

  BusSeatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? busRouteId;
  int? busId;
  String? currency;
  String? fare;
  List<Seats>? seats;
  BusBookHighlight? busBookHighlight;
  BusRoute? busRoute;
  BoardingPoint? boardingPoint;
  DroppingPoint? droppingPoint;
  List<String>? busFeatures;

  Data({
    this.busRouteId,
    this.busId,
    this.currency,
    this.fare,
    this.seats,
    this.busBookHighlight,
    this.busRoute,
    this.boardingPoint,
    this.droppingPoint,
    this.busFeatures,
  });

  Data.fromJson(Map<String, dynamic> json) {
    busRouteId = json['bus_route_id'];
    busId = json['bus_id'];
    currency = json['currency'];
    fare = json['fare'];
    if (json['seats'] != null) {
      seats = <Seats>[];
      json['seats'].forEach((v) {
        seats!.add(Seats.fromJson(v));
      });
    }
    busBookHighlight = json['busBookHighlight'] != null
        ? BusBookHighlight.fromJson(json['busBookHighlight'])
        : null;
    busRoute =
    json['busRoute'] != null ? BusRoute.fromJson(json['busRoute']) : null;
    boardingPoint = json['boardingPoint'] != null
        ? BoardingPoint.fromJson(json['boardingPoint'])
        : null;
    droppingPoint = json['droppingPoint'] != null
        ? DroppingPoint.fromJson(json['droppingPoint'])
        : null;
    busFeatures = (json['bus_features'] as List?)
        ?.map((e) => e.toString())
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bus_route_id'] = busRouteId;
    data['bus_id'] = busId;
    data['currency'] = currency;
    data['fare'] = fare;
    if (seats != null) {
      data['seats'] = seats!.map((v) => v.toJson()).toList();
    }
    if (busBookHighlight != null) {
      data['busBookHighlight'] = busBookHighlight!.toJson();
    }
    if (busRoute != null) {
      data['busRoute'] = busRoute!.toJson();
    }
    if (boardingPoint != null) {
      data['boardingPoint'] = boardingPoint!.toJson();
    }
    if (droppingPoint != null) {
      data['droppingPoint'] = droppingPoint!.toJson();
    }
    data['bus_features'] = busFeatures;
    return data;
  }
}

class Seats {
  String? seatNo;
  String? type;
  String? deck;
  int? row;
  int? col;
  bool? isWindow;
  int? extraFare;
  String? status;
  bool? isBooked;

  Seats({
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

  Seats.fromJson(Map<String, dynamic> json) {
    seatNo = json['seat_no'];
    type = json['type'];
    deck = json['deck'];
    row = json['row'];
    col = json['col'];
    isWindow = json['is_window'];
    extraFare = json['extra_fare'];
    status = json['status'];
    isBooked = json['is_booked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seat_no'] = seatNo;
    data['type'] = type;
    data['deck'] = deck;
    data['row'] = row;
    data['col'] = col;
    data['is_window'] = isWindow;
    data['extra_fare'] = extraFare;
    data['status'] = status;
    data['is_booked'] = isBooked;
    return data;
  }
}

class BusBookHighlight {
  String? departureTime;
  String? arrivalTime;
  String? departureDate;
  List<String>? busImages;

  BusBookHighlight({
    this.departureTime,
    this.arrivalTime,
    this.departureDate,
    this.busImages,
  });

  BusBookHighlight.fromJson(Map<String, dynamic> json) {
    departureTime = json['departure_time'];
    arrivalTime = json['arrival_time'];
    departureDate = json['departure_date'];
    busImages =
        (json['busImages'] as List?)?.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['departure_time'] = departureTime;
    data['arrival_time'] = arrivalTime;
    data['departure_date'] = departureDate;
    data['busImages'] = busImages;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['route_name'] = routeName;
    data['arrival_time'] = arrivalTime;
    data['time_difference'] = timeDifference;
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
        boardingPointStops!.add(BoardingPointStops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['boarding_point_city'] = boardingPointCity;
    if (boardingPointStops != null) {
      data['boardingPointStops'] =
          boardingPointStops!.map((v) => v.toJson()).toList();
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

  BoardingPointStops({
    this.pointId,
    this.pointname,
    this.date,
    this.time,
    this.address,
  });

  BoardingPointStops.fromJson(Map<String, dynamic> json) {
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

class DroppingPoint {
  String? droppingPointCity;
  List<DroppingPointStops>? droppingPointStops;

  DroppingPoint({this.droppingPointCity, this.droppingPointStops});

  DroppingPoint.fromJson(Map<String, dynamic> json) {
    droppingPointCity = json['dropping_point_city'];
    if (json['droppingPointStops'] != null) {
      droppingPointStops = <DroppingPointStops>[];
      json['droppingPointStops'].forEach((v) {
        droppingPointStops!.add(DroppingPointStops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dropping_point_city'] = droppingPointCity;
    if (droppingPointStops != null) {
      data['droppingPointStops'] =
          droppingPointStops!.map((v) => v.toJson()).toList();
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
