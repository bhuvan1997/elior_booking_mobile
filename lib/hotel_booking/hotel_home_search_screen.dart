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

                          // TextFormField(
                          //   controller: controller.searchLocation,
                          //   onChanged: controller.fetchSuggestions,
                          //   decoration: InputDecoration(
                          //     hintText: "Hotel, area name",
                          //     prefixIcon: const Icon(
                          //       Icons.location_on_outlined,
                          //     ),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   validator: (value) {
                          //     if (value == null || value.trim().isEmpty) {
                          //       return "Please enter location";
                          //     }
                          //     return null;
                          //   },
                          // ),
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

  Widget _dateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(value, style: const TextStyle(fontSize: 15)),
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

    final picked = await showDatePicker(
      context: context,

      // Check-In picker
      initialDate: isCheckIn
          ? DateTime.now()
          : controller.checkInDate!,

      // Disable previous dates
      firstDate: isCheckIn
          ? DateTime.now()
          : controller.checkInDate!,

      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    final formattedDate = DateFormat('dd MMM yyyy').format(picked);

    if (isCheckIn) {
      controller.checkInDate = picked;
      checkInController.text = formattedDate;

      // Reset checkout if checkin changes
      controller.checkOutDate = null;
      checkOutController.clear();
    } else {
      controller.checkOutDate = picked;
      checkOutController.text = formattedDate;
    }

    controller.update();
  }

}
