import 'package:flutter/material.dart';
import 'package:elior/app_values/app_theme.dart';

class OffersBottomSheet extends StatefulWidget {
  final List<dynamic> coupons;
  final String? appliedCouponName;
  final Function(dynamic coupon) onCouponApplied;

  const OffersBottomSheet({
    super.key,
    required this.coupons,
    this.appliedCouponName,
    required this.onCouponApplied,
  });

  @override
  State<OffersBottomSheet> createState() => _OffersBottomSheetState();
}

class _OffersBottomSheetState extends State<OffersBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  List<dynamic> get _filteredCoupons {
    if (_searchQuery.isEmpty) return widget.coupons;

    return widget.coupons.where((coupon) {
      return (coupon.name ?? "")
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          const Text(
            "Offers & Coupons",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search coupon",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Coupon list
          Expanded(
            child: _filteredCoupons.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No coupons available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredCoupons.length,
              itemBuilder: (_, index) {
                final coupon = _filteredCoupons[index];
                final isApplied = widget.appliedCouponName == coupon.name;
                return _CouponCard(
                  coupon: coupon,
                  isApplied: isApplied,
                  onApply: () {
                    widget.onCouponApplied(coupon);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final dynamic coupon;
  final bool isApplied;
  final VoidCallback onApply;

  const _CouponCard({
    required this.coupon,
    required this.isApplied,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isApplied ? AppTheme.appThemeColor : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.discount_outlined, color: AppTheme.appThemeColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.name ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Get ${coupon.value}% off",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: isApplied ? Colors.grey : AppTheme.appThemeColor,
            ),
            child: Text(isApplied ? "Applied" : "Apply"),
          ),
        ],
      ),
    );
  }
}