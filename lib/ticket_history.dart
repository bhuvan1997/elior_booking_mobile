import 'package:elior/response_model/bus_ticket_history_model.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'bus_review_screen.dart';
import 'network/service_provider.dart';

class TicketDetailsScreen extends StatefulWidget {
  final int id;

  const TicketDetailsScreen({super.key, required this.id});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  BusIicketHistoryModel bookingHistoryDetails = BusIicketHistoryModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bookingHistoryDetail(widget.id);
    });
  }

  Future<void> bookingHistoryDetail(int id) async {
    try {
      final data = await ServiceProvider().busTicketHistoryDetail(id);
      setState(() {
        bookingHistoryDetails = data;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      setState(() => isLoading = false);
    }
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, EEE").format(parsedDate);
    } catch (e) {
      return date ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = bookingHistoryDetails.data?.booking?.isNotEmpty == true
        ? bookingHistoryDetails.data!.booking!.first
        : null;

    final review = bookingHistoryDetails.data?.review?.isNotEmpty == true
        ? bookingHistoryDetails.data!.review!.first
        : null;
    final reviewList = bookingHistoryDetails.data?.review;

    return Scaffold(
      appBar: getAppBar(
        context,
        "ticket_details".tr,
        subtext: "${"ticket_hash".tr}${booking?.bookingNo ?? ""}",
        isSubtext: true,
        centerTitle: false,
      ),
      body: booking == null
          ? Center(child: Text("no_ticket_found".tr))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TicketCard(booking: booking),
            const SizedBox(height: 20),
            if (reviewList == null || reviewList.isEmpty) ...[
              /// Show Write Review Button
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 3),
                      color: Color(0x22000000),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "let_us_know_trip".tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: 170,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D8CFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Get.to(
                            BusReviewScreen(
                              bookingId: booking?.bookingId ?? 0,
                            ),
                          );
                        },
                        child: Text(
                          "write_a_review".tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ] else ...[
              /// Already Reviewed Section
              Text(
                "your_review".tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ⭐ Stars
                    Row(
                      children: List.generate(
                        reviewList.first.rating ?? 0,
                            (index) => const Icon(
                          Icons.star,
                          size: 22,
                          color: Color(0xFFFFB400),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Title
                    Text(
                      reviewList.first.title ?? "",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Comment
                    Text(
                      reviewList.first.review ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "already_reviewed".tr,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}

class TicketCard extends StatelessWidget {
  final Booking booking;

  const TicketCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT SIDE (Timeline)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _locationItem(
                        booking.originname,
                        booking.boardingName,
                        isLast: false,
                      ),

                      const SizedBox(height: 20),

                      /// Trip Completed Row
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Colors.grey)),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.directions_bus,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "trip_completed".tr,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _locationItem(
                        booking.destinantionname,
                        booking.droppingName,
                        isLast: false,
                      ),
                    ],
                  ),
                ),

                /// RIGHT SIDE (TIME)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _time(booking.departureTime),

                    const SizedBox(height: 4),
                    _date(booking.departureDatetime),
                    const SizedBox(height: 40),
                    _time(booking.arrivalTime),
                    const SizedBox(height: 4),
                    _date(booking.arrivalDatetime),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Bus Company
                Center(
                  child: Column(
                    children: [
                      Text(
                        booking.companyName ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${booking.busType ?? ""} / ${booking.registrationNo ?? ""}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(),

                /// Passengers
                ...booking.passengersFormatted
                    ?.map(
                      (p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      p.text ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                    .toList() ??
                    [],

                const Divider(),
                const SizedBox(height: 10),

                _detailRow("pnr".tr, booking.bookingNo),
                const Divider(),
                _detailRow("bus_number".tr, booking.registrationNo),
                const Divider(),

                _detailRow("payment_gateway".tr, booking.gateway),
                const Divider(),

                _detailRow("transaction_id".tr, booking.gatewayTransactionId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// LOCATION ITEM WITH DOT + LINE
  Widget _locationItem(String? city, String? stop, {required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.red, width: 2),
              ),
            ),
            if (!isLast) Container(width: 2, height: 30, color: Colors.grey),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              city ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stop ?? "",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _time(String? time) {
    return Text(
      time ?? "",
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _date(String? date) {
    if (date == null) return const SizedBox();
    try {
      final parsed = DateTime.parse(date);
      return Text(
        DateFormat("EEE, dd MMM yyyy").format(parsed),
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      );
    } catch (_) {
      return Text(
        date,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      );
    }
  }

  Widget _detailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(
            value ?? "",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final Review review;

  const RatingCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 3),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "you_rated_this_trip".tr,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                index < (review.rating ?? 0) ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            review.title ?? "",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            review.review ?? "",
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}