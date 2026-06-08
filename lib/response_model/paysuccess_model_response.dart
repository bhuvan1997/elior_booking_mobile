class PaySuccessModel {
  bool? status;
  String? message;
  Result? result;

  PaySuccessModel({this.status, this.message, this.result});

  PaySuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? transactionId;
  String? bookingAt;
  String? bookingno;

  Result({this.transactionId, this.bookingAt, this.bookingno});

  Result.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    bookingAt = json['booking_at'];
    bookingno = json['bookingno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['booking_at'] = this.bookingAt;
    data['bookingno'] = this.bookingno;
    return data;
  }
}
