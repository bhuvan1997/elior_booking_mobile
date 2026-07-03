import 'package:elior/hotel_booking/widgets/booking_dates.dart';
import 'package:elior/hotel_booking/widgets/offers_bottom_sheet.dart';
import 'package:elior/hotel_booking/widgets/offers_card.dart';
import 'package:elior/hotel_booking/widgets/payment_option_bottom_sheet.dart';
import 'package:elior/hotel_booking/widgets/price_summary_card.dart';
import 'package:elior/hotel_booking/widgets/room_infor_card.dart';
import 'package:elior/success/success_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_values/app_theme.dart';
import '../response_model/booking_data.dart';
import '../response_model/booking_payment_detail_response.dart';
import '../response_model/final_payment_model/final_payment_model.dart';
import '../response_model/paysuccess_model_response.dart';
import '../response_model/final_payment_model/payment_initiated_model.dart';
import '../services/booking_service.dart';
import '../services/coupon_service.dart';
import '../services/payment_service.dart';
import '../utils/storage.dart';
import '../widgets/app_button.dart';
import '../widgets/toolbar.dart';
import 'widgets/booking_header.dart';

class ReviewBookingScreen extends StatefulWidget {
  const ReviewBookingScreen({super.key});

  @override
  State<ReviewBookingScreen> createState() => _ReviewBookingScreenState();
}

class _ReviewBookingScreenState extends State<ReviewBookingScreen> {
  final BookingData booking = Get.arguments as BookingData;

  BookingPaymentModel bookingPaymentModel = BookingPaymentModel();
  PaySuccessModel paySuccessModel = PaySuccessModel();
  PaymentInitiatedModel paymentInitiatedModel = PaymentInitiatedModel();
  FInalPaymentModel fInalPaymentModel = FInalPaymentModel();

  int _paymentOption = 1;
  String selectedPayOption = "pay_full_amount".tr;
  bool get _isPayAtHotel => _paymentOption == 2;

  int get _propertyPaymentType {
    switch (booking.propertyType) {
      case BookingPropertyType.hotel:
        return 1;
      case BookingPropertyType.accommodation:
        return 2;
    }
  }

  double basePrice = 0;
  double discount = 0;
  double taxes = 0;
  String? appliedCouponName;

  final PaymentService _paymentService = PaymentService();
  final BookingService _bookingService = BookingService();
  final CouponService _couponService = CouponService();

  @override
  void initState() {
    super.initState();
    _initializePricing();
  }

  void _initializePricing() {
    basePrice = double.tryParse(booking.totalPrice?.toString() ?? '0') ?? 0;
    _couponService.setBasePrice(basePrice);
  }

  double get priceAfterDiscount => basePrice - discount;
  double get totalAmount => priceAfterDiscount + taxes;
  double get payNowAmount =>
      _paymentOption == 2 ? (totalAmount * 0.05) : totalAmount;

  Future<void> _handlePayment() async {
    final bookingResult = await _bookingService.confirmBooking(
      isHotel: _propertyPaymentType == 1 ? true : false,
      propertyId: booking.propertyId.toString(),
      checkInDate: LocalStorages().getCheckIn() ?? "",
      checkOutDate: LocalStorages().getCheckOut() ?? "",
      guests: booking.guest.toString(),
      roomtype: booking.propertyName ?? "",
      roomIdAllotted: booking.allotRooms.toString(),
      basePrice: booking.basePrice ?? 0,
      taxFee: booking.taxPrice,
      discountAmount: discount.toInt(),
      totalAmount: booking.totalPrice ?? 0,
      payPlan: _isPayAtHotel ? "partial5" : "full",
    );

    if (!mounted) return;

    if (bookingResult.isSuccess) {
      fInalPaymentModel = bookingResult.data!;
      await _initiatePartialPayment();
    } else {
      Get.snackbar("failed".tr, bookingResult.error ?? "payment_failed".tr);
    }
  }

  Future<void> _initiatePartialPayment() async {
    final response = await _bookingService.initiatePayment(
      type: _propertyPaymentType,
      bookingId: fInalPaymentModel.data?.bookingId ?? 0,
    );

    if (!mounted) return;

    if (_bookingService.paymentInitiatedModel.status == true) {
      _paymentService.startPartialPayment(
        context: context,
        amount: payNowAmount,
        bookingModel: fInalPaymentModel,
        onSuccess: (message) => _showSuccessDialog(
          message,
          SuccessPageData(
            id: response.data?.bookingNo ?? "",
            bookingName: booking.propertyName ?? "",
            bookingAddress: booking.propertyAddress ?? "",
            checkIn: "${booking.checkinDate} ${booking.checkInTime}",
            checkOut: "${booking.checkoutDate} ${booking.checkOutTime}, ${booking.nights} ${"nights_label".tr}",
            room: "${booking.roomsCount} ${"rooms_count_label".tr}",
            payment: response.data?.amount.toString() ?? "",
          ),
        ),
        onError: (message) => _showErrorDialog(message),
        apikey: response.data?.publicKey ?? "",
        sandbox: response.data?.sandbox ?? true,
      );
    }
  }

  void _applyCoupon(dynamic coupon) {
    final result = _couponService.applyCoupon(
      coupon: coupon,
      totalAmount: totalAmount,
      payNowAmount: payNowAmount,
    );
    setState(() {
      appliedCouponName = result.couponName;
      discount = result.discount;
    });
  }

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PaymentOptionBottomSheet(
        selectedOption: selectedPayOption,
        onOptionSelected: (option, paymentType) {
          setState(() {
            selectedPayOption = option;
            _paymentOption = paymentType;
          });
        },
      ),
    );
  }

  void _showOffers() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => OffersBottomSheet(
        coupons: booking.coupons ?? [],
        appliedCouponName: appliedCouponName,
        onCouponApplied: _applyCoupon,
      ),
    );
  }

  void _showSuccessDialog(String message, SuccessPageData data) {
    print("Success Meri Claim Karen: $message");
    Get.off(
          () => SuccessPage(data: data,),
    );
  }

  void _showErrorDialog(String message) {
    print("Error meri claim karen: $message");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("payment_failed_title".tr),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ok".tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "review_booking".tr, centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingHeader(hotelBooking: booking),
            const SizedBox(height: 16),
            BookingDates(hotelBooking: booking),
            const SizedBox(height: 16),
            RoomInfoCard(hotelBooking: booking),
            const SizedBox(height: 20),
            OffersCard(
              couponCount: booking.coupons?.length ?? 0,
              appliedCouponName: appliedCouponName,
              onTap: _showOffers,
            ),
            const SizedBox(height: 20),
            PriceSummaryCard(
              hotelBooking: booking,
              discount: discount,
              priceAfterDiscount: priceAfterDiscount,
              taxes: taxes,
              payNowAmount: payNowAmount,
            ),
          ],
        ),
      ),
      persistentFooterButtons: [_buildPaymentFooter()],
    );
  }

  Widget _buildPaymentFooter() {
    return InkWell(
      onTap: _showPaymentOptions,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "pay_option".tr,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.black,
                      size: 20,
                    ),
                  ],
                ),
                Text(
                  selectedPayOption,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.greyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AppButton(title: "pay_now".tr, onTap: _handlePayment),
            ),
          ],
        ),
      ),
    );
  }
}