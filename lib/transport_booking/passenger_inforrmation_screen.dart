import 'dart:convert';
import 'dart:developer';

import 'package:elior/transport_booking/booking_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../network/service_provider.dart';
import '../response_model/transport_response/proceed_model.dart';

class PassengerInformationScreen extends StatefulWidget {
  final ProceedModel proceedModel;

  const PassengerInformationScreen({super.key, required this.proceedModel});

  @override
  State<PassengerInformationScreen> createState() =>
      _PassengerInformationScreenState();
}

class _PassengerInformationScreenState
    extends State<PassengerInformationScreen> {
  final List<Map<String, dynamic>> passengers = [];
  final _formKey = GlobalKey<FormState>();

  /// 🧍 Add new passenger dynamically
  void _addPassengerForm() {
    final data = widget.proceedModel.data;
    int maxSeats = data?.selectedSeatCount ?? 1;

    if (passengers.length >= maxSeats) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You selected only $maxSeats seat(s)."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      passengers.add({
        "name": TextEditingController(),
        "age": TextEditingController(),
        "gender": null,
        "isExpanded": true, // default open
      });

      // collapse others when new one is added
      for (int i = 0; i < passengers.length - 1; i++) {
        passengers[i]["isExpanded"] = false;
      }
    });
  }

  /// 🧾 Calculate total fare
  int _calculateTotalFare() {
    final data = widget.proceedModel.data;
    final seatPrice = data?.seatPrice ?? 0;
    final count = passengers.isEmpty
        ? (data?.selectedSeatCount ?? 1)
        : passengers.length;
    return seatPrice * count;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.proceedModel.data;
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final totalFare = _calculateTotalFare();

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Passenger Information",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      /// ✅ Scrollable View
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          /// 🚌 Journey Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.companyName ?? "Bus Service",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data.boardingPoint?.date ?? ''}, ${data.boardingPoint?.time ?? ''}",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.boardingPoint?.name ?? "",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            data.boardingCity ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.grey),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${data.droppingPoint?.date ?? ''}, ${data.droppingPoint?.time ?? ''}",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.droppingPoint?.name ?? "",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            data.droppingCity ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 0.8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${data.selectedSeatCount ?? 0} Seats Selected",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      data.selectedSeats?.join(", ") ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 👥 Passenger Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Passenger details",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),

                /// Add Passenger Button
                OutlinedButton.icon(
                  onPressed: _addPassengerForm,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    "Add More Passenger",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 16),

                /// Expandable Passenger Forms
                for (int index = 0; index < passengers.length; index++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        /// Header with expand/collapse
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          title: Text(
                            "Passenger ${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  passengers[index]["isExpanded"]
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passengers[index]["isExpanded"] =
                                        !(passengers[index]["isExpanded"] ??
                                            false);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passengers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        /// Expanded Form Fields
                        if (passengers[index]["isExpanded"])
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: passengers[index]["name"],
                                    decoration: InputDecoration(
                                      labelText: "Full Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    validator: (val) =>
                                        val == null || val.isEmpty
                                        ? "Enter name"
                                        : null,
                                  ),
                                  const SizedBox(height: 10),

                                  TextFormField(
                                    controller: passengers[index]["age"],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Age",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    validator: (val) =>
                                        val == null || val.isEmpty
                                        ? "Enter age"
                                        : null,
                                  ),
                                  const SizedBox(height: 10),

                                  DropdownButtonFormField<String>(
                                    value: passengers[index]["gender"],
                                    decoration: InputDecoration(
                                      labelText: "Gender",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Male",
                                        child: Text("Male"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Female",
                                        child: Text("Female"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Other",
                                        child: Text("Other"),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        passengers[index]["gender"] = val;
                                      });
                                    },
                                    validator: (val) =>
                                        val == null ? "Select gender" : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      /// 💳 Bottom Pay Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Amount\n",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "${data.currency ?? '₹'} ${data.seatPrice}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final data = widget.proceedModel.data;

                    // 🧾 Build passenger JSON list
                    final passengerList = passengers.asMap().entries.map((
                      entry,
                    ) {
                      final index = entry.key;
                      final passenger = entry.value;
                      final seatNo = data?.selectedSeats?[index] ?? "";

                      return {
                        "seat_no": seatNo.toString(),
                        "name": passenger["name"].text.trim(),
                        "age": passenger["age"].text.trim(),
                        "gender": passenger["gender"].toString(),
                      };
                    }).toList();

                    // ✅ Debug print the final JSON (for testing)
                    log(
                      jsonEncode({
                        "bus_id": data?.busId ?? 0,
                        "bus_route_id": data?.busRouteId ?? 0,
                        "boarding_point_id": data?.boardingPoint?.id ?? 0,
                        "dropping_point_id": data?.droppingPoint?.id ?? 0,
                        "seats": (data?.selectedSeats ?? []).join(","),
                        "seats_price": _calculateTotalFare(),
                        "passenger_data": passengerList,
                      }),
                    );

                    try {
                      ServiceProvider().showLoader();

                      final response = await ServiceProvider()
                          .proceedPayNowSeatBooking(
                            busId: data?.busId ?? 0,
                            busRouteId: data?.busRouteId ?? 0,
                            boardingPointId: data?.boardingPoint?.id ?? 0,
                            droppingPointId: data?.droppingPoint?.id ?? 0,
                            seats: data?.selectedSeats ?? [],
                            seatsPrice: _calculateTotalFare(),
                            passengerData: passengerList,
                          );

                      ServiceProvider().hideLoader();

                      if (response["status"] == true) {
                        final bookingData = response["data"];
                        Get.to(() => BookingConfirmedScreen(data: bookingData));
                        // Get.to(BookingConfirmedScreen());
                        // ServiceProvider().successSnackBarMessage(
                        //   head: "Success",
                        //   message:
                        //       response["message"] ??
                        //       "Seat booked successfully!",
                        // );
                      } else {
                        ServiceProvider().snackBarMessage(
                          head: "Error",
                          message:
                              response["message"] ?? "Something went wrong!",
                        );
                      }
                    } catch (e) {
                      ServiceProvider().hideLoader();
                      ServiceProvider().snackBarMessage(
                        head: "Error",
                        message: "Booking failed: $e",
                      );
                    }
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Proceed to Pay",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
