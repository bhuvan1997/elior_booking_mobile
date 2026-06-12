import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDates extends StatelessWidget {
  final dynamic hotelBooking;

  const BookingDates({super.key, required this.hotelBooking});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'DD/MM';
    try {
      final parsedDate = DateFormat("yyyy-MM-dd").parse(dateStr);
      return DateFormat("d MMM").format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsed);
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Check-in
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Check-in",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(hotelBooking.checkinDate ?? ""),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatTime(hotelBooking.checkInTime ?? ""),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        // Duration indicator
        Column(
          children: [
            Icon(
              Icons.nightlight_round,
              color: Colors.blue.shade300,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              "${hotelBooking.nights ?? 1} Night${(hotelBooking.nights ?? 1) > 1 ? 's' : ''}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        // Check-out
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Check-out",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(hotelBooking.checkoutDate ?? ""),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatTime(hotelBooking.checkOutTime ?? ""),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}