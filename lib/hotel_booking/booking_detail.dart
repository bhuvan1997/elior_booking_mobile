import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../network/service_provider.dart';
import '../response_model/booking_payment_detail_response.dart';
import '../response_model/final_payment_model/final_payment_model.dart';
import '../response_model/hotel_booking_response.dart';
import '../utils/storage.dart';
import 'dart:convert';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import '../response_model/paysuccess_model_response.dart';
import '../response_model/final_payment_model/payment_initiated_model.dart';

class ReviewBookingScreen extends StatefulWidget {
  const ReviewBookingScreen({super.key});

  @override
  State<ReviewBookingScreen> createState() => _ReviewBookingScreenState();
}

class _ReviewBookingScreenState extends State<ReviewBookingScreen> {
  final Data hotelBooking = Get.arguments;
  BookingPaymentModel bookingPaymentModel = BookingPaymentModel();
  int paymentOption = 1; // 1 = Full, 2 = 10%
  PaySuccessModel paySuccessModel = PaySuccessModel();
  PaymentInitiatedModel paymentInitiatedModel = PaymentInitiatedModel();

  bool _isPaying = false;
  FInalPaymentModel fInalPaymentModel = FInalPaymentModel();

  Future<void> paymentInitiatedApi() async {
    try {
      final data = await ServiceProvider().paymentInitiated(
        type: 1, // hotel booking type
        bookingId: fInalPaymentModel.data?.bookingId??0,
      );

      setState(() {
        paymentInitiatedModel = data;
      });
    } catch (e) {
      debugPrint("Payment Initiated Error: $e");
    }
  }
  Future<void> paySuccessApi(String id) async {
    try {
      final data = await ServiceProvider().paymentSuccess(
        transactionId: id,
      );

      setState(() {
        paySuccessModel = data;
      });
    } catch (e) {
      debugPrint("Payment Success Error: $e");
    }
  }

  Future<void> payBookConfirm({
    required String propertyId,
    required String checkInDate,
    required String checkOutDate,
    required String guests,
    required String roomtype,
    required String roomIdAllotted,
    required int basePrice,
    required int taxFee,
    required int discountAmount,
    required int totalAmount,
    required String payPlan,
  }) async {
    try {
      final result = await ServiceProvider().payFinalHotelPaymentApi(
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        propertyId: propertyId,
        guests: guests,
        roomtype: roomtype,
        roomIdAllotted: roomIdAllotted,
        basePrice: basePrice,
        taxFee: taxFee,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        payPlan: payPlan,
      );
      setState(() {
        fInalPaymentModel = result;
        // isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading rooms: $e');
      // setState(() => isLoading = false);
    }
  }

  String formatTime(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsed);
    } catch (e) {
      return time;
    }
  }

  Future<void> paymentFetchHotels(
    int id,
    String checkIn,
    String checkOut,
    String type,
    String roomAllot,
    String guest,
  ) async {
    try {
      final result = await ServiceProvider().bookingPaymentDetailApi(
        id,
        checkIn,
        checkOut,
        type,
        roomAllot,
        guest,
      );
      setState(() {
        bookingPaymentModel = result;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => BottomBarScreen());
        Get.snackbar(
          "Success",
          "Your hotel has been booked and payment is pending",
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          borderRadius: 20,
          margin: const EdgeInsets.all(20),
          backgroundColor: Colors.green,
        );
      });
    } catch (e) {
      debugPrint('Hotel detail error: $e');
      setState(() {});
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'DD/MM';
    try {
      final parsedDate = DateFormat("yyyy-MM-dd").parse(dateStr);
      return DateFormat("d MMM").format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  double basePrice = 0;
  double discount = 0;
  String? appliedCouponName;
  double taxes = 0;
  void _startPaymentFromApi() {
    double priceAfterDiscount = basePrice - discount;
    double totalAmount = priceAfterDiscount + taxes;

// ✅ ALWAYS 10%
    final int payAmount = (totalAmount * 0.10).toInt();

    final String bookingNo = fInalPaymentModel.data?.bookingno ?? "";
    final int bookingId = fInalPaymentModel.data?.bookingId ?? 0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KKiaPay(
          amount: payAmount,
          apikey: "197c8b4084cd11f0a0845d14785d8374",
          sandbox: true,
          phone: "97000000",
          name: "John Doe",
          email: "john.doe@gmail.com",
          reason: "Hotel Booking $bookingNo",
          theme: "#222F5A",

          // ✅ MUST BE STRING
          data: jsonEncode({"order_id": bookingNo, "booking_id": bookingId}),

          callback: (response, context) {
            debugPrint("========== KKiaPay RESPONSE ==========");
            debugPrint(response.toString());
            debugPrint("=====================================");

            final String? status = response['status'];
            final String? transactionId = response['transactionId'];

            // ⚠️ Ignore intermediate states
            if (status != "PAYMENT_SUCCESS") {
              debugPrint("⏳ Payment not completed yet: $status");
              return;
            }

            if (transactionId == null || transactionId.isEmpty) {
              debugPrint("❌ Payment success but transactionId missing");
              return;
            }

            // ✅ FINAL CONFIRMATION
            paySuccessApi(transactionId).whenComplete(() {
              if (paySuccessModel.status == true) {
                debugPrint("✅ Neeraj Success (Backend Verified)");

                _showResultDialog(
                  context,
                  "Payment Successful ✅\n"
                      "Booking No: $bookingNo\n"
                      "Txn ID: $transactionId",
                );
              } else {
                debugPrint("❌ Backend rejected payment");

                _showResultDialog(
                  context,
                  "Payment verification failed ❌",
                );
              }
            });
          },

        ),
      ),
    );
  }

