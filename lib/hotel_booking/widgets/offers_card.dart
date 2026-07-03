import 'package:flutter/material.dart';
import 'package:elior/app_values/app_theme.dart';
import 'package:get/get.dart';

class OffersCard extends StatelessWidget {
  final int couponCount;
  final String? appliedCouponName;
  final VoidCallback onTap;

  const OffersCard({
    super.key,
    required this.couponCount,
    this.appliedCouponName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "offers".tr,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.black.withValues(alpha: .08),
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.appThemeColor.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_offer_outlined,
                    color: AppTheme.appThemeColor,
                  ),
                ),
                const SizedBox(width: 12),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appliedCouponName == null
                            ? "view_offers".tr
                            : "$appliedCouponName ${"coupon_applied".tr}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        appliedCouponName == null
                            ? "$couponCount ${"coupons_available".tr}"
                            : "tap_to_change_coupon".tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron icon
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}