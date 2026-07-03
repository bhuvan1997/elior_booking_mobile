import 'dart:convert';
import 'dart:developer';

import 'package:elior/response_model/bus_booking_response.dart';
import 'package:elior/response_model/final_payment_model/payment_initiated_model.dart';
import 'package:elior/success/bus_success_page.dart';
import 'package:elior/transport_booking/booking_confirmation.dart';
import 'package:elior/transport_booking/widgets/bottom_bar.dart';
import 'package:elior/transport_booking/widgets/journey_summary_card.dart';
import 'package:elior/transport_booking/widgets/passenger_tile_section.dart';
import 'package:elior/transport_booking/widgets/sheet_field.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';

import '../app_values/app_theme.dart';
import '../network/service_provider.dart';
import '../response_model/transport_response/proceed_model.dart';

class _ProceedData {
  final String? companyName;
  final String? boardingCity;
  final String? droppingCity;
  final String? currency;
  final int? busId;
  final int? busRouteId;
  final int? seatPrice;
  final int? selectedSeatCount;
  final List<String>? selectedSeats;
  final _BoardingDroppingPoint? boardingPoint;
  final _BoardingDroppingPoint? droppingPoint;

  _ProceedData(
      this.companyName,
      this.boardingCity,
      this.droppingCity,
      this.currency,
      this.busId,
      this.busRouteId,
      this.seatPrice,
      this.selectedSeatCount,
      this.selectedSeats,
      this.boardingPoint,
      this.droppingPoint,
      );
}

class _BoardingDroppingPoint {
  final int? id;
  final String? name;
  final String? date;
  final String? time;

  _BoardingDroppingPoint(this.id, this.name, this.date, this.time);
}

class PassengerInformationScreen extends StatefulWidget {
  final ProceedModel proceedModel;

  const PassengerInformationScreen({super.key, required this.proceedModel});

  @override
  State<PassengerInformationScreen> createState() =>
      _PassengerInformationScreenState();
}

