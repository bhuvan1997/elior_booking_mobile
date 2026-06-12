import 'package:flutter/material.dart';
import 'package:elior/app_values/app_theme.dart';
import 'package:elior/utils/storage.dart';

class RoomInfoCard extends StatelessWidget {
  final dynamic hotelBooking;

  const RoomInfoCard({super.key, required this.hotelBooking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.black.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          // Room type row
          Row(
            children: [
              const Icon(Icons.single_bed, color: Colors.black87, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  LocalStorages().getRoomTyp() ?? "Executive Room",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Guests info row
          Row(
            children: [
              const Icon(Icons.person, color: Colors.black87, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${hotelBooking.guest ?? 2} Adult${(hotelBooking.guest ?? 2) > 1 ? 's' : ''}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Room count
          Row(
            children: [
              const Icon(Icons.door_back_door, color: Colors.black87, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${hotelBooking.roomsCount ?? 1} Room${(hotelBooking.roomsCount ?? 1) > 1 ? 's' : ''}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}