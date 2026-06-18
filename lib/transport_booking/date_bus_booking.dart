import 'package:elior/app_values/app_theme.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
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

  BusListResponse? busListResponse; // Changed from BusRouteModel

  /// ✅ Format date for API (yyyy-MM-dd)
  String formatDate(DateTime? date) {
    if (date == null) return 'yyyy-MM-dd';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// ✅ Call API
  Future busRouteApi() async {
    try {
      busListResponse = await ServiceProvider().busRouteApi(
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
    return Scaffold(
      appBar: getAppBar(context, "Bus Tickets", centerTitle: false),
      body: Stack(
        children: [
          Image(
            image: AssetImage(AssetsScreen.busBooking),
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          _navigateToSection(
                            Icons.near_me,
                            "From",
                            fromController,
                          ),
                          const SizedBox(height: 12),
                          _navigateToSection(
                            Icons.location_on,
                            "To",
                            toController,
                          ),
                        ],
                      ),
                      Positioned(
                        right: 16,
                        top: 70,
                        child: GestureDetector(
                          onTap: () {
                            final temp = fromController.text;
                            fromController.text = toController.text;
                            toController.text = temp;
                            setState(() {});
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.appThemeColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.backgroundColor,
                                  width: 3
                              ),
                            ),
                            child: const Icon(
                              Icons.swap_vert,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.black.withValues(alpha: 0.1),
                            ),
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Departure",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppTheme.black.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat(
                                'dd MMM yyyy (EEE)',
                              ).format(checkOutDate ?? selectedDate),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  AppButton(
                    title: "Search buses",
                    onTap: () {
                      busRouteApi().then((_) {
                        if (busListResponse?.status == true &&
                            (busListResponse?.data?.isNotEmpty ?? false)) {
                          LocalStorages().saveBusDate(
                            busDate: DateFormat("MMMdd").format(selectedDate),
                          );
                          // Pass the entire response to BusListScreen
                          Get.to(
                                () => BusListScreen(
                              busListResponse: busListResponse!,
                            ),
                          );
                        } else {
                          String message = busListResponse?.message ??
                              "No buses found for this route";
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                message,
                              ),
                            ),
                          );
                        }
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $error"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigateToSection(
      IconData icon,
      String text,
      TextEditingController controller,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: AppTheme.black.withValues(alpha: 0.05),
              offset: const Offset(1, 2),
              blurRadius: 90,
              spreadRadius: 4
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppTheme.black),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.black.withValues(alpha: 0.5),
                  ),
                ),
                TextField(
                  controller: controller,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.black,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.appThemeColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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