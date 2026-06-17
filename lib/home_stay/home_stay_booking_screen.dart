import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/home_stay_controller.dart';
import 'home_stay_search_screen.dart';

class HomeStayScreen extends StatefulWidget {
  const HomeStayScreen({super.key});

  @override
  State<HomeStayScreen> createState() => _HomeStayScreenState();
}

class _HomeStayScreenState extends State<HomeStayScreen> {
  var controller = Get.put(HomeStayController());
  final _formKey = GlobalKey<FormState>();
  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Elior Home Stay 🏡",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder(
        init: controller,
        builder: (value) => Stack(
          children: [
            // gradient side lines
            Row(
              children: [
                Container(width: 4, color: Colors.orange.shade300),
                Expanded(child: Container()),
                Container(width: 4, color: Colors.green.shade400),
              ],
            ),

            Column(
              children: [
                // 🌐 Network Banner
                Container(
                  width: double.infinity,
                  height: size.height * 0.32,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1600&q=80",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Escape • Relax • Stay Cozy 🌿".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // 📋 Main Content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Plan Your Stay".tr,
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Find homestays near you or any location ✨".tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 📍 Location field
                          TextFormField(
                            controller: controller.searchLocation,
                            decoration: InputDecoration(
                              hintText: "Find your location".tr,
                              prefixIcon: const Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green.shade300,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green.shade700,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a location";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // 📅 Check-in / Check-out
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      _selectDate(context, isCheckIn: true),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: controller.formatDate(
                                          controller.checkInDate,
                                        ),
                                        labelText:
                                            controller.checkInDate == null
                                            ? "Check-in"
                                            : controller.checkInDate.toString(),
                                        prefixIcon: const Icon(
                                          Icons.calendar_today_outlined,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      validator: (_) {
                                        if (controller.checkInDate == null) {
                                          return "selectcheckinDate".tr;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      _selectDate(context, isCheckIn: false),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: controller.formatDate(
                                          controller.checkOutDate,
                                        ),
                                        labelText:
                                            controller.checkOutDate == null
                                            ? "Check-out"
                                            : controller.checkOutDate
                                                  .toString(),
                                        prefixIcon: const Icon(
                                          Icons.calendar_today_outlined,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      validator: (_) {
                                        if (controller.checkOutDate == null) {
                                          return "selectcheckoutDate".tr;
                                        }
                                        if (controller.checkInDate != null &&
                                            controller.checkOutDate!.isBefore(
                                              controller.checkInDate!,
                                            )) {
                                          return "checkoutmustbeafter".tr;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // 🔎 FIND Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.searchHotel().whenComplete(() {
                                    final model = controller.searchHotelModel;
                                    if ( model.status == true) {
                                      Get.to(
                                        () => HomeStaySearchScreen(),
                                        arguments: model,
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        "No hotels found",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  });
                                }
                              },
                              child: Text(
                                "FIND HOMESTAYS".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📅 Date Picker
  Future<void> _selectDate(
    BuildContext context, {
    required bool isCheckIn,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (isCheckIn) {
        controller.checkInDate = picked;
      } else {
        controller.checkOutDate = picked;
      }
    }
    controller.update();
  }

  // Reusable counter
}
