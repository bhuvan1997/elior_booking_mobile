import 'dart:async';

import 'package:elior/app_values/app_theme.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/response_model/fav_model/add_fav_moodel.dart';
import 'package:elior/response_model/filter_model.dart';
import 'package:elior/utils/project_utils.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../network/service_provider.dart';
import '../response_model/search_filter_model.dart';
import '../response_model/search_hotel_response.dart';
import '../response_model/search_sorting_model.dart';
import '../utils/storage.dart';
import '../utils/translator_service.dart';
import 'hotel_home_search_screen.dart';
import 'hotel_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchHotelModel model;
  late final TextEditingController _searchController;
  late final TextEditingController locationController;
  late final TextEditingController checkInController;
  late final TextEditingController checkOutController;

  List<Data> filteredHotels = [];
  DateTime? checkInDate;
  DateTime? checkOutDate;

  bool _isLoading = false;
  bool isEditable = false;
  bool isSearch = false;
  String selectedSort = 'Price: Low to High';

  Set<int> favoriteIds = {};
  SearchHotelModel searchHotelModel = SearchHotelModel();
  FilterModel filterModel = FilterModel();
  SelectFaModel selectFaModel = SelectFaModel();
  SearchFilterModel searchFilterModel = SearchFilterModel();
  SearchSotingModel searchSotingModel = SearchSotingModel();

  Timer? _debounce;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    model = Get.arguments;
    _initializeControllers();
    _initializeDates();
    _initializeFilteredHotels();
    _translateHotels();
  }

  void _initializeControllers() {
    _searchController = TextEditingController();
    locationController = TextEditingController();
    checkInController = TextEditingController();
    checkOutController = TextEditingController();

    locationController.text = model.searchParams?.search ?? "";
  }

  void _initializeDates() {
    checkInDate = _parseDate(model.searchParams?.startDate) ?? DateTime.now();
    checkOutDate = _parseDate(model.searchParams?.endDate) ?? DateTime.now().add(const Duration(days: 1));

    if (checkInDate != null) {
      checkInController.text = _formatDateForDisplay(checkInDate!);
    }
    if (checkOutDate != null) {
      checkOutController.text = _formatDateForDisplay(checkOutDate!);
    }
  }

  void _initializeFilteredHotels() {
    filteredHotels = model.data ?? [];
  }

  DateTime? _parseDate(String? dateStr) {
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }

  String _formatDateForDisplay(DateTime date) => DateFormat('dd MMM yyyy').format(date);
  String _formatDateForApi(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
  String _formatShortDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'DD/MM';
    try {
      return DateFormat("d MMM").format(DateFormat("yyyy-MM-dd").parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    locationController.dispose();
    checkInController.dispose();
    checkOutController.dispose();
    super.dispose();
  }

  Future<void> _translateHotels() async {
    if (filteredHotels.isEmpty) return;

    final langCode = Get.locale?.languageCode ?? "en";
    await HotelTranslator.translateHotels(filteredHotels, langCode);
    if (mounted) setState(() {});
  }

  Future<void> searchHotel() async {
    setState(() => _isLoading = true);
    try {
      final result = await ServiceProvider().searchHotelApi(
        search: locationController.text.trim(),
        startDate: checkInDate != null ? _formatDateForApi(checkInDate!) : "",
        endDate: checkOutDate != null ? _formatDateForApi(checkOutDate!) : "",
      );

      if (result.status == true && result.data != null) {
        filteredHotels = result.data!;
        model.data = result.data;
        searchHotelModel.data = result.data;
        await _translateHotels();
      } else {
        filteredHotels = [];
      }
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterHotels(String query) {
    setState(() {
      final sourceList = searchHotelModel.data?.isNotEmpty == true
          ? searchHotelModel.data!
          : model.data ?? [];

      filteredHotels = query.isEmpty
          ? sourceList
          : sourceList.where((hotel) {
        final searchText = query.toLowerCase();
        return hotel.city?.toLowerCase().contains(searchText) == true ||
            hotel.country?.toLowerCase().contains(searchText) == true ||
            hotel.name?.toLowerCase().contains(searchText) == true;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _filterHotels(query));
  }

  Future<void> _selectDate(BuildContext context, {required bool isCheckIn}) async {
    if (!isCheckIn && checkInDate == null) {
      _showSnackBar("Select Check-In First", "Please select a check-in date first.");
      return;
    }

    final initialDate = isCheckIn
        ? (checkInDate ?? DateTime.now())
        : (checkOutDate ?? checkInDate!.add(const Duration(days: 1)));

    final firstDate = isCheckIn ? DateTime.now() : checkInDate!;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked == null) return;

    if (!isCheckIn && picked.isBefore(checkInDate!)) {
      _showSnackBar("Invalid Date", "Check-out must be after check-in");
      return;
    }

    setState(() {
      if (isCheckIn) {
        checkInDate = picked;
        checkInController.text = _formatDateForDisplay(picked);
        if (checkOutDate?.isBefore(picked) == true) {
          checkOutDate = null;
          checkOutController.clear();
        }
      } else {
        checkOutDate = picked;
        checkOutController.text = _formatDateForDisplay(picked);
      }
    });
  }

  Future<void> filterFetchHotels() async {
    setState(() => _isLoading = true);
    try {
      filterModel = await ServiceProvider().filterHotelApi();
      if (filterModel.status == true) {
        _openFilterBottomSheet();
      } else {
        _showSnackBar("Error", "Failed to load filters");
      }
    } catch (e) {
      debugPrint('Filter error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> filterSortHotels() async {
    setState(() => _isLoading = true);
    try {
      filterModel = await ServiceProvider().filterHotelApi();
      if (filterModel.status == true && filterModel.sorting != null) {
        _openFilterSortSheet();
      } else {
        _showSnackBar("Error", "Sorting options not available");
      }
    } catch (e) {
      debugPrint('Sort error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> searchHotelWithFilters({
    List<String>? features,
    List<String>? rules,
    List<int>? stars,
    String? pricing,
  }) async {
    setState(() => _isLoading = true);
    try {
      final result = await ServiceProvider().searchFilterApi(
        search: locationController.text.trim(),
        startDate: checkInDate != null ? _formatDateForApi(checkInDate!) : null ?? "",
        endDate: checkOutDate != null ? _formatDateForApi(checkOutDate!) : null ?? "",
        starRatings: stars,
        amenities: features,
        rules: rules,
        pricing: pricing,
      );

      if (result.data?.isNotEmpty == true) {
        filteredHotels = result.data!.map((d) => Data.fromDatam(d)).toList();
        searchHotelModel.data = filteredHotels;
        await _translateHotels();
      } else {
        filteredHotels = [];
      }

      if (mounted) setState(() {});
      if (Get.isBottomSheetOpen == true) Get.back();
    } catch (e) {
      debugPrint('Filter search error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> searchHotelWithSorting({String? sorting}) async {
    setState(() => _isLoading = true);
    try {
      final result = await ServiceProvider().searchSortingApi(
        search: locationController.text.trim(),
        startDate: checkInDate != null ? _formatDateForApi(checkInDate!) : null ?? "",
        endDate: checkOutDate != null ? _formatDateForApi(checkOutDate!) : null ?? "",
        sort: sorting ?? "",
      );

      if (result.data?.isNotEmpty == true) {
        filteredHotels = result.data!.map((d) => Data.fromDatams(d)).toList();
        searchHotelModel.data = filteredHotels;
        await _translateHotels();
      } else {
        filteredHotels = [];
      }

      if (mounted) setState(() {});
      if (Get.isBottomSheetOpen == true) Get.back();
    } catch (e) {
      debugPrint('Sort search error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(int id) async {
    setState(() {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
      } else {
        favoriteIds.add(id);
      }
    });

    try {
      if (favoriteIds.contains(id)) {
        await ServiceProvider().selectFavProperty(propertyId: id);
      } else {
        await ServiceProvider().removeFavProperty(propertyId: id);
      }
    } catch (e) {
      debugPrint("Favorite error: $e");
      setState(() {
        if (favoriteIds.contains(id)) {
          favoriteIds.remove(id);
        } else {
          favoriteIds.add(id);
        }
      });
    }
  }

  void _showSnackBar(String title, String message) {
    Get.snackbar(title, message);
  }

  void _navigateToHotelDetail(Data hotel) {
    LocalStorages().saveCheckIn(checkIn: model.searchParams?.startDate ?? "");
    LocalStorages().saveCheckOut(checkOut: model.searchParams?.endDate ?? "");
    Get.to(() => HotelDetailsScreen(
      id: hotel.id ?? 0,
      fac: hotel.translatedDescription ?? "",
    ));
  }

  String formatTime(String time) {
    try {
      return DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(time));
    } catch (_) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isEditable == false && isSearch == true) _buildSearchBar(),
            if (isEditable == true) _buildDatePickerFields(),
            const SizedBox(height: 20),
            _buildHotelList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSortButton(),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('|')),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return InkWell(
      onTap: filterSortHotels,
      child: Row(
        children: [
          const Icon(Icons.sort, color: Colors.white),
          const SizedBox(width: 4),
          Text('Sort', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: filterFetchHotels,
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Colors.white),
          const SizedBox(width: 4),
          Text('Filter', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return getAppBar(
      context,
      model.searchParams?.search ?? "",
      centerTitle: false,
      isSubtext: true,
      subtextWidget: GestureDetector(
        onTap: () => Get.off(HotelHomeSearchScreen()),
        child: _buildDateCard(
          Icons.calendar_today,
          "${_formatShortDate(model.searchParams?.startDate)} - ${_formatShortDate(model.searchParams?.endDate)}",
        ),
      ),
      trailing: [
        GestureDetector(
          onTap: () => setState(() => isSearch = !isSearch),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image(image: AssetImage(AssetsScreen.searchIconOrange), width: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildLocationField(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDateTextField(checkInController, "Check-In", true)),
              const SizedBox(width: 16),
              Expanded(child: _buildDateTextField(checkOutController, "Check-Out", false)),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(
            title: "Update Search",
            onTap: () async {
              if (locationController.text.trim().isEmpty) {
                _showSnackBar("Error", "Please enter a location");
                return;
              }
              if (checkInDate == null || checkOutDate == null) {
                _showSnackBar("Error", "Please select both dates");
                return;
              }
              await searchHotel();
              setState(() => isEditable = false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateTextField(TextEditingController controller, String label, bool isCheckIn) {
    return GestureDetector(
      onTap: () => _selectDate(context, isCheckIn: isCheckIn),
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
                  Text(label, style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w500)),
                  Text(
                    controller.text.isEmpty ? "Select date" : controller.text,
                    style: TextStyle(fontSize: 12, color: controller.text.isEmpty ? Colors.grey : Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: "Search hotels...",
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: Colors.orange),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildHotelList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredHotels.isEmpty) {
      return const Center(child: Text("No hotels found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredHotels.length,
      itemBuilder: (context, index) {
        final hotel = filteredHotels[index];
        return HotelCard(
          data: hotel,
          isFavorite: favoriteIds.contains(hotel.id ?? 0),
          onTap: () => _navigateToHotelDetail(hotel),
          onFavoriteToggle: () => _toggleFavorite(hotel.id ?? 0),
        );
      },
    );
  }

  Widget _buildHotelCard(Data data) {
    final isFavorite = favoriteIds.contains(data.id ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 1, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHotelImage(data.images, data.id ?? 0, isFavorite),
          _buildHotelDetails(data),
        ],
      ),
    );
  }

  Widget _buildHotelImage(List<String>? images, int hotelId, bool isFavorite) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(controller: _pageController, itemCount: images?.length, itemBuilder: (context, index) {
              return getImage(height: 200, width: double.infinity, url: images?[index]);
            },),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withValues(alpha: 0.3), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => _toggleFavorite(hotelId),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelDetails(Data data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.name ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                  const SizedBox(width: 4),
                  Text("${data.starRating?.toString() ?? "0"}/5", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(child: Text("${data.city ?? ""}, ${data.country ?? ""}", style: const TextStyle(fontSize: 13, color: Colors.grey))),
            ],
          ),
          const SizedBox(height: 10),
          Text("Check-In: ${formatTime(data.checkInTime?.toString() ?? "")} | Check-out: ${formatTime(data.checkOutTime?.toString() ?? "")}"),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("${data.currency ?? ""}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(" ${data.pricePerNight ?? ""} /Night", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
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
          const Text("Area, Landmark", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 12)),
          TextField(
            controller: locationController,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w400)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => setState(() => isEditable = !isEditable),
            child: Text("Edit", style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _openFilterBottomSheet() {
    bool showAllFeatures = false;
    bool showAllRules = false;
    bool showAllStars = false;
    bool showAllPrices = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        List<String> tempSelectedFeatures = [];
        List<String> tempSelectedRules = [];
        List<String> tempSelectedStars = [];
        String? tempSelectedPrice;

        return StatefulBuilder(
          builder: (context, localSetState) {
            final allFeatures = filterModel.allFeatures ?? [];
            final allRules = filterModel.allRules ?? [];
            final starRatings = (filterModel.starRating?.toJson().keys.where((e) => e.isNotEmpty) ?? []).toList();
            final pricingRanges = (filterModel.pricing?.toJson().keys.where((e) => e.isNotEmpty) ?? []).toList();

            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDragHandle(),
                    _buildFilterHeader(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFilterSection(
                              title: "Hotel Features",
                              options: allFeatures,
                              selectedValues: tempSelectedFeatures,
                              isMultiSelect: true,
                              showAll: showAllFeatures,
                              onToggle: () => localSetState(() => showAllFeatures = !showAllFeatures),
                              onSelected: (v) => localSetState(() {
                                if (tempSelectedFeatures.contains(v)) {
                                  tempSelectedFeatures.remove(v);
                                } else {
                                  tempSelectedFeatures.add(v);
                                }
                              }),
                            ),
                            _buildFilterSection(
                              title: "Hotel Rules",
                              options: allRules,
                              selectedValues: tempSelectedRules,
                              isMultiSelect: true,
                              showAll: showAllRules,
                              onToggle: () => localSetState(() => showAllRules = !showAllRules),
                              onSelected: (v) => localSetState(() {
                                if (tempSelectedRules.contains(v)) {
                                  tempSelectedRules.remove(v);
                                } else {
                                  tempSelectedRules.add(v);
                                }
                              }),
                            ),
                            _buildFilterSection(
                              title: "Hotel Star Rating",
                              options: starRatings,
                              selectedValues: tempSelectedStars,
                              isMultiSelect: true,
                              showAll: showAllStars,
                              onToggle: () => localSetState(() => showAllStars = !showAllStars),
                              onSelected: (v) => localSetState(() {
                                if (tempSelectedStars.contains(v)) {
                                  tempSelectedStars.remove(v);
                                } else {
                                  tempSelectedStars.add(v);
                                }
                              }),
                            ),
                            _buildFilterSection(
                              title: "Hotel Price Range",
                              options: pricingRanges,
                              selectedValues: null,
                              selectedValue: tempSelectedPrice,
                              isMultiSelect: false,
                              showAll: showAllPrices,
                              onToggle: () => localSetState(() => showAllPrices = !showAllPrices),
                              onSelected: (v) => localSetState(() => tempSelectedPrice = v),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildApplyButton(() async {
                      Navigator.pop(context);
                      await searchHotelWithFilters(
                        features: tempSelectedFeatures,
                        rules: tempSelectedRules,
                        stars: tempSelectedStars.map((e) => int.tryParse(e.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0).toList(),
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

  Widget _buildDragHandle() {
    return Container(
      width: 50,
      height: 5,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildFilterHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text('Clear', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
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
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            child: Text(showAll ? 'View less' : 'View all (${options.length})', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500)),
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
        child: const Text('Show Properties', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  void _openFilterSortSheet() {
    if (filterModel.sorting == null) return;

    final sortingOptions = filterModel.sorting!.toJson();
    String tempSelectedSort = selectedSort;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDragHandle(),
                  _buildSortHeader(),
                  const SizedBox(height: 16),
                  ...sortingOptions.entries.map((entry) => RadioListTile<String>(
                    value: entry.value,
                    groupValue: tempSelectedSort,
                    onChanged: (val) => setModalState(() => tempSelectedSort = val!),
                    title: Text(entry.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    activeColor: Colors.orange,
                    contentPadding: EdgeInsets.zero,
                  )),
                  const SizedBox(height: 24),
                  _buildApplyButton(() async {
                    Navigator.pop(context);
                    setState(() => selectedSort = tempSelectedSort);
                    await searchHotelWithSorting(sorting: selectedSort);
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

  Widget _buildSortHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        const SizedBox(width: 10),
        const Text('Sort by', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class HotelTranslator {
  static Future<void> translateHotels(List<Data> hotels, String langCode) async {
    final translator = TranslationService();
    for (var hotel in hotels) {
      hotel.translatedName = await translator.translateText(hotel.name ?? "", langCode);
      hotel.translatedCityCountry = await translator.translateText("${hotel.city ?? ""}, ${hotel.country ?? ""}", langCode);
      hotel.translatedDescription = await translator.translateText(hotel.description ?? "", langCode);
      hotel.translatedAddress = await translator.translateText(hotel.address ?? "", langCode);
    }
  }
}

class HotelCard extends StatefulWidget {
  final Data data;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const HotelCard({
    super.key,
    required this.data,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String formatTime(String time) {
    try {
      return DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(time));
    } catch (_) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: widget.onTap,
      child: Container(
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
            _buildHotelImage(),
            _buildHotelDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelImage() {
    final images = widget.data.images ?? [];
    print("SHASHA Images count: ${images.length}");

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            child: images.isEmpty
                ? getImage(height: 200, width: double.infinity, url: null)
                : PageView.builder(
              controller: _pageController,
              physics: const PageScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return getImage(
                  height: 200,
                  width: double.infinity,
                  url: images[index],
                );
              },
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.3),
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
              onTap: widget.onFavoriteToggle,
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.isFavorite ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelDetails() {
    final data = widget.data;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.name ?? "",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                  const SizedBox(width: 4),
                  Text(
                    "${data.starRating?.toString() ?? "0"}/5",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                  "${data.city ?? ""}, ${data.country ?? ""}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
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
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                " ${data.pricePerNight ?? ""} /Night",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}