import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../network/service_provider.dart';
import '../response_model/transport_response/bus_route_response.dart';
import 'bus_list_screen.dart';

class BusBookingScreen extends StatefulWidget {
  const BusBookingScreen({super.key});

  @override
  State<BusBookingScreen> createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends State<BusBookingScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();

  DateTime selectedDate = DateTime.now().add(
    const Duration(days: 1),
  ); // default tomorrow
  DateTime? checkOutDate;

  BusRouteModel busRouteModel = BusRouteModel();

  /// ✅ Format date for API (yyyy-MM-dd)
  String formatDate(DateTime? date) {
    if (date == null) return 'yyyy-MM-dd';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// ✅ Call API
  Future busRoouteApi() async {
    try {
      busRouteModel = await ServiceProvider().busRouteApi(
        origin: fromController.text.trim(),
        destination: toController.text.trim(),
        journeyDate: formatDate(checkOutDate ?? selectedDate),
      );
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final redColor = const Color(0xFFE53935);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Bus Tickets",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Attractive Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade50, Colors.orange.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // From
                  _buildTextField(
                    controller: fromController,
                    icon: Icons.directions_bus,
                    hint: "From",
                  ),
                  const Divider(thickness: 0.7),
                  // To
                  _buildTextField(
                    controller: toController,
                    icon: Icons.directions_bus,
                    hint: "To",
                  ),
                  const Divider(thickness: 0.7),
                  // Date Picker
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              DateFormat(
                                'EEE, dd MMM yyyy',
                              ).format(selectedDate),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            "Change",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: redColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Search button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                ),
                icon: const Icon(Icons.search, color: Colors.white),
                label: Text(
                  "Search buses",
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  busRoouteApi().whenComplete(() {
                    if (busRouteModel.status == true) {
                      LocalStorages().saveBusDate(
                        busDate: DateFormat("MMMdd").format(selectedDate),
                      );
                      final model = busRouteModel;
                      if (model != null && model.status == true) {
                        Get.to(() => BusListScreen(), arguments: model);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Searching buses from ${fromController.text} "
                              "to ${toController.text} "
                              "on ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                            ),
                          ),
                        );
                      }
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        checkOutDate = picked; // sync both for UI + API
      });
    }
  }

  /// ✅ Reusable textfield builder
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.black45),
        border: InputBorder.none,
      ),
    );
  }
}
