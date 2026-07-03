import 'package:elior/app_values/app_theme.dart';

import 'package:elior/transport_booking/seat_booking.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../response_model/transport_response/bus_route_response.dart';

class BusListScreen extends StatefulWidget {
  final BusListResponse busListResponse;

  const BusListScreen({super.key, required this.busListResponse});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  String selectedCategory = "sort_by".tr;
  String? busDate;
  String? getBusDate;

  String selectedSort = "relevance".tr;

  final Map<String, List<String>> filterOptions = {
    "sort_by": [
      "relevance",
      "price_low_to_high",
      "best_rated_first",
      "early_departure",
      "late_departure",
    ],
    "departure_time": [
      "before_6_am",
      "6_am_to_12_pm",
      "12_pm_to_6_pm",
      "after_6_pm",
    ],
    "bus_type": ["ac", "non_ac", "sleeper", "seater"],
    "bus_operator": ["laxmi_travels", "our_bus", "chandra_raj_travels"],
  };

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "filter_buses".tr,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Content row
                  Expanded(
                    child: Row(
                      children: [
                        // Left category panel
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border(
                              right: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          child: ListView(
                            children: filterOptions.keys.map((category) {
                              bool isSelected = category == selectedCategory;
                              return InkWell(
                                onTap: () {
                                  setModalState(() {
                                    selectedCategory = category;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.appThemeColor.withOpacity(.10)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.appThemeColor
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: AppTheme.appThemeColor,
                                          size: 18,
                                        ),
                                      if (isSelected)
                                        const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          category.tr,
                                          style: GoogleFonts.inter(
                                            fontWeight:
                                            isSelected ? FontWeight.w600 : FontWeight.w500,
                                            color: isSelected
                                                ? AppTheme.appThemeColor
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // Right options panel
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListView(
                              children: filterOptions[selectedCategory]!.map((
                                  option,
                                  ) {
                                return InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    setModalState(() {
                                      selectedSort = option;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: selectedSort == option
                                          ? AppTheme.appThemeColor.withOpacity(.08)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: selectedSort == option
                                            ? AppTheme.appThemeColor
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option.tr,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 250),
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: selectedSort == option
                                                  ? AppTheme.appThemeColor
                                                  : Colors.grey,
                                            ),
                                            color: selectedSort == option
                                                ? AppTheme.appThemeColor
                                                : Colors.transparent,
                                          ),
                                          child: selectedSort == option
                                              ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom buttons
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                selectedSort = "relevance";
                                selectedCategory = "sort_by";
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black26),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              "clear_all".tr,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${"applied_label".tr}: ${selectedSort.tr}"),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.appThemeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              "${"view_buses".tr} ${widget.busListResponse.data?.length ?? 0} ${"buses_label".tr}",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.white,
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
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getBusDate = LocalStorages().getBusDate() ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final buses = widget.busListResponse.data ?? [];
    final hasBuses = buses.isNotEmpty;

    return Scaffold(
      appBar: getAppBar(context, "available_buses".tr, centerTitle: false),
      body: hasBuses
          ? ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return _BusCard(
            bus: bus,
            onTap: () {
              Get.to(
                    () => BusSeatScreen(
                  origin: bus.origin ?? '',
                  destination: bus.destination ?? '',
                  busId: bus.busId ?? 0,
                  busRouteId: bus.busRouteId ?? 0,
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bus,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "no_buses_available".tr,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "try_different_route".tr,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        openFilterSheet();
      },
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSortButton(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('|'),
          ),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return Row(
      children: [
        const Icon(Icons.sort, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          'sort'.tr,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return Row(
      children: [
        const Icon(Icons.filter_list, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          'filter'.tr,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BusCard extends StatelessWidget {
  final BusModel bus;
  final VoidCallback onTap;

  const _BusCard({required this.bus, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Name & Rating
                Row(
                  children: [
                    if (bus.companyLogo != null && bus.companyLogo!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          bus.companyLogo!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.business, size: 40),
                        ),
                      )
                    else
                      const Icon(Icons.business, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bus.companyName ?? "unknown_company".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            bus.busTypeName ?? "standard_bus".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Fare
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bus.fareText,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.appThemeColor,
                          ),
                        ),
                        Text(
                          "per_seat".tr,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Route & Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bus.departureTime,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bus.origin ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          bus.durationHuman ?? '--',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 80,
                          height: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.circle,
                              size: 6,
                              color: Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bus.arrivalTime,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bus.destination ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Features
                if (bus.features != null && bus.features!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: bus.features!.map((feature) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Text(
                          feature,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 12),
                // View Seats Button
                AppButton(title: "view_seats".tr, onTap: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}