class PaymentInitiatedModel {
  bool? status;
  String? message;
  PayData? data;

  PaymentInitiatedModel({this.status, this.message, this.data});

  PaymentInitiatedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new PayData.fromJson(json['data']) : null;
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

class PayData {
  String? gateway;
  int? amount;
  String? currency;
  String? bookingNo;
  String? orderId;
  bool? sandbox;
  String? publicKey;
  Metadata? metadata;

  PayData(
      {this.gateway,
        this.amount,
        this.currency,
        this.bookingNo,
        this.orderId,
        this.sandbox,
        this.publicKey,
        this.metadata});

  PayData.fromJson(Map<String, dynamic> json) {
    gateway = json['gateway'];
    amount = json['amount'];
    currency = json['currency'];
    bookingNo = json['booking_no'];
    orderId = json['order_id'];
    sandbox = json['sandbox'];
    publicKey = json['public_key'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gateway'] = this.gateway;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['booking_no'] = this.bookingNo;
    data['order_id'] = this.orderId;
    data['sandbox'] = this.sandbox;
    data['public_key'] = this.publicKey;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  int? type;
  int? bookingId;

  Metadata({this.type, this.bookingId});

  Metadata.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['booking_id'] = this.bookingId;
    return data;
  }
}
