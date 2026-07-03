import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StopInfo extends StatelessWidget {
  final dynamic point;
  final String? city;
  final CrossAxisAlignment align;
  const StopInfo({
    required this.point,
    required this.city,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          "${point?.date ?? ''} · ${point?.time ?? ''}",
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          point?.name ?? "",
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: align == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
        ),
        Text(
          city ?? "",
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}