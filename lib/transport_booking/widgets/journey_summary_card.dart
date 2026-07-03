import 'package:elior/app_values/app_theme.dart';
import 'package:elior/response_model/transport_response/proceed_model.dart';
import 'package:elior/transport_booking/widgets/route_indicator.dart';
import 'package:elior/transport_booking/widgets/stop_info.dart';
import 'package:flutter/material.dart';
import 'package:elior/response_model/bus_booking_response.dart';
import 'package:elior/response_model/final_payment_model/payment_initiated_model.dart';
import 'package:google_fonts/google_fonts.dart';

class JourneySummaryCard extends StatelessWidget {
  final Data data;
  const JourneySummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.companyName ?? "Bus Service",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppTheme.appThemeColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StopInfo(
                  point: data.boardingPoint,
                  city: data.boardingCity,
                  align: CrossAxisAlignment.start,
                ),
              ),
              RouteIndicator(),
              Expanded(
                child: StopInfo(
                  point: data.droppingPoint,
                  city: data.droppingCity,
                  align: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 0.8, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event_seat_outlined,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${data.selectedSeatCount ?? 0} seat(s) selected",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.appThemeColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.selectedSeats?.join(", ") ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.appThemeColor,
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