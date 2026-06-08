import 'package:elior/response_model/booking_history_details.dart';
import 'package:elior/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'network/service_provider.dart';

class TripCompletedScreen extends StatefulWidget {
  final int id;

  const TripCompletedScreen({super.key, required this.id});

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  BookingHistoryDetails bookingHistoryDetails = BookingHistoryDetails();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await bookingHistoryDetail(widget.id);

      setState(() {});
    });
  }

  Future<void> bookingHistoryDetail(int id) async {
    try {
      final data = await ServiceProvider().bookingHistoryDetail(id);
      setState(() {
        bookingHistoryDetails = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error : $e");
      setState(() => isLoading = false);
    }
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, EEE").format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = bookingHistoryDetails.data?.booking?.isNotEmpty == true
        ? bookingHistoryDetails.data!.booking!.first
        : null;

    final payment = bookingHistoryDetails.data?.payments?.isNotEmpty == true
        ? bookingHistoryDetails.data!.payments!.first
        : null;
    final reviewList = bookingHistoryDetails.data?.review;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Trip Completed",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : booking == null
          ? const Center(child: Text("No Booking Details Found"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROPERTY NAME
                  Text(
                    booking.propertyName ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "You have completed your trip. We hope you had a pleasant stay!",
                    style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                  ),
                  const SizedBox(height: 16),

                  /// BOOKING ID
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEF3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Booking ID - ${booking.bookingNo ?? ""}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: booking.bookingNo ?? ""),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Booking ID Copied"),
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                "Copy",
                                style: TextStyle(
                                  color: Color(0xFF2D8CFF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.copy,
                                size: 18,
                                color: Color(0xFF2D8CFF),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (reviewList == null || reviewList.isEmpty) ...[
                    /// Show Write Review Button
                    const Text(
                      "Let us know about your stay",
                      style: TextStyle(
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
                            ReviewScreen(bookingId: booking?.bookingId ?? 0),
                          );
                        },
                        child: const Text(
                          "WRITE A REVIEW",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    /// Already Reviewed Section
                    const Text(
                      "Your Review",
                      style: TextStyle(
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

                          const Text(
                            "Already Reviewed",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 24),

                  /// BOOKING DETAILS CARD
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Booking Details",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Download Invoice",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// Property Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.propertyName ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  // const SizedBox(height: 4),
                                  Text(
                                    booking.propertyAddress ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,

                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Get Directions",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D8CFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child:
                                  booking.images != null &&
                                      booking.images!.isNotEmpty
                                  ? Image.network(
                                      booking.images!.first,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey.shade200,
                                    ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 10),

                        /// STAY DATES
                        const Text(
                          "Stay Dates",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${formatDate(booking.checkInDate)} — ${booking.nights ?? ""} Night — ${formatDate(booking.checkOutDate)}\n"
                          "${booking.checkInTime ?? ""} — ${booking.checkOutTime ?? ""}",
                          style: const TextStyle(fontSize: 12, height: 1.5),
                        ),

                        const SizedBox(height: 10),
                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 10),

                        /// GUEST DETAILS
                        const Text(
                          "Guest and Stay Details",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          booking.stayDetails ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// PRIMARY TRAVELLER
                        const Text(
                          "Primary Traveller",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          booking.userName ?? "",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// HOTEL RULES
                  if (booking.rules != null && booking.rules!.isNotEmpty)
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hotel Rules",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...booking.rules!.map(
                            (rule) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      rule,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  /// PRICE DETAILS
                  if (payment != null)
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Price Details",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _priceRow(
                            "Base Price",
                            "₹ ${payment.basePrice ?? "0.00"}",
                          ),
                          const SizedBox(height: 12),
                          _priceRow(
                            "Discount",
                            "- ₹ ${payment.discount ?? "0.00"}",
                            valueColor: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          _priceRow(
                            "Total Amount",
                            "₹ ${payment.totalAmount ?? "0.00"}",
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
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

  Widget _priceRow(
    String title,
    String value, {
    Color valueColor = Colors.black,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
