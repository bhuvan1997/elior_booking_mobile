import 'dart:async';

import 'package:elior/home_stay/home_stay_booking_detail.dart';
import 'package:elior/response_model/filter_model.dart';
import 'package:elior/response_model/property/property_search_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../network/service_provider.dart';
import '../response_model/fav_model/add_fav_moodel.dart';
import '../response_model/search_filter_model.dart';
import '../response_model/search_sorting_model.dart';
import '../utils/storage.dart';
import '../utils/translator_service.dart';

class HomeStaySearchScreen extends StatefulWidget {
  const HomeStaySearchScreen({super.key});

  @override
  State<HomeStaySearchScreen> createState() => _HomeStaySearchScreenState();
}

class _HomeStaySearchScreenState extends State<HomeStaySearchScreen> {
  final PropertySearchResponse model = Get.arguments;
  late TextEditingController _searchController;
  List<Property> filteredHotels = []; // Changed from List<Data> to List<Property>
  var isEditable = false;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Convert Data to Property for filteredHotels
    if (model.data != null) {
      filteredHotels = [];//model.data!.map((data) => Property.fromData(data)).toList();
    }

    _translateHotels();
    locationController.text = model.searchParams?.search ?? "";
    checkInDate = model.searchParams?.startDate != null
        ? DateTime.tryParse(model.searchParams!.startDate!)
        : DateTime.now();
    checkOutDate = model.searchParams?.endDate != null
        ? DateTime.tryParse(model.searchParams!.endDate!)
        : DateTime.now().add(const Duration(days: 1));
  }

  PropertySearchResponse searchHotelModel = PropertySearchResponse();

  Future<void> _translateHotels() async {
    if (filteredHotels.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        String langCode = Get.locale?.languageCode ?? "en";
        await HotelTranslator.translateHotels(filteredHotels, langCode);
        setState(() {}); // refresh only translated fields
      });
    }
  }

  String formatDatess(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'DD/MM';
    try {
      final parsedDate = DateFormat("yyyy-MM-dd").parse(dateStr);
      return DateFormat("d MMM").format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  String formatDates(DateTime? date) {
    if (date == null) return 'yyyy-MM-dd';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatApiDate(String inputDate) {
    try {
      DateTime date = DateFormat("d/M/yyyy").parse(inputDate);
      return DateFormat("yyyy-MM-dd").format(date);
    } catch (e) {
      return inputDate; // fallback in case of error
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'yyyy-MM-dd';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  bool _isLoading = false;

  Future<void> searchHotel() async {
    setState(() => _isLoading = true);
    try {
      searchHotelModel = await ServiceProvider().searchHomeStayApi(
        search: locationController.text.trim(),
        startDate: formatDate(checkInDate),
        endDate: formatDate(checkOutDate),
      );

      if (searchHotelModel.status == true && searchHotelModel.data != null) {
        // FIX: Convert Property list to filteredHotels (already List<Property>)
        filteredHotels = searchHotelModel.data!;
        // Update model.data with Property list
        model.data = [];//searchHotelModel.data!.map((property) => Data.fromProperty(property)).toList();
        await _translateHotels();
      } else {
        filteredHotels = [];
      }
    } catch (e) {
      debugPrint('Error occurred while searching: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterHotels(String query) {
    setState(() {
      List<Property> sourceList = [];

      // Always use the most recent data (from API if available)
      if (searchHotelModel.data != null && searchHotelModel.data!.isNotEmpty) {
        sourceList = searchHotelModel.data!;
      } else if (model.data != null && model.data!.isNotEmpty) {
        // Convert Data to Property for filtering
        sourceList = [];//model.data!.map((data) => Property.fromData(data)).toList();
      }

      if (query.isEmpty) {
        filteredHotels = sourceList;
      } else {
        filteredHotels = sourceList.where((hotel) {
          final city = hotel.city?.toLowerCase() ?? '';
          final country = hotel.country?.toLowerCase() ?? '';
          final name = hotel.name?.toLowerCase() ?? '';
          final search = query.toLowerCase();

          return city.contains(search) ||
              country.contains(search) ||
              name.contains(search);
        }).toList();
      }
    });
  }

  String selectedSort = 'Price: Low to High';
  bool showOnlyAvailable = false;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterHotels(query);
    });
  }

  String formatTime(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsed);
    } catch (e) {
      return time;
    }
  }

  FilterModel filterModel = FilterModel();

  Future<void> filterFetchHotels() async {
    setState(() => _isLoading = true);
    try {
      filterModel = await ServiceProvider().filterHomeStayApi();

      if (filterModel.status == true) {
        _openFilterBottomSheet();
      } else {
        debugPrint('Filter API returned status = false');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load filters')));
      }
    } catch (e) {
      debugPrint('Filter data error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> filterSortHotels() async {
    setState(() => _isLoading = true);
    try {
      filterModel = await ServiceProvider().filterHomeStayApi();

      if (filterModel.status == true) {
        _openFilterSortSheet();
      } else {
        debugPrint('Filter API returned status = false');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load filters')));
      }
    } catch (e) {
      debugPrint('Filter data error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Set<int> favoriteIds = {};
  SelectFaModel selectFaModel = SelectFaModel();

  Future<void> selectFavApi({required int id}) async {
    try {
      final data = await ServiceProvider().selectFavProperty(propertyId: id);
      setState(() {
        selectFaModel = data;
      });
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  Future<void> removeFavApi({required int id}) async {
    try {
      await ServiceProvider().removeFavProperty(propertyId: id);
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  SearchFilterModel searchFilterModel = SearchFilterModel();
  SearchSotingModel searchSotingModel = SearchSotingModel();

  Future<void> searchHotelWithFilters({
    List<String>? features,
    List<String>? rules,
    List<int>? stars,
    String? pricing,
  }) async {
    setState(() => _isLoading = true);
    try {
      searchFilterModel = await ServiceProvider().searchFilterHomeApi(
        search: locationController.text.trim(),
        startDate: formatDate(checkInDate),
        endDate: formatDate(checkOutDate),
        amenities: features,
        rules: rules,
        pricing: pricing,
      );

      if (searchFilterModel.data != null &&
          searchFilterModel.data!.isNotEmpty) {
        // FIX: Convert Datams to Property
        List<Property> newFilteredList = searchFilterModel.data!
            .map((d) => Property.fromDatam(d))
            .toList();

        filteredHotels = newFilteredList;
        searchHotelModel.data = newFilteredList;

        // Also update model.data for consistency
        model.data = [];//newFilteredList.map((property) => Data.fromProperty(property)).toList();

        await _translateHotels();
      } else {
        filteredHotels = [];
        searchHotelModel.data = [];
      }

      setState(() {});
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
    } catch (e) {
      debugPrint('Error while searching with filters: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> searchHotelWithSorting({String? sorting}) async {
    setState(() => _isLoading = true);
    try {
      searchSotingModel = await ServiceProvider().searchSortingHomeApi(
        search: locationController.text.trim(),
        startDate: formatDate(checkInDate),
        endDate: formatDate(checkOutDate),
        sort: sorting ?? "",
      );

      if (searchSotingModel.data != null &&
          searchSotingModel.data!.isNotEmpty) {
        // FIX: Convert DataSort to Property
        List<Property> newFilteredList = searchSotingModel.data!
            .map((d) => Property.fromDataSort(d))
            .toList();

        filteredHotels = newFilteredList;
        searchHotelModel.data = newFilteredList;

        // Also update model.data for consistency
        model.data = [];//newFilteredList.map((property) => Data.fromProperty(property)).toList();

        await _translateHotels();
      } else {
        filteredHotels = [];
        searchHotelModel.data = [];
      }

      setState(() {});
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
    } catch (e) {
      debugPrint('Error while searching with sorting: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  var isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sort section
                  InkWell(
                    onTap: () {
                      filterSortHotels();
                    },
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sort, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            'Sort',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Divider
                  Container(width: 1, height: 24, color: Colors.grey[300]),

                  // Filter section
                  InkWell(
                    onTap: () {
                      filterFetchHotels();
                    },
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_list, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            'Filter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  model.searchParams?.search ?? "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: _buildDateCard(
                                    Icons.calendar_today,
                                    "${formatDatess(model.searchParams?.startDate)} - ${formatDatess(model.searchParams?.endDate)}",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearch = !isSearch;
                            });
                          },
                          child: const Icon(Icons.search, color: Colors.orange),
                        ),
                      ],
                    ),
                    isEditable == true
                        ? Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top drag handle
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          // Location field
                          _buildLocationField(),

                          const SizedBox(height: 16),

                          // Date pickers
                          Row(
                            children: [
                              Expanded(child: _buildCheckInPicker()),
                              const SizedBox(width: 10),
                              Expanded(child: _buildCheckOutPicker()),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Update Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B00),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                await searchHotel();
                                setState(() {
                                  model.searchParams?.search =
                                      locationController.text;
                                  model.searchParams?.startDate =
                                      formatDate(checkInDate!);
                                  model.searchParams?.endDate =
                                      formatDate(checkOutDate!);
                                  isEditable = false; // close edit view
                                });
                              },
                              child: _isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                "Update Search",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
            isEditable == false && isSearch == true
                ? _buildSearchBar()
                : Container(),
            const SizedBox(height: 20),
            _buildFilters(),
            const SizedBox(height: 20),
            _buildHotelList(),
          ],
        ),
      ),
    );
  }

  void _openFilterBottomSheet() {
    // Track expanded sections outside StatefulBuilder
    bool showAllFeatures = false;
    bool showAllRules = false;
    bool showAllStars = false;
    bool showAllPrices = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        // Temporary selections
        List<String> tempSelectedFeatures = [];
        List<String> tempSelectedRules = [];
        List<String> tempSelectedStars = [];
        String? tempSelectedPrice;

        return StatefulBuilder(
          builder: (context, localSetState) {
            final allFeatures = filterModel.allFeatures ?? [];
            final allRules = filterModel.allRules ?? [];
            final starRatingsMap =
                filterModel.starRating?.toJson().map(
                      (k, v) => MapEntry(k, v),
                ) ??
                    {};
            final starRatings = starRatingsMap.keys
                .where((e) => e.isNotEmpty)
                .toList();

            final pricingMap =
                filterModel.pricing?.toJson().map((k, v) => MapEntry(k, v)) ??
                    {};
            final pricingRanges = pricingMap.keys
                .where((e) => e.isNotEmpty)
                .toList();

            Widget buildExpandableChipSection({
              required String title,
              required List<String> options,
              required List<String>? selectedValues,
              required String? selectedValue,
              required bool isMultiSelect,
              required Function(String) onSelected,
              required bool showAll,
              required VoidCallback onToggle,
            }) {
              final visibleItems = showAll ? options : options.take(4).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: visibleItems.map((option) {
                      final bool isSelected = isMultiSelect
                          ? selectedValues!.contains(option)
                          : selectedValue == option;
                      return ChoiceChip(
                        label: Text(option),
                        selected: isSelected,
                        onSelected: (_) => onSelected(option),
                        selectedColor: Colors.orange.shade100,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.orange.shade800
                              : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  if (options.length > 4)
                    TextButton(
                      onPressed: onToggle,
                      child: Text(
                        showAll ? 'View less' : 'View all (${options.length})',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              );
            }

            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildExpandableChipSection(
                              title: "Hotel Features",
                              options: allFeatures,
                              selectedValues: tempSelectedFeatures,
                              selectedValue: null,
                              isMultiSelect: true,
                              onSelected: (v) => localSetState(() {
                                if (tempSelectedFeatures.contains(v)) {
                                  tempSelectedFeatures.remove(v);
                                } else {
                                  tempSelectedFeatures.add(v);
                                }
                              }),
                              showAll: showAllFeatures,
                              onToggle: () => localSetState(() {
                                showAllFeatures = !showAllFeatures;
                              }),
                            ),
                            buildExpandableChipSection(
                              title: "Hotel Rules",
                              options: allRules,
                              selectedValues: tempSelectedRules,
                              selectedValue: null,
                              isMultiSelect: true,
                              onSelected: (v) => localSetState(() {
                                if (tempSelectedRules.contains(v)) {
                                  tempSelectedRules.remove(v);
                                } else {
                                  tempSelectedRules.add(v);
                                }
                              }),
                              showAll: showAllRules,
                              onToggle: () => localSetState(() {
                                showAllRules = !showAllRules;
                              }),
                            ),
                            buildExpandableChipSection(
                              title: "Hotel Price Range",
                              options: pricingRanges,
                              selectedValues: null,
                              selectedValue: tempSelectedPrice,
                              isMultiSelect: false,
                              onSelected: (v) => localSetState(() {
                                tempSelectedPrice = v;
                              }),
                              showAll: showAllPrices,
                              onToggle: () => localSetState(() {
                                showAllPrices = !showAllPrices;
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          debugPrint('Features: $tempSelectedFeatures');
                          debugPrint('Rules: $tempSelectedRules');
                          debugPrint('Stars: $tempSelectedStars');
                          debugPrint('Price: $tempSelectedPrice');
                          Navigator.pop(context);

                          await searchHotelWithFilters(
                            features: tempSelectedFeatures,
                            rules: tempSelectedRules,
                            stars: tempSelectedStars
                                .map(
                                  (e) =>
                              int.tryParse(
                                e.replaceAll(RegExp(r'[^0-9]'), ''),
                              ) ??
                                  0,
                            )
                                .toList(),
                            pricing: tempSelectedPrice,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Show Properties',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const Row(children: [SizedBox(width: 10)]),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search hotels...",
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
        ],
      ),
    );
  }

  void _openFilterSortSheet() {
    if (filterModel.sorting == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sorting options not available')),
      );
      return;
    }

    // Convert Sorting object → Map<String, dynamic>
    final Map<String, dynamic> sortingOptions = filterModel.sorting!.toJson();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        String tempSelectedSort = selectedSort;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top drag handle ──
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // ── Header row ──
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sort by',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Dynamic sorting options ──
                  ...sortingOptions.entries.map((entry) {
                    final label = entry.key; // e.g. "Price: Low to High"
                    final value = entry.value; // e.g. "price_asc"
                    return RadioListTile<String>(
                      value: value,
                      groupValue: tempSelectedSort,
                      onChanged: (val) {
                        setModalState(() => tempSelectedSort = val!);
                      },
                      title: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      activeColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // ── Confirm button ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() => selectedSort = tempSelectedSort);

                        // ✅ Call the API with the selected sort value
                        await searchHotelWithSorting(sorting: selectedSort);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            "Show Properties in ${locationController.text ?? ""}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  /// 🏨 Hotel list
  Widget _buildHotelList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (filteredHotels.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No hotels found'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredHotels.length,
      itemBuilder: (context, index) {
        var data = filteredHotels[index];
        return GestureDetector(
          onTap: () {
            LocalStorages().saveCheckIn(
              checkIn: formatApiDate(model.searchParams?.startDate ?? ""),
            );
            LocalStorages().saveCheckOut(
              checkOut: formatApiDate(model.searchParams?.endDate ?? ""),
            );
            Get.to(
                  () => HomeStayDetailsScreen(
                id: data.id ?? 0,
                fac: data.translatedDescription ?? "",
              ),
            );
          },
          child: _buildHotelCard(data),
        );
      },
    );
  }

  /// 🏨 Beautiful hotel card (modern style)
  Widget _buildHotelCard(Property data) {
    String imageUrl = (data.images?.isNotEmpty ?? false)
        ? data.images!.first
        : "https://via.placeholder.com/400";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () async {
                      int id = data.id ?? 0;

                      if (favoriteIds.contains(id)) {
                        setState(() {
                          favoriteIds.remove(id);
                        });
                        await removeFavApi(id: id);
                      } else {
                        setState(() {
                          favoriteIds.add(id);
                        });
                        await selectFavApi(id: id);
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        favoriteIds.contains(data.id ?? 0)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoriteIds.contains(data.id ?? 0)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hotel details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data.name ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                        const SizedBox(width: 4),
                        Text(
                          "${data.starRating?.toString() ?? "0"}/5",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data.translatedCityCountry ?? "${data.city ?? ""}, ${data.country ?? ""}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Check-In: ${formatTime(data.checkInTime?.toString() ?? "")} | Check-out: ${formatTime(data.checkOutTime?.toString() ?? "")}",
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "${data.currency ?? ""}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      " ${data.pricePerNight ?? ""} /Night",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Area, Landmark",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            TextField(
              controller: locationController,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInPicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: checkInDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (picked != null) {
          setState(() {
            checkInDate = picked;

            // Ensure check-out date is always after check-in
            if (checkOutDate == null || checkOutDate!.isBefore(picked)) {
              checkOutDate = picked.add(const Duration(days: 1));
            }
          });
        }
      },
      child: _buildDateContainer(label: "Check-in Date", date: checkInDate!),
    );
  }

  Widget _buildCheckOutPicker() {
    final firstAllowed = checkInDate ?? DateTime.now();
    final initialDate =
    checkOutDate != null && checkOutDate!.isAfter(firstAllowed)
        ? checkOutDate!
        : firstAllowed.add(const Duration(days: 1));

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstAllowed,
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );

        if (picked != null) {
          setState(() {
            checkOutDate = picked;
          });
        }
      },
      child: _buildDateContainer(label: "Check-out Date", date: checkOutDate!),
    );
  }

  Widget _buildDateContainer({required String label, required DateTime date}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " ${DateFormat('d MMM, yyyy').format(date)}",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// 📅 Date/Guest cards
  Widget _buildDateCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (isEditable == false) {
                isEditable = true;
              } else {
                isEditable = false;
              }
              setState(() {});
            },
            child: Text(
              "Edit",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hotel Translator - Updated to work with Property
class HotelTranslator {
  static Future<void> translateHotels(
      List<Property> hotels,
      String langCode,
      ) async {
    final translator = TranslationService();
    for (var hotel in hotels) {
      hotel.translatedName = await translator.translateText(
        hotel.name ?? "",
        langCode,
      );
      hotel.translatedCityCountry = await translator.translateText(
        "${hotel.city ?? ""}, ${hotel.country ?? ""}",
        langCode,
      );
      hotel.translatedDescription = await translator.translateText(
        hotel.description ?? "",
        langCode,
      );
      hotel.translatedAddress = await translator.translateText(
        hotel.address ?? "",
        langCode,
      );
    }
  }
}