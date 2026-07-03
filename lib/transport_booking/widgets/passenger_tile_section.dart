import 'package:elior/transport_booking/widgets/passenger_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../app_values/app_theme.dart';

class PassengerListSection extends StatelessWidget {
  final List<Map<String, String>> passengers;
  final bool canAdd;
  final int maxSeats;
  final VoidCallback onAdd;
  final void Function(int) onEdit;
  final void Function(int) onDelete;

  const PassengerListSection({
    required this.passengers,
    required this.canAdd,
    required this.maxSeats,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "passengers".tr,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${passengers.length}/$maxSeats",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          if (passengers.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...passengers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PassengerTile(
                  index: entry.key,
                  passenger: entry.value,
                  onEdit: () => onEdit(entry.key),
                  onDelete: () => onDelete(entry.key),
                ),
              );
            }),
          ],

          const SizedBox(height: 14),

          if (canAdd)
            GestureDetector(
              onTap: onAdd,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.appThemeColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.appThemeColor.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: AppTheme.appThemeColor),
                    const SizedBox(width: 8),
                    Text(
                      "add_passenger".tr,
                      style: GoogleFonts.poppins(
                        color: AppTheme.appThemeColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "${"all_seats_filled".tr} $maxSeats ${"seats_filled".tr}",
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}