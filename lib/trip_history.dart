import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:elior/app_values/app_theme.dart';
import 'package:elior/response_model/booking_history_details.dart';
import 'package:elior/review_screen.dart';
import 'package:elior/utils/project_utils.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: getAppBar(context, booking?.status == "Completed" ? "Trip Completed" : "Trip Confirmed", centerTitle: false),
      body: booking == null
          ? const Center(child: Text("No Booking Details Found"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROPERTY NAME
                  Text(
                    booking.propertyName ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "You have completed your trip. We hope you had a pleasant stay!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// BOOKING ID
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.appThemeColor.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Booking ID - ${booking.bookingNo ?? ""}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
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
                          child: Row(
                            children: [
                              Text(
                                "Copy",
                                style: GoogleFonts.poppins(
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.copy, size: 18, color: AppTheme.white),
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

                    AppButton(
                      title: "WRITE A REVIEW",
                      isOutlined: true,
                      onTap: () {
                        Get.to(ReviewScreen(bookingId: booking.bookingId ?? 0));
                      },
                    ),
                  ] else ...[
                    /// Already Reviewed Section
                    Text(
                      "Your Review",
                      style: GoogleFonts.poppins(
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
                                color: AppTheme.appThemeColor,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// Title
                          Text(
                            reviewList.first.title ?? "",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// Comment
                          Text(
                            reviewList.first.review ?? "",
                            style: GoogleFonts.poppins(
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
                  Text(
                    "Booking Details",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Property Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: getImage(
                                height: 80,
                                width: 90,
                                url: booking.images!.first,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.propertyName ?? "",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: AppTheme.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // const SizedBox(height: 4),
                                  Text(
                                    booking.propertyAddress ?? "",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Transform.rotate(
                                        angle: 0.5,
                                        child: Icon(
                                          Icons.navigation,
                                          color: AppTheme.appThemeColor,
                                          size: 15,
                                        ),
                                      ),
                                      Text(
                                        "Get Directions",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.appThemeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        DottedLine(),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _stayTiming(
                              text: "Check-in",
                              subtext: formatDate(booking.checkInDate),
                              time: booking.checkInTime ?? "",
                              axis: CrossAxisAlignment.start,
                            ),
                            _stayTiming(
                              text: "Check-out",
                              subtext: formatDate(booking.checkOutDate),
                              time: booking.checkOutTime ?? "",
                              axis: CrossAxisAlignment.end,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        DottedLine(),
                        const SizedBox(height: 10),

                        /// GUEST DETAILS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _sectionHeaderAndSubtext(text: "Guest and Stay Details", subtext: booking.stayDetails ?? "",),
                          _sectionHeaderAndSubtext(text: "Primary Traveller", subtext: booking.userName ?? "", axis: CrossAxisAlignment.end),
                        ]),

                        const SizedBox(height: 16),

                        /// Header
                        Row(
                          children: [
                            Icon(
                              Icons.file_download_outlined,
                              size: 16,
                              color: AppTheme.appThemeColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Download Invoice",
                              style: GoogleFonts.poppins(
                                color: AppTheme.appThemeColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// HOTEL RULES
                  if (booking.rules != null && booking.rules!.isNotEmpty) ...[
                    const Text(
                      "Hotel Rules",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          ...booking.rules!.map(
                                (rule) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),),
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
                  ],

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
                            "${payment.currency ?? "XOF"} ${payment.basePrice ?? "0.00"}",
                          ),
                          const SizedBox(height: 12),
                          _priceRow(
                            "Miscellaneous Fee",
                            "${payment.currency ?? "XOF"} ${payment.miscFee ?? "0.00"}",
                          ),
                          const SizedBox(height: 12),
                          _priceRow(
                            "Discount",
                            "- ${payment.currency ?? "XOF"} ${payment.discount ?? "0.00"}",
                            valueColor: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          _priceRow(
                            "Total Amount",
                            "${payment.currency ?? "XOF"} ${payment.totalAmount ?? "0.00"}",
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

  Widget _stayTiming({
    required String text,
    required String subtext,
    required String time,
    required CrossAxisAlignment axis,
  }) {
    return Column(
      crossAxisAlignment: axis,
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtext,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppTheme.black.withValues(alpha: 0.6),
          ),
        ),
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppTheme.black.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeaderAndSubtext({
    required String text,
    required String subtext,
    CrossAxisAlignment? axis,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: axis ?? CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.black,
            ),
          ),
          Text(
            subtext,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.black,
            ),
            maxLines: 2,
          ),
        ],
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
