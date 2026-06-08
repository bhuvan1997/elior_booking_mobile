class BookingHistoryModel {
  bool? status;
  String? message;
  List<Data>? data;

  BookingHistoryModel({this.status, this.message, this.data});

  BookingHistoryModel.fromJson(Map<String, dynamic> json) {
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
  String? propertyType;
  String? propertyName;
  String? checkInDate;
  String? checkOutDate;
  String? userName;
  String? status;

  Data(
      {this.bookingId,
        this.propertyType,
        this.propertyName,
        this.checkInDate,
        this.checkOutDate,
        this.userName,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    propertyType = json['property_type'];
    propertyName = json['property_name'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    userName = json['user_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['property_type'] = this.propertyType;
    data['property_name'] = this.propertyName;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['user_name'] = this.userName;
    data['status'] = this.status;
    return data;
  }
}
