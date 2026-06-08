class HomePaymentModel {
  bool? status;
  String? message;
  DataPay? data;

  HomePaymentModel({this.status, this.message, this.data});

  HomePaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataPay.fromJson(json['data']) : null;
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

class DataPay {
  String? propertyId;
  String? roomType;
  Null? roomId;
  int? userId;
  String? checkInDate;
  String? checkOutDate;
  int? rooms;
  int? nights;
  int? guests;
  String? totalAmount;
  int? basePrice;
  String? miscFee;
  Null? paymentType;
  String? status;
  String? bookingId;
  String? createdAt;
  String? updatedAt;

  DataPay(
      {this.propertyId,
        this.roomType,
        this.roomId,
        this.userId,
        this.checkInDate,
        this.checkOutDate,
        this.rooms,
        this.nights,
        this.guests,
        this.totalAmount,
        this.basePrice,
        this.miscFee,
        this.paymentType,
        this.status,
        this.bookingId,
        this.createdAt,
        this.updatedAt});

  DataPay.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    roomType = json['room_type'];
    roomId = json['room_id'];
    userId = json['user_id'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    rooms = json['rooms'];
    nights = json['nights'];
    guests = json['guests'];
    totalAmount = json['total_amount'];
    basePrice = json['base_price'];
    miscFee = json['misc_fee'];
    paymentType = json['payment_type'];
    status = json['status'];
    bookingId = json['booking_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['room_type'] = this.roomType;
    data['room_id'] = this.roomId;
    data['user_id'] = this.userId;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['rooms'] = this.rooms;
    data['nights'] = this.nights;
    data['guests'] = this.guests;
    data['total_amount'] = this.totalAmount;
    data['base_price'] = this.basePrice;
    data['misc_fee'] = this.miscFee;
    data['payment_type'] = this.paymentType;
    data['status'] = this.status;
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