class _PassengerInformationScreenState
    extends State<PassengerInformationScreen> {
  final List<Map<String, String>> passengers = [];

  Data get _data => widget.proceedModel.data!;

  int get _totalFare =>
      (_data.seatPrice ?? 0) *
          (passengers.isEmpty ? (_data.selectedSeatCount ?? 1) : passengers.length);

  double get _payNowAmount => _totalFare.toDouble();

  bool get _canAddMore => passengers.length < (_data.selectedSeatCount ?? 1);

  BusBookingResponse _busBookingResponse = BusBookingResponse();

  // ─── Bottom Sheet ────────────────────────────────────────────────────────────

  void _showAddPassengerSheet({int? editIndex}) {
    final nameCtrl = TextEditingController(
      text: editIndex != null ? passengers[editIndex]["name"] : "",
    );
    final ageCtrl = TextEditingController(
      text: editIndex != null ? passengers[editIndex]["age"] : "",
    );
    String? selectedGender = editIndex != null
        ? passengers[editIndex]["gender"]
        : null;
    final sheetFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Form(
                  key: sheetFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        editIndex != null
                            ? "${"edit_passenger".tr} ${editIndex + 1}"
                            : "add_passenger".tr,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      SheetField(
                        controller: nameCtrl,
                        label: "full_name".tr,
                        hint: "name_hint".tr,
                        icon: Icons.person_outline,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "enter_name".tr
                            : null,
                      ),
                      const SizedBox(height: 14),

                      SheetField(
                        controller: ageCtrl,
                        label: "age".tr,
                        hint: "age_hint".tr,
                        icon: Icons.cake_outlined,
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? "enter_age".tr
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Gender selector
                      Text(
                        "gender".tr,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ["male".tr, "female".tr, "other".tr].map((g) {
                          final selected = selectedGender == g;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setSheetState(() => selectedGender = g),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppTheme.appThemeColor
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? AppTheme.appThemeColor
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    g,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: selected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (sheetFormKey.currentState!.validate()) {
                              if (selectedGender == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("select_gender".tr),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              final entry = {
                                "name": nameCtrl.text.trim(),
                                "age": ageCtrl.text.trim(),
                                "gender": selectedGender!,
                              };
                              setState(() {
                                if (editIndex != null) {
                                  passengers[editIndex] = entry;
                                } else {
                                  passengers.add(entry);
                                }
                              });
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.appThemeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            editIndex != null
                                ? "save_changes".tr
                                : "add_passenger".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ─── Booking ─────────────────────────────────────────────────────────────────

  Future<void> _proceedToPayment() async {
    if (passengers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("add_at_least_one_passenger".tr),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final passengerList = passengers.asMap().entries.map((entry) {
      final seatNo = _data.selectedSeats?[entry.key] ?? "";
      return {"seat_no": seatNo.toString(), ...entry.value};
    }).toList();

    log(
      jsonEncode({
        "bus_id": _data.busId ?? 0,
        "bus_route_id": _data.busRouteId ?? 0,
        "boarding_point_id": _data.boardingPoint?.id ?? 0,
        "dropping_point_id": _data.droppingPoint?.id ?? 0,
        "seats": (_data.selectedSeats ?? []).join(","),
        "seats_price": _totalFare,
        "passenger_data": passengerList,
        "payment_option": 1,
        "pay_now_amount": _payNowAmount.toInt(),
      }),
    );

    try {
      _busBookingResponse = await ServiceProvider().proceedPayNowSeatBooking(
        busId: _data.busId ?? 0,
        busRouteId: _data.busRouteId ?? 0,
        boardingPointId: _data.boardingPoint?.id ?? 0,
        droppingPointId: _data.droppingPoint?.id ?? 0,
        seats: _data.selectedSeats ?? [],
        seatsPrice: _totalFare,
        passengerData: passengerList,
      );

      if (_busBookingResponse.status == true) {
        _initiatePayment(
          type: 3,
          bookingId: _busBookingResponse.data?.bookingId ?? 0,
          bookingNo: _busBookingResponse.data?.bookingNo ?? "",
        );
      } else {
        ServiceProvider().snackBarMessage(
          head: "error".tr,
          message: _busBookingResponse.message ?? "something_went_wrong".tr,
        );
      }
    } catch (e) {
      ServiceProvider().snackBarMessage(
        head: "error".tr,
        message: "${"booking_failed".tr}: $e",
      );
    }
  }

  // ─── Payment Gateway Integration ─────────────────────────────────────────────

  void _initiatePayment({
    required int type,
    required int bookingId,
    required String bookingNo,
  }) async {
    PaymentInitiatedModel _initiatePay = await ServiceProvider()
        .paymentInitiated(type: type, bookingId: bookingId);
    if (_initiatePay.status == true) {
      _navigateToPaymentGateway(
        bookingNo: bookingNo,
        bookingId: bookingId,
        sandbox: _initiatePay.data?.sandbox ?? false,
        apikey: _initiatePay.data?.publicKey ?? "",
      );
    }
  }

  void _navigateToPaymentGateway({
    required String bookingNo,
    required int bookingId,
    required bool sandbox,
    required String apikey,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KKiaPay(
          amount: _payNowAmount.toInt(),
          apikey: apikey,
          sandbox: sandbox,
          name: passengers.isNotEmpty
              ? passengers[0]["name"] ?? "passenger_label".tr
              : "passenger_label".tr,
          reason: "${"bus_booking_label".tr} $bookingNo",
          theme: "#ff7903",
          data: jsonEncode({
            "order_id": bookingNo,
            "booking_id": bookingId,
            "payment_type": "full",
            "type": 3,
          }),
          callback: (response, context) {
            _handlePaymentCallback(
              response: response,
              bookingNo: bookingNo,
              bookingId: bookingId,
            );
          },
        ),
      ),
    );
  }

  void _handlePaymentCallback({
    required Map<String, dynamic> response,
    required String bookingNo,
    required int bookingId,
  }) {
    final status = response['status'];
    final transactionId = response['transactionId'];

    if (status != "PAYMENT_SUCCESS") {
      ServiceProvider().snackBarMessage(
        head: "payment_failed_title".tr,
        message: "payment_not_successful".tr,
      );
      return;
    }

    if (transactionId == null || transactionId.isEmpty) {
      ServiceProvider().snackBarMessage(
        head: "error".tr,
        message: "transaction_id_missing".tr,
      );
      return;
    }

    _verifyPayment(
      transactionId: transactionId,
      bookingNo: bookingNo,
      bookingId: bookingId,
    );
  }

  Future<void> _verifyPayment({
    required String transactionId,
    required String bookingNo,
    required int bookingId,
  }) async {
    try {
      final response = await ServiceProvider().busPaymentSuccess(
        transactionId: transactionId,
      );

      if (response.status == true) {
        Get.to(
              () => BusSuccessPage(
            data: SuccessPageData(
              pnr: response.result?.data?.pnr ?? "",
              origin: response.result?.data?.origin ?? "",
              destination: response.result?.data?.destination ?? "",
              companyName: response.result?.data?.companyName ?? "",
              model: response.result?.data?.model ?? "",
              currency: response.result?.data?.currency ?? "",
              fareTotal: response.result?.data?.fareTotal ?? "",
              departureDatetime: response.result?.data?.departureDatetime ?? "",
            ),
          ),
        );
      } else {
        ServiceProvider().snackBarMessage(
          head: "error".tr,
          message: "payment_verification_failed".tr,
        );
      }
    } catch (e) {
      ServiceProvider().snackBarMessage(
        head: "error".tr,
        message: "${"payment_verification_error".tr}: $e",
      );
    }
  }

  void _showSuccessDialog({
    required String bookingNo,
    required String transactionId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 8),
            Text(
              "payment_successful_title".tr,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "booking_confirmed_message".tr,
              style: GoogleFonts.poppins(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _infoRow("booking_no_label".tr, bookingNo),
                  const SizedBox(height: 8),
                  _infoRow("transaction_id".tr, transactionId),
                  const SizedBox(height: 8),
                  _infoRow(
                    "amount_paid".tr,
                    "${_data.currency ?? '₹'} ${_payNowAmount.toInt()}",
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.offAll(
                      () => BookingConfirmedScreen(
                    data: {
                      "booking_no": bookingNo,
                      "transaction_id": transactionId,
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.appThemeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "view_booking".tr,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (widget.proceedModel.data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: getAppBar(context, "passenger_info".tr, centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          JourneySummaryCard(data: _data),
          const SizedBox(height: 16),
          PassengerListSection(
            passengers: passengers,
            canAdd: _canAddMore,
            maxSeats: _data.selectedSeatCount ?? 1,
            onAdd: () => _showAddPassengerSheet(),
            onEdit: (i) => _showAddPassengerSheet(editIndex: i),
            onDelete: (i) => setState(() => passengers.removeAt(i)),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        currency: _data.currency ?? 'XOF',
        totalFare: _totalFare,
        payNowAmount: _payNowAmount.toInt(),
        onPay: _proceedToPayment,
        passengerCount: passengers.length,
        isPartialPayment: false,
      ),
    );
  }
}