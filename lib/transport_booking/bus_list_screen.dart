import 'package:elior/app_values/app_theme.dart';

import 'package:elior/transport_booking/seat_booking.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../response_model/transport_response/bus_route_response.dart';

class BusListScreen extends StatefulWidget {
  final BusListResponse busListResponse;

  const BusListScreen({
    super.key,
    required this.busListResponse,
  });

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  String? busDate;
  String? getBusDate;

  @override
  void initState() {
    super.initState();
    getBusDate = LocalStorages().getBusDate() ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final buses = widget.busListResponse.data ?? [];
    final hasBuses = buses.isNotEmpty;

    return Scaffold(
      appBar: getAppBar(
        context,
        "Available Buses",
        centerTitle: false,
      ),
      body: hasBuses
          ? ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return _BusCard(
            bus: bus,
            onTap: () {
              Get.to(
                    () => BusSeatScreen(
                  origin: bus.origin ?? '',
                  destination: bus.destination ?? '',
                  busId: bus.busId ?? 0,
                  busRouteId: bus.busRouteId ?? 0,
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bus,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No buses available",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try searching for a different route or date",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusCard extends StatelessWidget {
  final BusModel bus;
  final VoidCallback onTap;

  const _BusCard({
    required this.bus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Name & Rating
                Row(
                  children: [
                    if (bus.companyLogo != null && bus.companyLogo!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          bus.companyLogo!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.business, size: 40),
                        ),
                      )
                    else
                      const Icon(Icons.business, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bus.companyName ?? 'Unknown Company',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            bus.busTypeName ?? 'Standard Bus',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Fare
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bus.fareText,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.appThemeColor,
                          ),
                        ),
                        Text(
                          'per seat',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Route & Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bus.departureTime,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bus.origin ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          bus.durationHuman ?? '--',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 80,
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.circle,
                              size: 6,
                              color: Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bus.arrivalTime,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bus.destination ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Features
                if (bus.features != null && bus.features!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: bus.features!.map((feature) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.blue.shade100,
                          ),
                        ),
                        child: Text(
                          feature,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 12),
                // View Seats Button
                AppButton(
                  title: "View Seats",
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}