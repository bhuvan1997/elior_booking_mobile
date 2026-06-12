import 'package:flutter/material.dart';
import 'package:elior/utils/project_utils.dart';
import 'package:elior/utils/storage.dart';

class BookingHeader extends StatelessWidget {
  final dynamic hotelBooking;

  const BookingHeader({super.key, required this.hotelBooking});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: getImage(
            height: 80,
            width: 80,
            url: (hotelBooking.hotelImages?.isNotEmpty ?? false)
                ? hotelBooking.hotelImages![0]
                : "https://via.placeholder.com/120",
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  hotelBooking.starRating ?? 3,
                      (index) => const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.orange,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                LocalStorages().getHotelName() ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "${LocalStorages().getHotelAddress() ?? ""}, ${hotelBooking.city}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}