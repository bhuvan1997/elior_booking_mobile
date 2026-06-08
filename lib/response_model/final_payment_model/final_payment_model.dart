class FInalPaymentModel {
  bool? status;
  String? message;
  PaymentData? data;

  FInalPaymentModel({this.status, this.message, this.data});

  factory FInalPaymentModel.fromJson(Map<String, dynamic> json) {
    return FInalPaymentModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? PaymentData.fromJson(json['data'])
          : null,
    );
  }
}

class PaymentData {
  int? type;
  int? bookingId;
  String? bookingno;
  double? amount;
  String? propertyName;
  String? checkInDate;
  String? checkOutDate;

  PaymentData({
    this.type,
    this.bookingId,
    this.bookingno,
    this.amount,
    this.propertyName,
    this.checkInDate,
    this.checkOutDate,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      type: json['type'],
      bookingId: json['bookingId'],
      bookingno: json['bookingno'],
      amount: (json['amount'] as num?)?.toDouble(), // ✅ FIX
      propertyName: json['property_name'],
      checkInDate: json['check_in_date'],
      checkOutDate: json['check_out_date'],
    );
  }
}
