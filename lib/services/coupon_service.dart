class CouponResult {
  final String? couponName;
  final double discount;

  CouponResult({this.couponName, required this.discount});
}

class CouponService {
  double _basePrice = 0;

  void setBasePrice(double price) {
    _basePrice = price;
  }

  CouponResult applyCoupon({
    required dynamic coupon,
    required double totalAmount,
    required double payNowAmount,
  }) {
    final couponName = coupon.name as String?;
    final value = double.tryParse(coupon.value?.toString() ?? "0") ?? 0;
    final valuePercent =
        double.tryParse(coupon.valueInPercent?.toString() ?? "0") ?? 0;

    double discount = valuePercent == 1
        ? (payNowAmount * value) / 100
        : value;

    if (discount > payNowAmount) {
      discount = payNowAmount;
    }

    return CouponResult(
      couponName: couponName,
      discount: discount,
    );
  }
}