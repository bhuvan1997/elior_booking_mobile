import 'package:elior/app_values/app_theme.dart';
import 'package:elior/controller/hotel_controller/top_hotel_controller.dart';
import 'package:elior/response_model/booking_history_response.dart';
import 'package:elior/response_model/bus_history_model.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../network/service_provider.dart';
import '../ticket_history.dart';
import '../trip_history.dart';

class BookingHistoryScreen extends StatefulWidget {
  final int initialTab;

  const BookingHistoryScreen({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final hotelController = Get.put(TopHotelController());

  @override
  void initState() {
    super.initState();

    // MUST be initialized before build()
    tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);

    // Safe to run APIs here
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchBookingHotels();
      await fetchBushistory();
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  BookingHistoryModel bookingHistoryModel = BookingHistoryModel();
  BusHistoryModel busHistoryModel = BusHistoryModel();

  // ------- STATIC HOTEL DATA -------
  Future<void> fetchBookingHotels() async {
    try {
      bookingHistoryModel = await ServiceProvider().bookingHostoryApi();
    } catch (e) {
      debugPrint('Statelistdata error: $e');
    }
  }

  Future<void> fetchBushistory() async {
    try {
      busHistoryModel = await ServiceProvider().busHostoryApi();
    } catch (e) {
      debugPrint('Statelistdata error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: getAppBar(
        context,
        "my_bookings".tr,
        isLeading: false,
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          indicatorColor: AppTheme.appThemeColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "hotels_homestays".tr),
            Tab(text: "bus_booking".tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // ------------------- HOTELS TAB --------------------------
          _buildHotelTab(),

          // ------------------- BUS BOOKING TAB ----------------------
          _buildBusBookingGrid(),
        ],
      ),
    );
  }

  // ========================================================
  // HOTELS GRID
  Widget _buildHotelTab() {
    final list = bookingHistoryModel.data;

    // If API returned null or empty list
    if (list == null || list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hotel_class, size: 70, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                "no_booking_history_found".tr,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If data exists, show list
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: bookingHistoryModel.data?.length,
      itemBuilder: (context, index) {
        final h = bookingHistoryModel.data?[index];
        return GestureDetector(
          onTap: () {
            Get.to(TripCompletedScreen(id: h?.bookingId ?? 0));
          },
          child: bookingCard(
            status: h?.status ?? "",
            dateRange: "${h?.checkInDate} - ${h?.checkOutDate}",
            title: h?.propertyName ?? "",
            guestName: h?.userName ?? "",
            propertyType: h?.propertyType ?? "",
          ),
        );
      },
    );
  }

  Widget bookingCard({
    required String status,
    required String dateRange,
    required String title,
    required String guestName,
    required String propertyType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.apartment,
                  size: 28,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // STATUS + DATE
                    Row(
                      children: [
                        Text(
                          status,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text("  |  "),
                        Text(
                          dateRange,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // TITLE
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // GUEST + TYPE
                    Row(
                      children: [
                        const Icon(Icons.person, size: 15, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          guestName,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text("  |  "),
                        Text(
                          propertyType,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ========================================================
  // BUS BOOKING GRID
  // ========================================================
  Widget _buildBusBookingGrid() {
    return ListView.builder(
      itemCount: busHistoryModel.data?.length,
      itemBuilder: (context, index) {
        var bus = busHistoryModel.data?[index];
        return GestureDetector(
          onTap: () {
            Get.to(TicketDetailsScreen(id: bus?.bookingId ?? 0));
          },
          child: busBookingCard(
            from: bus?.originname ?? "",
            to: bus?.destinantionname ?? "",
            time: bus?.departureDatetime ?? "",
            busName: bus?.companyName ?? "",
            passengers: bus?.seatCount ?? 0,
            rating: bus?.reviewRating ?? "",
          ),
        );
      },
    );
  }

  Widget busBookingCard({
    required String from,
    required String to,
    required String time,
    required String busName,
    required int passengers,
    required String rating,
  }) {
    int ratingValue = int.tryParse(rating) ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Logo + Passenger Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.bus_alert),
              Row(
                children: [
                  const Icon(Icons.group, size: 20, color: Colors.black45),
                  const SizedBox(width: 4),
                  Text(
                    "$passengers",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Route
          Text(
            "$from → $to",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          // Time
          Text(
            time,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 4),

          // Bus Name
          Text(
            "Bus · $busName",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // Rating Row
          ratingValue > 0
              ? Row(
            children: [
              Text(
                "${"you_rated".tr}  ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              ...List.generate(
                5,
                    (index) => Icon(
                  index < ratingValue ? Icons.star : Icons.star_border,
                  color: index < ratingValue ? Colors.amber : Colors.grey,
                  size: 18,
                ),
              ),
            ],
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}