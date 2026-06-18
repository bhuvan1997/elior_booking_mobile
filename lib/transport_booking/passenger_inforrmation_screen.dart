import 'dart:convert';
import 'dart:developer';

import 'package:elior/transport_booking/booking_confirmation.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';

import '../app_values/app_theme.dart';
import '../network/service_provider.dart';
import '../response_model/transport_response/proceed_model.dart';

class ProceedData {
  final String? companyName;
  final String? boardingCity;
  final String? droppingCity;
  final String? currency;
  final int? busId;
  final int? busRouteId;
  final int? seatPrice;
  final int? selectedSeatCount;
  final List<String>? selectedSeats;
  final BoardingDroppingPoint? boardingPoint;
  final BoardingDroppingPoint? droppingPoint;

  ProceedData(this.companyName, this.boardingCity, this.droppingCity, this.currency, this.busId, this.busRouteId, this.seatPrice, this.selectedSeatCount, this.selectedSeats, this.boardingPoint, this.droppingPoint);
}

class BoardingDroppingPoint {
  final int? id;
  final String? name;
  final String? date;
  final String? time;

  BoardingDroppingPoint(this.id, this.name, this.date, this.time);
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

  // Payment related variables
  int paymentOption = 1; // 1 = Full Payment, 2 = Partial Payment (25%)
  String selectedPayOption = "Pay Full Amount";
  bool get _isPartialPayment => paymentOption == 2;

  Data get _data => widget.proceedModel.data!;

  int get _totalFare =>
      (_data.seatPrice ?? 0) *
          (passengers.isEmpty ? (_data.selectedSeatCount ?? 1) : passengers.length);

  double get _payNowAmount =>
      _isPartialPayment ? (_totalFare * 0.25) : _totalFare.toDouble();

  bool get _canAddMore => passengers.length < (_data.selectedSeatCount ?? 1);

  // ─── Bottom Sheet ────────────────────────────────────────────────────────────

