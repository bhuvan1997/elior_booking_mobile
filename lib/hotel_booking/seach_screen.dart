import 'package:elior/app_values/app_theme.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/hotel_booking/search_widgets/hotel_card.dart';
import 'package:elior/hotel_booking/search_widgets/sort_filter_button.dart';
import 'package:elior/response_model/property/property_search_response.dart';
import 'package:elior/utils/project_utils.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/hotel_home_result_controller.dart';

class HotelHomeResultScreen extends StatefulWidget {
  const HotelHomeResultScreen({super.key});

  @override
  State<HotelHomeResultScreen> createState() => _HotelHomeResultScreenState();
}

class _HotelHomeResultScreenState extends State<HotelHomeResultScreen> {

  var controller = Get.put(HotelHomeResultController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: buildFloatingActionButton(context, controller: controller, slug: controller.slug ?? "hotel"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Obx(
              () => Column(
            children: [
              if (!controller.isEditable.value && controller.isSearch.value)
                _buildSearchBar(),
              if (controller.isEditable.value) _buildDatePickerFields(context),
              const SizedBox(height: 20),
              _buildHotelList(),
            ],
          ),
        ),
      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return getAppBar(
      context,
      controller.model.searchParams?.search ?? "",
      centerTitle: false,
      isSubtext: true,
      subtextWidget: GestureDetector(
        onTap: () => controller.setEditable(true),
        child: _buildDateCard(
          "${HotelDateFormatters.shortDate(controller.model.searchParams?.startDate)} - "
              "${HotelDateFormatters.shortDate(controller.model.searchParams?.endDate)}",
        ),
      ),
      trailing: [
        GestureDetector(
          onTap: () => controller.toggleSearchBar(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image(
              image: AssetImage(AssetsScreen.searchIconOrange),
              width: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "edit".tr,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }



  // ---------------------------------------------------------------------
  // Editable date/location panel
  // ---------------------------------------------------------------------

  Widget _buildDatePickerFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildLocationField(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateTextField(
                  controller,
                  controller.checkInController,
                  "check_in".tr,
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateTextField(
                  controller,
                  controller.checkOutController,
                  "check_out".tr,
                  false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(
            title: "update_search".tr,
            onTap: () async {
              final errorKey = controller.validateDateSearch();
              if (errorKey != null) {
                Get.snackbar("error".tr, errorKey.tr);
                return;
              }
              await controller.submitDateSearch();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.appThemeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "area_landmark".tr,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          TextField(
            controller: controller.locationController,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTextField(
      HotelHomeResultController hotelController,
      TextEditingController controller,
      String label,
      bool isCheckIn,
      ) {
    return GestureDetector(
      onTap: () async {
        final errorKey = await hotelController.selectDate(context, isCheckIn: isCheckIn);
        if (errorKey != null) {
          Get.snackbar("error".tr, "$errorKey".tr);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    controller.text.isEmpty ? "select_date".tr : controller.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.text.isEmpty
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // In-list quick search
  // ---------------------------------------------------------------------

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: "search_hotels".tr,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: Colors.orange),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Hotel list
  // ---------------------------------------------------------------------

  Widget _buildHotelList() {
    if (controller.filteredHotels.isEmpty) {
      return Center(child: Text("no_hotels_found".tr));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.filteredHotels.length,
      itemBuilder: (context, index) {
        final hotel = controller.filteredHotels[index];
        return HotelCard(
          data: hotel,
          isFavorite: hotel.isFavourite == 1,
          onTap: () => controller.navigateToHotelDetail(hotel),
          onFavoriteToggle: () async {
            try {
              await controller.toggleFavorite(hotel.id ?? 0);
            } catch (_) {
              Get.snackbar("error".tr, "failed".tr);
            }
          },
        );
      },
    );
  }
}