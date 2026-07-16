import 'dart:async';

import 'package:elior/response_model/fav_model/add_fav_moodel.dart';
import 'package:elior/response_model/filter_model.dart';
import 'package:elior/response_model/property/property_search_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show
    BuildContext,
    TextEditingController,
    DatePickerEntryMode,
    showDatePicker;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../hotel_booking/hotel_detail.dart';
import '../network/service_provider.dart';
import '../response_model/search_filter_model.dart';
import '../response_model/search_sorting_model.dart';
import '../utils/storage.dart';
import '../utils/translator_service.dart';

/// Pure formatting helpers shared by the controller and the screen.
/// No Flutter widgets here - only String/DateTime logic.
class HotelDateFormatters {
  const HotelDateFormatters._();

  static String forDisplay(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);

  static String forApi(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  static String apiOrEmpty(DateTime? date) =>
      date != null ? forApi(date) : "";

  static String shortDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'DD/MM';
    try {
      return DateFormat(
        "d MMM",
      ).format(DateFormat("yyyy-MM-dd").parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  static String time(String time) {
    try {
      return DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(time));
    } catch (_) {
      return time;
    }
  }
}

/// Translates hotel fields in place. Kept separate from the controller
/// because it operates purely on data.
class HotelTranslator {
  const HotelTranslator._();

  static Future<void> translateHotels(
      List<Property> hotels,
      String langCode,
      ) async {
    final translator = TranslationService();
    for (final hotel in hotels) {
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

class HotelHomeResultController extends GetxController {
  late final PropertySearchResponse model;
  String? slug;

  // Text controllers - not widgets, safe to own here so their lifecycle
  // (and the logic that mutates them) lives with the rest of the state.
  final TextEditingController searchController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  final RxList<Property> filteredHotels = <Property>[].obs;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  final RxBool isLoading = false.obs;
  final RxBool isEditable = false.obs;
  final RxBool isSearch = false.obs;
  final RxString selectedSort = 'Price: Low to High'.obs;
  final RxSet<int> favoriteIds = <int>{}.obs;

  PropertySearchResponse searchHotelModel = PropertySearchResponse();
  FilterModel filterModel = FilterModel();
  SelectFaModel selectFaModel = SelectFaModel();
  SearchFilterModel searchFilterModel = SearchFilterModel();
  SearchSotingModel searchSotingModel = SearchSotingModel();

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    model = args["model"];
    slug = args["slug"];

    locationController.text = model.searchParams?.search ?? "";
    _initializeDates();
    filteredHotels.value = model.data ?? [];
    _initializeFavoritesFromResponse();
    _translateHotels();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    locationController.dispose();
    checkInController.dispose();
    checkOutController.dispose();
    super.onClose();
  }

  void _initializeDates() {
    checkInDate = _parseDate(model.searchParams?.startDate) ?? DateTime.now();
    checkOutDate =
        _parseDate(model.searchParams?.endDate) ??
            DateTime.now().add(const Duration(days: 1));

    if (checkInDate != null) {
      checkInController.text = HotelDateFormatters.forDisplay(checkInDate!);
    }
    if (checkOutDate != null) {
      checkOutController.text = HotelDateFormatters.forDisplay(checkOutDate!);
    }
  }

  DateTime? _parseDate(String? dateStr) =>
      dateStr != null ? DateTime.tryParse(dateStr) : null;

  Future<void> _translateHotels() async {
    if (filteredHotels.isEmpty) return;
    final langCode = Get.locale?.languageCode ?? "en";
    await HotelTranslator.translateHotels(filteredHotels, langCode);
    filteredHotels.refresh();
  }

  // ---------------------------------------------------------------------
  // Search (top bar location/date search)
  // ---------------------------------------------------------------------

  Future<void> searchHotel() => _executeSearch(
    updateModelData: true,
    fetch: () async {
      final result = await ServiceProvider().searchHotelApi(
        search: locationController.text.trim(),
        startDate: HotelDateFormatters.apiOrEmpty(checkInDate ?? DateTime.now()),
        endDate: HotelDateFormatters.apiOrEmpty(checkOutDate ?? DateTime.now()),
      );
      return result.status == true ? result.data : null;
    },
  );

  Future<void> submitDateSearch() async {
    await searchHotel();
    isEditable.value = false;
  }

  /// Returns a validation error key, or null if the search can proceed.
  String? validateDateSearch() {
    if (locationController.text.trim().isEmpty) return "please_enter_location";
    if (checkInDate == null || checkOutDate == null) {
      return "select_both_dates";
    }
    return null;
  }

  // ---------------------------------------------------------------------
  // In-list quick filter (the small search bar under the app bar)
  // ---------------------------------------------------------------------

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _filterHotels(query));
  }

  void _filterHotels(String query) {
    final sourceList = searchHotelModel.data?.isNotEmpty == true
        ? searchHotelModel.data!
        : model.data ?? [];

    if (query.isEmpty) {
      filteredHotels.value = sourceList;
      return;
    }

    final q = query.toLowerCase();
    filteredHotels.value = sourceList.where((hotel) {
      return hotel.city?.toLowerCase().contains(q) == true ||
          hotel.country?.toLowerCase().contains(q) == true ||
          hotel.name?.toLowerCase().contains(q) == true;
    }).toList();
  }

  // ---------------------------------------------------------------------
  // Date picking
  // ---------------------------------------------------------------------

  /// Returns an error key to show, or null on success. Uses [context] only
  /// to invoke the platform date-picker dialog - it builds no custom UI.
  Future<String?> selectDate(
      BuildContext context, {
        required bool isCheckIn,
      }) async {
    if (!isCheckIn && checkInDate == null) {
      return "select_check_in_first";
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

    if (picked == null) return null;

    if (!isCheckIn && picked.isBefore(checkInDate!)) {
      return "checkout_must_be_after";
    }

    if (isCheckIn) {
      checkInDate = picked;
      checkInController.text = HotelDateFormatters.forDisplay(picked);
      if (checkOutDate?.isBefore(picked) == true) {
        checkOutDate = null;
        checkOutController.clear();
      }
    } else {
      checkOutDate = picked;
      checkOutController.text = HotelDateFormatters.forDisplay(picked);
    }
    return null;
  }

  // ---------------------------------------------------------------------
  // Filters
  // ---------------------------------------------------------------------

  Future<FilterModel> _fetchFilterModel() {
    return slug == "hotel"
        ? ServiceProvider().filterHotelApi()
        : ServiceProvider().filterHomeStayApi();
  }

  /// Loads [filterModel] and reports whether it's usable for the filter sheet.
  Future<bool> loadFilters() async {
    isLoading.value = true;
    try {
      filterModel = await _fetchFilterModel();
      return filterModel.status == true;
    } catch (e) {
      debugPrint('Filter error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads [filterModel] and reports whether it's usable for the sort sheet.
  Future<bool> loadSortOptions() async {
    isLoading.value = true;
    try {
      filterModel = await _fetchFilterModel();
      return filterModel.status == true && filterModel.sorting != null;
    } catch (e) {
      debugPrint('Sort error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchHotelWithFilters({
    List<String>? features,
    List<String>? rules,
    List<int>? stars,
    String? pricing,
  }) => _executeSearch(
    closeBottomSheet: true,
    fetch: () async {
      final result = await ServiceProvider().searchFilterApi(
        search: locationController.text.trim(),
        startDate: HotelDateFormatters.apiOrEmpty(checkInDate),
        endDate: HotelDateFormatters.apiOrEmpty(checkOutDate),
        starRatings: stars,
        amenities: features,
        rules: rules,
        pricing: pricing,
      );
      return result.data?.map((d) => Property.fromDatam(d)).toList();
    },
  );

  List<int> starLabelsToValues(List<String> labels) => labels
      .map((e) => int.tryParse(e.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
      .toList();

  // ---------------------------------------------------------------------
  // Sorting
  // ---------------------------------------------------------------------

  Future<void> searchHotelWithSorting({String? sorting}) async {
    selectedSort.value = sorting ?? selectedSort.value;
    await _executeSearch(
      closeBottomSheet: true,
      fetch: () async {
        late SearchSotingModel result;
        if (slug == "hotel") {
          result = await ServiceProvider().searchSortingApi(
            search: locationController.text.trim(),
            startDate: HotelDateFormatters.apiOrEmpty(checkInDate),
            endDate: HotelDateFormatters.apiOrEmpty(checkOutDate),
            sort: sorting ?? "",
          );
        } else {
          result = await ServiceProvider().searchSortingHomeApi(
            search: locationController.text.trim(),
            startDate: HotelDateFormatters.apiOrEmpty(checkInDate),
            endDate: HotelDateFormatters.apiOrEmpty(checkOutDate),
            sort: sorting ?? "",
          );
        }
        return result.data?.map((d) => Property.fromDataSort(d)).toList();
      },
    );
  }

  // ---------------------------------------------------------------------
  // Shared search execution (DRY helper for the 3 API-backed searches)
  // ---------------------------------------------------------------------

  Future<void> _executeSearch({
    required Future<List<Property>?> Function() fetch,
    bool updateModelData = false,
    bool closeBottomSheet = false,
  }) async {
    isLoading.value = true;
    try {
      final result = await fetch();
      if (result != null && result.isNotEmpty) {
        filteredHotels.value = result;
        searchHotelModel.data = result;
        if (updateModelData) model.data = result;
        _updateFavoritesFromData(result);
        await _translateHotels();
      } else {
        filteredHotels.value = [];
      }
      if (closeBottomSheet && Get.isBottomSheetOpen == true) Get.back();
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------
  // Favorites
  // ---------------------------------------------------------------------

  void _initializeFavoritesFromResponse() {
    favoriteIds.value = model.data
        ?.where((property) => property.isFavourite == 1)
        .map((property) => property.id ?? 0)
        .toSet() ??
        {};
  }

  void _updateFavoritesFromData(List<Property> properties) {
    favoriteIds.value = properties
        .where((property) => property.isFavourite == 1)
        .map((property) => property.id ?? 0)
        .toSet();
  }

  Future<void> toggleFavorite(int id) async {
    final index = filteredHotels.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final property = filteredHotels[index];
    final wasFavorite = property.isFavourite == 1;

    // Optimistic update.
    property.isFavourite = wasFavorite ? 0 : 1;
    wasFavorite ? favoriteIds.remove(id) : favoriteIds.add(id);
    filteredHotels.refresh();

    try {
      if (!wasFavorite) {
        await ServiceProvider().selectFavProperty(propertyId: id);
      } else {
        await ServiceProvider().removeFavProperty(propertyId: id);
      }
    } catch (e) {
      // Revert on error.
      property.isFavourite = wasFavorite ? 1 : 0;
      wasFavorite ? favoriteIds.add(id) : favoriteIds.remove(id);
      filteredHotels.refresh();
      debugPrint("Favorite error: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------

  void navigateToHotelDetail(Property hotel) {
    LocalStorages().saveCheckIn(checkIn: model.searchParams?.startDate ?? "");
    LocalStorages().saveCheckOut(checkOut: model.searchParams?.endDate ?? "");
    Get.to(
          () => UnifiedPropertyDetailsScreen(
        id: hotel.id ?? 0,
        fac: hotel.translatedDescription ?? "",
        slug: slug ?? "hotel",
      ),
    );
  }

  // ---------------------------------------------------------------------
  // UI toggles (state flags only - the widgets that read them live in the
  // screen)
  // ---------------------------------------------------------------------

  void toggleEditable() => isEditable.value = !isEditable.value;

  void setEditable() => isEditable.value = !isEditable.value;

  void toggleSearchBar() => isSearch.value = !isSearch.value;
}