  void _showAddPassengerSheet({int? editIndex}) {
    final nameCtrl = TextEditingController(
      text: editIndex != null ? passengers[editIndex]["name"] : "",
    );
    final ageCtrl = TextEditingController(
      text: editIndex != null ? passengers[editIndex]["age"] : "",
    );
    String? selectedGender =
    editIndex != null ? passengers[editIndex]["gender"] : null;
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
                            ? "Edit Passenger ${editIndex + 1}"
                            : "Add Passenger",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _SheetField(
                        controller: nameCtrl,
                        label: "Full Name",
                        hint: "e.g. Rahul Sharma",
                        icon: Icons.person_outline,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Enter name" : null,
                      ),
                      const SizedBox(height: 14),

                      _SheetField(
                        controller: ageCtrl,
                        label: "Age",
                        hint: "e.g. 28",
                        icon: Icons.cake_outlined,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Enter age" : null,
                      ),
                      const SizedBox(height: 14),

                      // Gender selector
                      Text(
                        "Gender",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ["Male", "Female", "Other"].map((g) {
                          final selected = selectedGender == g;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setSheetState(() => selectedGender = g),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.only(right: 8),
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
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
                                  const SnackBar(
                                    content: Text("Please select a gender"),
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
                            editIndex != null ? "Save Changes" : "Add Passenger",
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

  // ─── Payment Options Bottom Sheet ────────────────────────────────────────────

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Payment Option",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _buildPaymentOptionTile(
                title: "Pay Full Amount",
                subtitle: "Pay the complete fare now",
                amount: _totalFare,
                isSelected: paymentOption == 1,
                onTap: () {
                  setState(() {
                    paymentOption = 1;
                    selectedPayOption = "Pay Full Amount";
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _buildPaymentOptionTile(
                title: "Pay 25% Now",
                subtitle: "Pay 25% now, rest at boarding",
                amount: (_totalFare * 0.25).toInt(),
                isSelected: paymentOption == 2,
                onTap: () {
                  setState(() {
                    paymentOption = 2;
                    selectedPayOption = "Pay 25% Now";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOptionTile({
    required String title,
    required String subtitle,
    required int amount,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.appThemeColor.withOpacity(0.08)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.appThemeColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "${_data.currency ?? '₹'} $amount",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.appThemeColor,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.appThemeColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Booking ─────────────────────────────────────────────────────────────────

  Future<void> _proceedToPayment() async {
    if (passengers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add at least one passenger."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final passengerList = passengers.asMap().entries.map((entry) {
      final seatNo = _data.selectedSeats?[entry.key] ?? "";
      return {
        "seat_no": seatNo.toString(),
        ...entry.value,
      };
    }).toList();

    log(jsonEncode({
      "bus_id": _data.busId ?? 0,
      "bus_route_id": _data.busRouteId ?? 0,
      "boarding_point_id": _data.boardingPoint?.id ?? 0,
      "dropping_point_id": _data.droppingPoint?.id ?? 0,
      "seats": (_data.selectedSeats ?? []).join(","),
      "seats_price": _totalFare,
      "passenger_data": passengerList,
      "payment_option": paymentOption,
      "pay_now_amount": _payNowAmount.toInt(),
    }));

    try {
      ServiceProvider().showLoader();
      final response = await ServiceProvider().proceedPayNowSeatBooking(
        busId: _data.busId ?? 0,
        busRouteId: _data.busRouteId ?? 0,
        boardingPointId: _data.boardingPoint?.id ?? 0,
        droppingPointId: _data.droppingPoint?.id ?? 0,
        seats: _data.selectedSeats ?? [],
        seatsPrice: _totalFare,
        passengerData: passengerList,
      );
      ServiceProvider().hideLoader();

      if (response["status"] == true) {
        // Navigate to payment gateway
        _navigateToPaymentGateway(
          bookingNo: response["data"]?["booking_no"] ?? "",
          bookingId: response["data"]?["booking_id"] ?? 0,
        );
      } else {
        ServiceProvider().snackBarMessage(
          head: "Error",
          message: response["message"] ?? "Something went wrong!",
        );
      }
    } catch (e) {
      ServiceProvider().hideLoader();
      ServiceProvider().snackBarMessage(head: "Error", message: "Booking failed: $e");
    }
  }

  // ─── Payment Gateway Integration ─────────────────────────────────────────────

  void _navigateToPaymentGateway({
    required String bookingNo,
    required int bookingId,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KKiaPay(
          amount: _payNowAmount.toInt(),
          apikey: "197c8b4084cd11f0a0845d14785d8374",
          sandbox: true,
          phone: "97000000",
          name: passengers.isNotEmpty ? passengers[0]["name"] ?? "Passenger" : "Passenger",
          email: "passenger@email.com",
          reason: "Bus Booking $bookingNo",
          theme: "#222F5A",
          data: jsonEncode({
            "order_id": bookingNo,
            "booking_id": bookingId,
            "payment_type": paymentOption == 2 ? "partial" : "full",
            "type": 3, // Type 3 for bus booking
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
        head: "Payment Failed",
        message: "Payment was not successful. Please try again.",
      );
      return;
    }

    if (transactionId == null || transactionId.isEmpty) {
      ServiceProvider().snackBarMessage(
        head: "Error",
        message: "Payment success but transaction ID missing",
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
      ServiceProvider().showLoader();

      // Verify payment with type 3 (bus booking)
      final response = await ServiceProvider().paymentSuccess(
        transactionId: transactionId
      );

      ServiceProvider().hideLoader();

      if (response.status == true) {
        // Show success dialog
        _showSuccessDialog(
          bookingNo: bookingNo,
          transactionId: transactionId,
        );
      } else {
        ServiceProvider().snackBarMessage(
          head: "Error",
          message: "Payment verification failed. Please contact support.",
        );
      }
    } catch (e) {
      ServiceProvider().hideLoader();
      ServiceProvider().snackBarMessage(
        head: "Error",
        message: "Payment verification error: $e",
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              "Payment Successful!",
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
              "Your bus booking has been confirmed.",
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
                  _infoRow("Booking No", bookingNo),
                  const SizedBox(height: 8),
                  _infoRow("Transaction ID", transactionId),
                  const SizedBox(height: 8),
                  _infoRow(
                    "Amount Paid",
                    "${_data.currency ?? '₹'} ${_payNowAmount.toInt()}",
                  ),
                  if (_isPartialPayment) ...[
                    const SizedBox(height: 8),
                    _infoRow(
                      "Remaining Amount",
                      "${_data.currency ?? '₹'} ${_totalFare - _payNowAmount.toInt()}",
                    ),
                  ],
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
                Navigator.pop(context); // Close dialog
                Get.offAll(() => BookingConfirmedScreen(data: {
                  "booking_no": bookingNo,
                  "transaction_id": transactionId,
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.appThemeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "View Booking",
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
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
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
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: getAppBar(context, "Passenger Info", centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          _JourneySummaryCard(data: _data),
          const SizedBox(height: 16),
          _PassengerListSection(
            passengers: passengers,
            canAdd: _canAddMore,
            maxSeats: _data.selectedSeatCount ?? 1,
            onAdd: () => _showAddPassengerSheet(),
            onEdit: (i) => _showAddPassengerSheet(editIndex: i),
            onDelete: (i) => setState(() => passengers.removeAt(i)),
          ),
          const SizedBox(height: 16),
          // Payment option selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: _showPaymentOptions,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Option",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedPayOption,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        currency: _data.currency ?? '₹',
        totalFare: _totalFare,
        payNowAmount: _payNowAmount.toInt(),
        onPay: _proceedToPayment,
        passengerCount: passengers.length,
        isPartialPayment: _isPartialPayment,
      ),
    );
  }
}

// ─── Journey Summary Card ────────────────────────────────────────────────────

class _JourneySummaryCard extends StatelessWidget {
  final Data data;
  const _JourneySummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              Expanded(child: _StopInfo(point: data.boardingPoint, city: data.boardingCity, align: CrossAxisAlignment.start)),
              _RouteIndicator(),
              Expanded(child: _StopInfo(point: data.droppingPoint, city: data.droppingCity, align: CrossAxisAlignment.end)),
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
                  Icon(Icons.event_seat_outlined, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    "${data.selectedSeatCount ?? 0} seat(s) selected",
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

class _StopInfo extends StatelessWidget {
  final dynamic point;
  final String? city;
  final CrossAxisAlignment align;
  const _StopInfo({required this.point, required this.city, required this.align});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          "${point?.date ?? ''} · ${point?.time ?? ''}",
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          point?.name ?? "",
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: align == CrossAxisAlignment.end ? TextAlign.end : TextAlign.start,
        ),
        Text(
          city ?? "",
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

class _RouteIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.appThemeColor, width: 2),
            ),
          ),
          Container(width: 40, height: 1.5, color: Colors.grey.shade300),
          Icon(Icons.arrow_forward, size: 14, color: Colors.grey.shade400),
          Container(width: 40, height: 1.5, color: Colors.grey.shade300),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.appThemeColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Passenger List Section ──────────────────────────────────────────────────

class _PassengerListSection extends StatelessWidget {
  final List<Map<String, String>> passengers;
  final bool canAdd;
  final int maxSeats;
  final VoidCallback onAdd;
  final void Function(int) onEdit;
  final void Function(int) onDelete;

  const _PassengerListSection({
    required this.passengers,
    required this.canAdd,
    required this.maxSeats,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Passengers",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${passengers.length}/$maxSeats",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          if (passengers.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...passengers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PassengerTile(
                  index: entry.key,
                  passenger: entry.value,
                  onEdit: () => onEdit(entry.key),
                  onDelete: () => onDelete(entry.key),
                ),
              );
            }),
          ],

          const SizedBox(height: 14),

          if (canAdd)
            GestureDetector(
              onTap: onAdd,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.appThemeColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.appThemeColor.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: AppTheme.appThemeColor),
                    const SizedBox(width: 8),
                    Text(
                      "Add Passenger",
                      style: GoogleFonts.poppins(
                        color: AppTheme.appThemeColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "All $maxSeats seat(s) filled",
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Passenger Tile (swipe to delete) ────────────────────────────────────────

class _PassengerTile extends StatelessWidget {
  final int index;
  final Map<String, String> passenger;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PassengerTile({
    required this.index,
    required this.passenger,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey("passenger_$index${passenger['name']}"),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppTheme.appThemeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.appThemeColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passenger["name"] ?? "",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${passenger['age']} yrs · ${passenger['gender']}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final String currency;
  final int totalFare;
  final int payNowAmount;
  final VoidCallback onPay;
  final int passengerCount;
  final bool isPartialPayment;

  const _BottomBar({
    required this.currency,
    required this.totalFare,
    required this.payNowAmount,
    required this.onPay,
    required this.passengerCount,
    required this.isPartialPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPartialPayment ? "Pay Now" : "Total Fare",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                "$currency $payNowAmount",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (isPartialPayment) ...[
                const SizedBox(height: 2),
                Text(
                  "Remaining: $currency ${totalFare - payNowAmount}",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: passengerCount > 0 ? onPay : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.appThemeColor,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                "Proceed to Pay",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Sheet Text Field ────────────────────────────────────────────────

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade500),
        labelStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.appThemeColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

