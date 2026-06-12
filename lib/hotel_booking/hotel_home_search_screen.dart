import 'package:elior/app_values/app_theme.dart';
import 'package:elior/hotel_booking/seach_screen.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/app_text_field.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/hotel_controller/home_controller.dart';

class HotelHomeSearchScreen extends StatefulWidget {

  HotelHomeSearchScreen({super.key});

  @override
  State<HotelHomeSearchScreen> createState() => _HotelHomeSearchScreenState();
}

class _HotelHomeSearchScreenState extends State<HotelHomeSearchScreen> {

  final checkInController = TextEditingController();
  final checkOutController = TextEditingController();

  DateTime? checkInDate;
  DateTime? checkOutDate;

  final controller = Get.put(HomeController());

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    checkInController.dispose();
    checkOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      builder: (_) => Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: getAppBar(context, "Search Hotels", centerTitle: false),

        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/pools.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Find your next stay!",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.black,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Discover the perfect stay with Elior Booking",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppTheme.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 24),

                          AppTextField(
                            controller: controller.searchLocation,
                            onChanged: controller.fetchSuggestions,
                            placeholder: "Search with Hotel or Area name",
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                              color: AppTheme.appThemeColor,
                            ),
                          ),

                          if (controller.suggestions.isNotEmpty)
                            Container(
                              height: 300,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.suggestions.length,
                                itemBuilder: (context, index) {
                                  final item = controller.suggestions[index];

                                  return ListTile(
                                    leading: Icon(
                                      item.type == "hotel"
                                          ? Icons.location_city
                                          : Icons.location_on,
                                      color: AppTheme.appThemeColor,
                                    ),
                                    title: Text(item.name),
                                    onTap: () {
                                      controller.searchLocation.text =
                                          item.name;
                                      controller.suggestions.clear();
                                      controller.update();
                                    },
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  onTap: () => _selectDate(context, isCheckIn: true),
                                  controller: checkInController,
                                  placeholder: "Check-In",
                                  readOnly: true,
                                  prefixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: AppTextField(
                                  onTap: () => _selectDate(context, isCheckIn: false),
                                  controller: checkOutController,
                                  placeholder: "Check-Out",
                                  readOnly: true,
                                  prefixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          AppButton(
                            title: "Find",
                            onTap: () async {
                              if (controller.searchLocation.text
                                  .trim()
                                  .isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please enter a location",
                                );
                                return;
                              }

                              if (controller.checkInDate == null) {
                                Get.snackbar("Error", "Select check-in date");
                                return;
                              }

                              if (controller.checkOutDate == null) {
                                Get.snackbar("Error", "Select check-out date");
                                return;
                              }

                              await controller.searchHotel();

                              final model = controller.searchHotelModel;

                              if (model.status == true) {
                                Get.to(() => SearchScreen(), arguments: model);
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "No hotels found",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Date picker logic
  Future<void> _selectDate(
      BuildContext context, {
        required bool isCheckIn,
      }) async {

    // Prevent opening checkout first
    if (!isCheckIn && controller.checkInDate == null) {
      Get.snackbar(
        "Select Check-In First",
        "Please select a check-in date before choosing check-out.",
      );
      return;
    }

    DateTime? initialCheckOutDate = controller.checkInDate?.add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,

      // For check-in: initial date is today or current check-in date if exists
      // For check-out: initial date is the selected check-in date



      initialDate: isCheckIn
          ? (controller.checkInDate ?? DateTime.now())
          : (controller.checkOutDate ?? initialCheckOutDate),

      // For check-in: first available date is today
      // For check-out: first available date is the selected check-in date
      firstDate: isCheckIn
          ? DateTime.now()
          : controller.checkInDate!,

      lastDate: DateTime(2100),

      // Optional: Set initial date to check-in if user is selecting check-out
      // and no check-out date is selected yet
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked == null) return;

    final formattedDate = DateFormat('dd MMM yyyy').format(picked);

    // Additional validation: Check-out must be after check-in
    if (!isCheckIn && picked.isBefore(controller.checkInDate!)) {
      Get.snackbar(
        "Invalid Date",
        "Check-out date cannot be before check-in date. Please select a date after ${DateFormat('dd MMM yyyy').format(controller.checkInDate!)}",
      );
      return;
    }

    if (isCheckIn) {
      // If user selects check-in date, reset check-out if it's before the new check-in date
      setState(() {
        controller.checkInDate = picked;
        checkInController.text = formattedDate;

        // If existing check-out date is before new check-in date, clear it
        if (controller.checkOutDate != null && controller.checkOutDate!.isBefore(picked)) {
          controller.checkOutDate = null;
          checkOutController.clear();
        }
      });
    } else {
      setState(() {
        controller.checkOutDate = picked;
        checkOutController.text = formattedDate;
      });
    }

    controller.update();
  }

}
