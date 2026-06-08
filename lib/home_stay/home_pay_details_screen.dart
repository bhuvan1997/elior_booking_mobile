import 'dart:convert';

import 'package:elior/response_model/final_payment_model/final_payment_model.dart';
import 'package:elior/response_model/final_payment_model/payment_initiated_model.dart';
import 'package:elior/response_model/home_stay_respnse/accomendation_booking_screen.dart';
import 'package:elior/response_model/paysuccess_model_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';

import '../network/service_provider.dart';
import '../utils/storage.dart';

class ReviewHomeBookingScreen extends StatefulWidget {
  const ReviewHomeBookingScreen({super.key});

  @override
  State<ReviewHomeBookingScreen> createState() =>
      _ReviewHomeBookingScreenState();
}

class _ReviewHomeBookingScreenState extends State<ReviewHomeBookingScreen> {
  final AccData hotelBooking = Get.arguments;

  // ⭐ Payment option radio button
  int paymentOption = 1; // 1 = Full, 2 = 10%
  PaySuccessModel paySuccessModel = PaySuccessModel();

  String formatTime(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsed);
    } catch (e) {
      return time;
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
  FInalPaymentModel fInalPaymentModel = FInalPaymentModel();
  PaymentInitiatedModel paymentInitiatedModel = PaymentInitiatedModel();

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
      final result = await ServiceProvider().payFinalPaymentApi(
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

  Future<void> paymentInitiatedApi() async {
    try {
      final data = await ServiceProvider().paymentInitiated(
        type: 2,
        bookingId: fInalPaymentModel.data?.bookingId ?? 0,
      );
      setState(() {
        paymentInitiatedModel = data;
      });
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  Future<void> paySuccessApi(String id) async {
    try {
      final data = await ServiceProvider().paymentSuccess(transactionId: id);
      setState(() {
        paySuccessModel = data;
      });
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  @override
  void initState() {
    super.initState();
    basePrice =
        double.tryParse(hotelBooking.totalPrice?.toString() ?? '0') ?? 0;
  }

  bool _isPaying = false;

  void _startPaymentFromApi() {
    final int payAmount = (fInalPaymentModel.data?.amount ?? 0).toInt();

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

                _showResultDialog(context, "Payment verification failed ❌");
              }
            });
          },
        ),
      ),
    );
  }

  void _startFullPayment(double fullAmount) {
    final int payAmount = (fInalPaymentModel.data?.amount ?? 0).toInt();

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

                _showResultDialog(context, "Payment verification failed ❌");
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
  Widget build(BuildContext context) {
    double priceAfterDiscount = basePrice - discount;
    double totalAmount = priceAfterDiscount + taxes;

    // ⭐ user will pay now (depending on Full or 10%)
    double payNowAmount = paymentOption == 2
        ? (totalAmount * 0.10)
        : totalAmount;
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
            // ------------------ Header ------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    (hotelBooking.homestayImages?.isNotEmpty ?? false)
                        ? hotelBooking.homestayImages![0]
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
                      const SizedBox(height: 4),
                      Text(
                        LocalStorages().getHotelName() ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${LocalStorages().getHotelAddress() ?? ""}, ${hotelBooking.city},${hotelBooking.country}",
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

            const SizedBox(height: 20),

            // ------------------ Price Summary ------------------------
            const Text(
              "Price Summary",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _priceRow(
              "Base Price",
              "${hotelBooking.currency ?? ""} ${hotelBooking.basePrice}",
            ),

            _priceRow(
              "Total Discount",
              "${hotelBooking.currency ?? ""} ${discount.toStringAsFixed(0)}",
              color: Colors.green,
            ),

            _priceRow(
              "Price after Discount",
              "${hotelBooking.currency ?? ""} ${priceAfterDiscount.toStringAsFixed(0)}",
            ),

            _priceRow(
              "Taxes & Service Fees",
              "${hotelBooking.currency ?? ""} ${hotelBooking.taxPrice.toStringAsFixed(0)}",
            ),

            const Divider(),
            _priceRow(
              "Total amount (Base Price × ${hotelBooking.nights}) ",
              "${hotelBooking.currency ?? ""} ${hotelBooking.totalPrice} ",
            ),

            const Divider(),
            _priceRow(
              "Amount to Pay Now",
              "${hotelBooking.currency ?? ""} ${payNowAmount.toStringAsFixed(0)}",
              isBold: true,
            ),

            const SizedBox(height: 20),

            // ------------------ Offers ------------------------
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

                final flatValue =
                    double.tryParse(coupon.value?.toString() ?? "0") ?? 0;
                final percentValue =
                    double.tryParse(coupon.valueInPercent?.toString() ?? "0") ??
                    0;

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
                              coupon.description ?? "",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              percentValue > 0
                                  ? "Get ${percentValue.toStringAsFixed(0)}% off"
                                  : "Get ${flatValue.toStringAsFixed(0)} off",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: isApplied
                            ? () {
                                // REMOVE coupon
                                appliedCouponName = null;
                                discount = 0;
                                setState(() {});
                              }
                            : appliedCouponName != null
                            ? null // Disable APPLY on other coupons
                            : () {
                                // APPLY coupon
                                appliedCouponName = coupon.name;

                                double value =
                                    double.tryParse(
                                      coupon.value?.toString() ?? "0",
                                    ) ??
                                    0;

                                double valuePercent =
                                    double.tryParse(
                                      coupon.valueInPercent?.toString() ?? "0",
                                    ) ??
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
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------------
            // ⭐⭐ Payment Options — RADIO BUTTONS ⭐⭐
            // --------------------------------------------------------
            const Text(
              "Select Payment Option",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            //
            // RadioListTile(
            //   value: 1,
            //   groupValue: paymentOption,
            //   title: const Text("Pay Full Amount"),
            //   subtitle: Text(
            //       "Pay ${hotelBooking.currency} ${totalAmount.toStringAsFixed(0)} now"),
            //   onChanged: (value) {
            //     setState(() {
            //       paymentOption = value!;
            //     });
            //   },
            // ),
            //
            // RadioListTile(
            //   value: 2,
            //   groupValue: paymentOption,
            //   title: const Text("Pay 10% Now"),
            //   subtitle: Text(
            //     "Pay only ${hotelBooking.currency} ${(totalAmount * 0.10).toStringAsFixed(0)} now",
            //   ),
            //   onChanged: (value) {
            //     setState(() {
            //       paymentOption = value!;
            //     });
            //   },
            // ),
            const SizedBox(height: 20),

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
                          children: [
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
                            backgroundColor: Color(0xFFFFF2CC),
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
                              roomtype: hotelBooking.homestayName ?? "",
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

                          child: Text(
                            "Pay ${hotelBooking.currency} ${(totalAmount * 0.10).toStringAsFixed(0)}",
                            style: const TextStyle(color: Colors.black),
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
                          "Pay Full Amount",
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
                          onPressed: () {
                            _startFullPayment(totalAmount);
                          },

                          child: Text(
                            "Pay ${hotelBooking.currency} ${totalAmount.toStringAsFixed(0)}",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
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
