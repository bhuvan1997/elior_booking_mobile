class BusHistoryModel {
  bool? status;
  String? message;
  List<Data>? data;

  BusHistoryModel({this.status, this.message, this.data});

  BusHistoryModel.fromJson(Map<String, dynamic> json) {
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
  int? bookingId;
  String? originname;
  String? destinantionname;
  String? departureDatetime;
  String? companyName;
  int? seatCount;
  String? reviewRating;

  Data(
      {this.bookingId,
        this.originname,
        this.destinantionname,
        this.departureDatetime,
        this.companyName,
        this.seatCount,
        this.reviewRating});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    originname = json['originname'];
    destinantionname = json['destinantionname'];
    departureDatetime = json['departure_datetime'];
    companyName = json['company_name'];
    seatCount = json['seat_count'];
    reviewRating = json['review_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['originname'] = this.originname;
    data['destinantionname'] = this.destinantionname;
    data['departure_datetime'] = this.departureDatetime;
    data['company_name'] = this.companyName;
    data['seat_count'] = this.seatCount;
    data['review_rating'] = this.reviewRating;
    return data;
  }
}
