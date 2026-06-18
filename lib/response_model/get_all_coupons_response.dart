class CouponResponse {
  final bool? status;
  final String? message;
  final List<Coupon>? data;

  CouponResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? List<Coupon>.from(
        json['data'].map((x) => Coupon.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class Coupon {
  final int? id;
  final String? name;
  final String? description;

  Coupon({
    this.id,
    this.name,
    this.description,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}