  void _startFullPayment(double fullAmount) {
    final int payAmount = fullAmount.toInt(); // ✅ use passed amount

    final String bookingNo = fInalPaymentModel.data?.bookingno ?? "";
    final int bookingId = fInalPaymentModel.data?.bookingId ?? 0;


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            KKiaPay(
              amount: payAmount,
              apikey: "197c8b4084cd11f0a0845d14785d8374",
              sandbox: true,
              phone: "97000000",
              name: "John Doe",
              email: "john.doe@gmail.com",
              reason: "Hotel Booking $bookingNo",
              theme: "#222F5A",

              // ✅ MUST BE STRING
              data: jsonEncode({"order_id": bookingNo, "booking_id": bookingId}),

              callback: (response, context) {
                debugPrint("========== KKiaPay RESPONSE ==========");
                debugPrint(response.toString());
                debugPrint("=====================================");

                final String? status = response['status'];
                final String? transactionId = response['transactionId'];

                // ⚠️ Ignore intermediate states
                if (status != "PAYMENT_SUCCESS") {
                  debugPrint("⏳ Payment not completed yet: $status");
                  return;
                }

                if (transactionId == null || transactionId.isEmpty) {
                  debugPrint("❌ Payment success but transactionId missing");
                  return;
                }

                // ✅ FINAL CONFIRMATION
                paySuccessApi(transactionId).whenComplete(() {
                  if (paySuccessModel.status == true) {
                    debugPrint("✅ Neeraj Success (Backend Verified)");

                    _showResultDialog(
                      context,
                      "Payment Successful ✅\n"
                          "Booking No: $bookingNo\n"
                          "Txn ID: $transactionId",
                    );
                  } else {
                    debugPrint("❌ Backend rejected payment");

                    _showResultDialog(
                      context,
                      "Payment verification failed ❌",
                    );
                  }
                });
              },
            ),
      ),
    );
  }
  void _showResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Result"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    basePrice = double.tryParse(hotelBooking.totalPrice?.toString() ?? '0') ?? 0;

  }

  @override
  Widget build(BuildContext context) {
    double priceAfterDiscount = basePrice - discount;
    double totalAmount = priceAfterDiscount + taxes;

    // ⭐ user will pay now (depending on Full or 10%)
    double payNowAmount =
    paymentOption == 2 ? (totalAmount * 0.10) : totalAmount;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Review Booking"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏨 Hotel Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    (hotelBooking.hotelImages?.isNotEmpty ?? false)
                        ? hotelBooking.hotelImages![0]
                        : "https://via.placeholder.com/120",
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
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
            ),

            const SizedBox(height: 16),

            // 📅 Dates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${formatDate(hotelBooking.checkinDate ?? "")}\n${formatTime(hotelBooking.checkInTime ?? "")}",
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
                Text(
                  "------  Night  -----",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "${formatDate(hotelBooking.checkoutDate ?? "")}\n${formatTime(hotelBooking.checkOutTime ?? "")}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              "${hotelBooking.roomsCount ?? 1} Room, ${hotelBooking.guest ?? 2} Guests",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // 🛏 Room Info
            Card(
              elevation: 0.3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.single_bed, color: Colors.black),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${LocalStorages().getRoomTyp() ?? "Executive Room"}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.black),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${hotelBooking.guest} Adults",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 💰 Price Summary
            const Text(
              "Price Summary",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _priceRow("Base Price",
                "${hotelBooking.currency ?? ""} ${hotelBooking.basePrice}"),

            _priceRow("Total Discount",
                "${hotelBooking.currency ?? ""} ${discount.toStringAsFixed(0)}",
                color: Colors.green),

            _priceRow(
                "Price after Discount",
                "${hotelBooking.currency ?? ""} ${priceAfterDiscount.toStringAsFixed(0)}"),

            _priceRow("Taxes & Service Fees",
                "${hotelBooking.currency ?? ""} ${hotelBooking.taxPrice.toStringAsFixed(0)}"),

            const Divider(),
            _priceRow("Total amount (Base Price × ${hotelBooking.nights}) ",
                "${hotelBooking.currency ?? ""} ${hotelBooking.totalPrice} "),

            const Divider(),
            _priceRow(
              "Amount to Pay Now",
              "${hotelBooking.currency ?? ""} ${payNowAmount.toStringAsFixed(0)}",
              isBold: true,
            ),

            const SizedBox(height: 20),

            // 🎁 Offers
            const Text(
              "Offers",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ListView.builder(
              itemCount: hotelBooking.coupons?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final coupon = hotelBooking.coupons![index];
                final isApplied = appliedCouponName == coupon.name;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isApplied ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.name ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isApplied
                                    ? Colors.green
                                    : Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Get ${coupon.value ?? "0"}% off",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: isApplied
                            ? () {
                          // REMOVE coupon
                          appliedCouponName = null;
                          discount = 0;
                          setState(() {});
                        }
                            : appliedCouponName != null
                            ? null   // Disable APPLY on other coupons
                            : () {
                          // APPLY coupon
                          appliedCouponName = coupon.name;

                          double value =
                              double.tryParse(coupon.value?.toString() ?? "0") ?? 0;

                          double valuePercent =
                              double.tryParse(coupon.valueInPercent?.toString() ?? "0") ??
                                  0;

                          if (valuePercent == 1) {
                            // percent coupon (e.g., 7% off)
                            discount = (payNowAmount * value) / 100;
                          } else {
                            // flat discount
                            discount = value;

                            if (discount > payNowAmount) {
                              discount = payNowAmount;
                            }
                          }

                          setState(() {});
                        },
                        child: Text(
                          isApplied
                              ? "REMOVE"
                              : appliedCouponName != null
                              ? "APPLIED"
                              : "APPLY",
                          style: TextStyle(
                            color: isApplied
                                ? Colors.red
                                : appliedCouponName != null
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                      )

                    ],
                  ),
                );
              },
            ),

            // const SizedBox(height: 20),

            // 💳 Buttons
            // 💳 Payment Options
            Column(
              children: [
                // Pay at Hotel
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Pay at Hotel",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Pay 10% here and remaining at hotel",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFF2CC), // light yellow
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () async {
                            await payBookConfirm(
                              propertyId: hotelBooking.propertyId.toString(),
                              checkInDate: LocalStorages().getCheckIn() ?? "",
                              checkOutDate: LocalStorages().getCheckOut() ?? "",
                              guests: hotelBooking.guest.toString(),
                              roomtype: hotelBooking.hotelName ?? "",
                              roomIdAllotted: hotelBooking.allotRooms
                                  .toString(),
                              basePrice: hotelBooking.basePrice ?? 0,
                              taxFee: hotelBooking.taxPrice,
                              discountAmount: discount.toInt(),
                              totalAmount: hotelBooking.totalPrice ?? 0,
                              payPlan: "partial5",
                            ).whenComplete(() {
                              if (fInalPaymentModel.status == true) {
                                print("✅ Success my status");
                                paymentInitiatedApi().whenComplete(() {
                                  if (paymentInitiatedModel.status == true) {
                                    _startPaymentFromApi();
                                    Get.snackbar(
                                      "Success",
                                      "Payment initiated successfully",
                                    );
                                  }
                                });
                              } else {
                                print("❌ Failed neeraj");
                                Get.snackbar("Failed", "Payment failed");
                              }
                            });

                            // ✅ SAFE CHECK AFTER API COMPLETES
                          },

                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Pay full Amount
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "Pay full Amount",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFF2CC),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),

                            onPressed: () async {
                              _startFullPayment(totalAmount);

                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
    String title,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
