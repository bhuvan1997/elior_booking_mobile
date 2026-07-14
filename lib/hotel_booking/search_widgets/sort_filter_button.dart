// ---------------------------------------------------------------------
// Floating action button (sort / filter)
// ---------------------------------------------------------------------

import 'package:elior/controller/hotel_home_result_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildFloatingActionButton(
  BuildContext context, {
  required HotelHomeResultController controller,
  required String slug,
}) {
  return FloatingActionButton.extended(
    onPressed: () {},
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPillButton(
          icon: Icons.sort,
          label: 'sort'.tr,
          onTap: () => _openSort(context, controller),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('|'),
        ),
        _buildPillButton(
          icon: Icons.filter_list,
          label: 'filter'.tr,
          onTap: () => _openFilters(context, controller, slug),
        ),
      ],
    ),
  );
}

Widget _buildPillButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Future<void> _openFilters(
  BuildContext context,
  HotelHomeResultController controller,
  String slug,
) async {
  final success = await controller.loadFilters();
  if (!context.mounted) return;
  if (success) {
    _openFilterBottomSheet(context, controller, slug);
  } else {
    Get.snackbar("error".tr, "failed".tr);
  }
}

Future<void> _openSort(
  BuildContext context,
  HotelHomeResultController controller,
) async {
  final success = await controller.loadSortOptions();
  if (!context.mounted) return;
  if (success) {
    _openFilterSortSheet(context, controller);
  } else {
    Get.snackbar("error".tr, "something_went_wrong".tr);
  }
}

void _openFilterBottomSheet(
  BuildContext context,
  HotelHomeResultController controller,
  String slug,
) {
  bool showAllFeatures = false;
  bool showAllRules = false;
  bool showAllStars = false;
  bool showAllPrices = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (sheetContext) {
      final List<String> tempSelectedFeatures = [];
      final List<String> tempSelectedRules = [];
      final List<String> tempSelectedStars = [];
      String? tempSelectedPrice;

      return StatefulBuilder(
        builder: (sheetContext, localSetState) {
          final allFeatures = controller.filterModel.allFeatures ?? [];
          final allRules = controller.filterModel.allRules ?? [];
          final starRatings =
              (controller.filterModel.starRating?.toJson().keys.where(
                        (e) => e.isNotEmpty,
                      ) ??
                      [])
                  .toList();
          final pricingRanges =
              (controller.filterModel.pricing?.toJson().keys.where(
                        (e) => e.isNotEmpty,
                      ) ??
                      [])
                  .toList();

          return FractionallySizedBox(
            heightFactor: 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDragHandle(),
                  _buildFilterHeader(sheetContext),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterSection(
                            title: slug == "hotel"
                                ? "hotel_features".tr
                                : "home_features".tr,
                            options: allFeatures,
                            selectedValues: tempSelectedFeatures,
                            isMultiSelect: true,
                            showAll: showAllFeatures,
                            onToggle: () => localSetState(
                              () => showAllFeatures = !showAllFeatures,
                            ),
                            onSelected: (v) => localSetState(() {
                              if (tempSelectedFeatures.contains(v)) {
                                tempSelectedFeatures.remove(v);
                              } else {
                                tempSelectedFeatures.add(v);
                              }
                            }),
                          ),
                          _buildFilterSection(
                            title: slug == "hotel" ? "hotel_rules".tr : "home_rules".tr,
                            options: allRules,
                            selectedValues: tempSelectedRules,
                            isMultiSelect: true,
                            showAll: showAllRules,
                            onToggle: () => localSetState(
                              () => showAllRules = !showAllRules,
                            ),
                            onSelected: (v) => localSetState(() {
                              if (tempSelectedRules.contains(v)) {
                                tempSelectedRules.remove(v);
                              } else {
                                tempSelectedRules.add(v);
                              }
                            }),
                          ),
                          if (starRatings.isNotEmpty)
                            _buildFilterSection(
                              title: slug == "hotel" ?  "hotel_star_rating".tr : "home_star_rating".tr,
                              options: starRatings,
                              selectedValues: tempSelectedStars,
                              isMultiSelect: true,
                              showAll: showAllStars,
                              onToggle: () => localSetState(
                                () => showAllStars = !showAllStars,
                              ),
                              onSelected: (v) => localSetState(() {
                                if (tempSelectedStars.contains(v)) {
                                  tempSelectedStars.remove(v);
                                } else {
                                  tempSelectedStars.add(v);
                                }
                              }),
                            ),
                          if (pricingRanges.isNotEmpty)
                            _buildFilterSection(
                              title: slug == "hotel" ? "hotel_price_range".tr : "home_price_range".tr,
                              options: pricingRanges,
                              selectedValues: null,
                              selectedValue: tempSelectedPrice,
                              isMultiSelect: false,
                              showAll: showAllPrices,
                              onToggle: () => localSetState(
                                () => showAllPrices = !showAllPrices,
                              ),
                              onSelected: (v) =>
                                  localSetState(() => tempSelectedPrice = v),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildApplyButton(() async {
                    Navigator.pop(sheetContext);
                    await controller.searchHotelWithFilters(
                      features: tempSelectedFeatures,
                      rules: tempSelectedRules,
                      stars: controller.starLabelsToValues(tempSelectedStars),
                      pricing: tempSelectedPrice,
                    );
                  }),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void _openFilterSortSheet(
  BuildContext context,
  HotelHomeResultController controller,
) {
  if (controller.filterModel.sorting == null) return;

  final sortingOptions = controller.filterModel.sorting!.toJson();
  String tempSelectedSort = controller.selectedSort.value;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSortHeader(sheetContext),
                const SizedBox(height: 16),
                ...sortingOptions.entries.map(
                  (entry) => RadioListTile<String>(
                    value: entry.value,
                    groupValue: tempSelectedSort,
                    onChanged: (val) =>
                        setModalState(() => tempSelectedSort = val!),
                    title: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    activeColor: Colors.orange,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 24),
                _buildApplyButton(() async {
                  Navigator.pop(sheetContext);
                  await controller.searchHotelWithSorting(
                    sorting: tempSelectedSort,
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildFilterHeader(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'filters'.tr,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Text(
          'clear'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ),
    ],
  );
}

Widget _buildFilterSection({
  required String title,
  required List<String> options,
  List<String>? selectedValues,
  String? selectedValue,
  required bool isMultiSelect,
  required VoidCallback onToggle,
  required Function(String) onSelected,
  required bool showAll,
}) {
  final visibleItems = showAll ? options : options.take(4).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(),
      Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: visibleItems.map((option) {
          final isSelected = isMultiSelect
              ? selectedValues!.contains(option)
              : selectedValue == option;
          return ChoiceChip(
            label: Text(option),
            selected: isSelected,
            onSelected: (_) => onSelected(option),
            selectedColor: Colors.orange.shade100,
            labelStyle: TextStyle(
              color: isSelected ? Colors.orange.shade800 : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
      if (options.length > 4)
        TextButton(
          onPressed: onToggle,
          child: Text(
            showAll ? 'view_less'.tr : '${"view_all".tr} (${options.length})',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
    ],
  );
}

Widget _buildApplyButton(VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        'show_properties'.tr,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget _buildDragHandle() {
  return Container(
    width: 50,
    height: 5,
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

// ---------------------------------------------------------------------
// Sort bottom sheet
// ---------------------------------------------------------------------

Widget _buildSortHeader(BuildContext context) {
  return Row(
    children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      ),
      const SizedBox(width: 10),
      Text(
        'sort_by'.tr,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
