import 'package:elior/response_model/booking_data.dart';
import 'package:flutter/material.dart';
import 'package:elior/app_values/app_theme.dart';
import 'package:get/get.dart';

class PriceSummaryCard extends StatelessWidget {
  final BookingData hotelBooking;
  final double discount;
  final double priceAfterDiscount;
  final double taxes;
  final double payNowAmount;

  const PriceSummaryCard({
    super.key,
    required this.hotelBooking,
    required this.discount,
    required this.priceAfterDiscount,
    required this.taxes,
    required this.payNowAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.black.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "price_summary".tr,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _PriceRow(
            title: "base_price".tr,
            value: "${hotelBooking.currency ?? ""} ${hotelBooking.basePrice}",
          ),
          _PriceRow(
            title: "total_discount".tr,
            value: "${hotelBooking.currency ?? ""} ${discount.toStringAsFixed(0)}",
            color: Colors.green,
          ),
          _PriceRow(
            title: "price_after_discount".tr,
            value: "${hotelBooking.currency ?? ""} ${priceAfterDiscount.toStringAsFixed(0)}",
          ),
          _PriceRow(
            title: "taxes_service_fees".tr,
            value: "${hotelBooking.currency ?? ""} ${hotelBooking.taxPrice.toStringAsFixed(0)}",
          ),
          const Divider(color: AppTheme.black),
          _PriceRow(
            title: "${"total_amount".tr} (${"base_price_label".tr} × ${hotelBooking.nights})",
            value: "${hotelBooking.currency ?? ""} ${hotelBooking.totalPrice}",
          ),
          const Divider(color: AppTheme.black),
          _PriceRow(
            title: "pay_now".tr,
            value: "${hotelBooking.currency ?? ""} ${payNowAmount.toStringAsFixed(0)}",
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;
  final Color? color;

  const _PriceRow({
    required this.title,
    required this.value,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}