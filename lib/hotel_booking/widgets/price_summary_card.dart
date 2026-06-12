import 'package:flutter/material.dart';
import 'package:elior/app_values/app_theme.dart';

class PriceSummaryCard extends StatelessWidget {
  final dynamic hotelBooking;
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
          const Text(
            "Price Summary",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _PriceRow(
            title: "Base Price",
            value: "${hotelBooking.currency ?? ""} ${hotelBooking.basePrice}",
          ),
          _PriceRow(
            title: "Total Discount",
            value: "${hotelBooking.currency ?? ""} ${discount.toStringAsFixed(0)}",
            color: Colors.green,
          ),
          _PriceRow(
            title: "Price after Discount",
            value: "${hotelBooking.currency ?? ""} ${priceAfterDiscount.toStringAsFixed(0)}",
          ),
          _PriceRow(
            title: "Taxes & Service Fees",
            value: "${hotelBooking.currency ?? ""} ${hotelBooking.taxPrice.toStringAsFixed(0)}",
          ),
          const Divider(color: AppTheme.black),
          _PriceRow(
            title: "Total amount (Base Price × ${hotelBooking.nights})",
            value: "${hotelBooking.currency ?? ""} ${hotelBooking.totalPrice}",
          ),
          const Divider(color: AppTheme.black),
          _PriceRow(
            title: "Pay Now",
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