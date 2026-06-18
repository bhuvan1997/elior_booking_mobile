import 'package:elior/app_values/app_theme.dart';
import 'package:elior/hotel_booking/room_available_screen.dart';
import 'package:elior/home_stay/home_stay_room_list_screen.dart';
import 'package:elior/response_model/unified_detail_model.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../network/service_provider.dart';
import '../response_model/hotel_detail_response.dart';
import '../response_model/home_stay_respnse/homestay_detail_model.dart';
import '../utils/translator_service.dart';

class UnifiedPropertyDetailsScreen extends StatefulWidget {
  final int id;
  final String fac;
  final String slug;

  const UnifiedPropertyDetailsScreen({
    super.key,
    required this.id,
    required this.fac,
    required this.slug,
  });

  @override
  State<UnifiedPropertyDetailsScreen> createState() =>
      _UnifiedPropertyDetailsScreenState();
}

class _UnifiedPropertyDetailsScreenState
    extends State<UnifiedPropertyDetailsScreen> {
  // Hotel data
  HotelDetailModel? hotelDetailModel;

  // Homestay data
  HomeStayDetailModel? homestayDetailModel;

  UnifiedDetailModel? hotelHomeDetail;

  bool isLoading = true;
  bool isDescriptionExpanded = false;
  bool isFacilitiesExpanded = false;
  bool isRulesExpanded = false;

  // Shared data holders
  String? propertyName;
  String? propertyDescription;
  String? propertyCity;
  String? propertyState;
  String? propertyCountry;
  String? propertyZipcode;
  String? propertyAddress;
  String? propertyCheckInTime;
  String? propertyCheckOutTime;
  String? propertyCurrency;
  int? propertyPricePerNight;
  int? propertyStarRating;
  List<String>? propertyFacilities;
  List<String>? propertyRules;
  List<String>? propertyImages;
  String? propertyPhone;
  String? propertyEmail;
  String? propertyWebsite;
  int? propertyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPropertyDetails(widget.id);
    });
  }

  Future<void> fetchPropertyDetails(int id) async {
    setState(() => isLoading = true);
    try {
      if (widget.slug == "hotel") {
        final result = await ServiceProvider().detailHotelApi(id);
        setState(() {
          hotelDetailModel = result;
          isLoading = false;
          _mapHotelData(result);
        });
        // Translate hotel data
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          String langCode = Get.locale?.languageCode ?? "en";
          await HotelTranslator.translateHotels(result.data!, langCode);
          setState(() {});
        });
      } else {
        final result = await ServiceProvider().detailHomeStayApi(id);
        setState(() {
          hotelHomeDetail = result;
          isLoading = false;
          _mapHomestayData(result);
        });
        // Translate homestay data
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          String langCode = Get.locale?.languageCode ?? "en";
          await HomestayTranslator.translateHomestays(result.data!, langCode);
          if (mounted) setState(() {});
        });
      }
    } catch (e) {
      debugPrint('Property detail error: $e');
      setState(() => isLoading = false);
    }
  }

  void _mapHotelData(HotelDetailModel model) {
    if (model.data?.isNotEmpty == true) {
      final hotel = model.data!.first;
      propertyName = hotel.translatedName ?? hotel.name;
      propertyDescription = hotel.translatedDescription ?? hotel.description;
      propertyCity = hotel.city;
      propertyState = hotel.state;
      propertyCountry = hotel.country;
      propertyZipcode = hotel.zipcode;
      propertyAddress = hotel.translatedAddress ?? hotel.address;
      propertyCheckInTime = hotel.checkInTime;
      propertyCheckOutTime = hotel.checkOutTime;
      propertyCurrency = hotel.currency;
      propertyPricePerNight = hotel.pricePerNight;
      propertyStarRating = hotel.starRating;
      propertyFacilities = hotel.facilities;
      propertyRules = hotel.rules;
      propertyImages = hotel.images;
      propertyPhone = hotel.phone;
      propertyEmail = hotel.email;
      propertyWebsite = hotel.website;
      propertyId = hotel.id;
    }
  }

  void _mapHomestayData(UnifiedDetailModel model) {
    if (model.data?.isNotEmpty == true) {
      final homestay = model.data!.first;
      propertyName = homestay.translatedName ?? homestay.name;
      propertyDescription =
          homestay.translatedDescription ?? homestay.description;
      propertyCity = homestay.city;
      propertyState = homestay.state;
      propertyCountry = homestay.country;
      propertyZipcode = homestay.zipcode;
      propertyAddress = homestay.translatedAddress ?? homestay.address;
      propertyCheckInTime = homestay.checkInTime;
      propertyCheckOutTime = homestay.checkOutTime;
      propertyCurrency = homestay.currency;
      propertyPricePerNight = homestay.pricePerNight;
      propertyStarRating = homestay.starRating;
      propertyFacilities = homestay.facilities;
      propertyRules = homestay.rules;
      propertyImages = homestay.images;
      propertyPhone = homestay.phone;
      propertyEmail = homestay.email;
      propertyWebsite = homestay.website;
      propertyId = homestay.id;
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'DD/MM';
    try {
      final parsedDate = DateFormat("yyyy-MM-dd").parse(dateStr);
      return DateFormat("d MMM").format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return 'N/A';
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsed);
    } catch (e) {
      return time;
    }
  }

  Color getThemeColor() {
    return AppTheme.appThemeColor;
  }

  void shareProperty(String name, String city, String link) {
    Share.share(
      "Check out this property on Elior Booking!\n\n"
      "🏨 $name\n📍 $city\n\n"
      "$link",
      subject: "Share Property",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (propertyName == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            "Property details not found".tr,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return buildPropertyDetailUI();
  }

  Widget buildPropertyDetailUI() {
    final themeColor = getThemeColor();
    final isHotel = widget.slug == "hotel";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(
        context,
        propertyName ?? "",
        isSubtext: true,
        subtext:
            "${formatDate(LocalStorages().getCheckIn())} - ${formatDate(LocalStorages().getCheckOut())}",
        centerTitle: false,
        trailing: [
          GestureDetector(
            onTap: () => shareProperty(
              propertyName ?? "",
              propertyCity ?? "",
              propertyWebsite ?? "",
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.share, color: AppTheme.black, size: 20),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppButton(
          title: "Select Rooms",
          onTap: () {
            _showDateSelectionBottomSheet(context);
          },
        ),
      ),
      body: ListView(
        children: [
          // Property Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: Image.network(
              propertyImages?.isNotEmpty == true
                  ? propertyImages!.first
                  : 'https://via.placeholder.com/400x220',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Name & Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        propertyName ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (propertyStarRating != null) ...[
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (propertyStarRating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // Address
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${propertyCity ?? ""}, ${propertyState ?? ""}, ${propertyCountry ?? ""}${propertyZipcode != null ? " - ${propertyZipcode}" : ""}\n${propertyAddress ?? ""}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Check-in/Check-out
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      "Check-In: ${formatTime(propertyCheckInTime)} | Check-out: ${formatTime(propertyCheckOutTime)}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Description
                const Text(
                  'About the Property',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  propertyDescription ?? "No description available",
                  maxLines: isDescriptionExpanded ? null : 2,
                  overflow: isDescriptionExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black87, height: 1.4),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDescriptionExpanded = !isDescriptionExpanded;
                    });
                  },
                  child: Text(
                    isDescriptionExpanded ? "View Less" : "View More",
                    style: GoogleFonts.poppins(
                      color: themeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Price
                if (propertyPricePerNight != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: themeColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Price per Night",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${propertyCurrency ?? ""} ${propertyPricePerNight ?? 0}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Contact Info
                if (propertyPhone != null || propertyEmail != null) ...[
                  Text(
                    'Contact Info'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: themeColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone_outlined, color: themeColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                propertyPhone ?? "N/A",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                propertyEmail ?? "N/A",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Facilities
                if (propertyFacilities != null &&
                    propertyFacilities!.isNotEmpty) ...[
                  Text(
                    "Facilities".tr,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: isFacilitiesExpanded
                        ? propertyFacilities!.length
                        : (propertyFacilities!.length > 4
                              ? 4
                              : propertyFacilities!.length),
                    itemBuilder: (context, index) {
                      final facility = propertyFacilities![index];
                      return Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              facility,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (propertyFacilities!.length > 4)
                    GestureDetector(
                      onTap: () {
                        _showFacilitiesBottomSheet(
                          context,
                          propertyFacilities!,
                          themeColor,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "View All",
                          style: GoogleFonts.poppins(
                            color: themeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],

                // Rules
                if (propertyRules != null && propertyRules!.isNotEmpty) ...[
                  Text(
                    "Property Rules & Information".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: isRulesExpanded
                        ? propertyRules!.length
                        : (propertyRules!.length > 4
                              ? 4
                              : propertyRules!.length),
                    itemBuilder: (context, index) {
                      final rule = propertyRules![index];
                      return Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rule,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (propertyRules!.length > 4)
                    GestureDetector(
                      onTap: () {
                        _showRulesBottomSheet(
                          context,
                          propertyRules!,
                          themeColor,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          "View All",
                          style: GoogleFonts.poppins(
                            color: themeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],

                // Gallery
                if (propertyImages != null && propertyImages!.isNotEmpty) ...[
                  Text(
                    'Gallery'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: propertyImages!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              propertyImages![index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRulesBottomSheet(
    BuildContext context,
    List<String> rules,
    Color themeColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                "All Property Rules & Info",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rules.map((rule) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          "- $rule",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        );
      },
    );
  }

  void _showFacilitiesBottomSheet(
    BuildContext context,
    List<String> facilities,
    Color themeColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                "All Facilities",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: facilities.map((facility) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          "- $facility",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        );
      },
    );
  }

  String formatDateDisplay(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }

  void _showDateSelectionBottomSheet(BuildContext context) {
    DateTime checkIn =
        DateTime.tryParse(LocalStorages().getCheckIn() ?? "") ?? DateTime.now();
    DateTime checkOut =
        DateTime.tryParse(LocalStorages().getCheckOut() ?? "") ??
        DateTime.now().add(const Duration(days: 1));

    final themeColor = getThemeColor();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    "Select Check-In & Check-Out Dates",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Check-In
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: checkIn,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setSheetState(() {
                          checkIn = picked;
                          if (!checkOut.isAfter(checkIn)) {
                            checkOut = checkIn.add(const Duration(days: 1));
                          }
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.black.withOpacity(0.05),
                        border: Border.all(color: themeColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: themeColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Check-In",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  formatDateDisplay(checkIn),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppTheme.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Check-Out
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: checkOut,
                        firstDate: checkIn.add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setSheetState(() {
                          checkOut = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.black.withOpacity(0.05),
                        border: Border.all(color: themeColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: themeColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Check-Out",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  formatDateDisplay(checkOut),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppTheme.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Button
                  AppButton(
                    title: "Confirm & Select Rooms",
                    onTap: () {
                      LocalStorages().saveCheckIn(
                        checkIn: DateFormat("yyyy-MM-dd").format(checkIn),
                      );
                      LocalStorages().saveCheckOut(
                        checkOut: DateFormat("yyyy-MM-dd").format(checkOut),
                      );

                      LocalStorages().savehotelName(
                        hotelName: propertyName ?? "",
                      );
                      LocalStorages().savehotelAddress(
                        hotelAddress: propertyAddress ?? "",
                      );

                      Navigator.pop(context);

                      if (widget.slug == "hotel") {
                        Get.to(
                          RoomListScreen(
                            id: propertyId ?? 0,
                            checkIn: DateFormat("yyyy-MM-dd").format(checkIn),
                            checkOut: DateFormat("yyyy-MM-dd").format(checkOut),
                            hotelName: propertyName ?? "",
                          ),
                        );
                      } else {
                        Get.to(
                          HomeStayRoomListScreen(
                            id: propertyId ?? 0,
                            checkIn: DateFormat("yyyy-MM-dd").format(checkIn),
                            checkOut: DateFormat("yyyy-MM-dd").format(checkOut),
                            homeName: propertyName ?? "",
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Hotel Translator ────────────────────────────────────────────────────────

class HotelTranslator {
  static Future<void> translateHotels(
    List<Datas> hotels,
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

      if (hotel.facilities != null && hotel.facilities!.isNotEmpty) {
        List<String> translatedFacilities = [];
        for (var f in hotel.facilities!) {
          translatedFacilities.add(await translator.translateText(f, langCode));
        }
        hotel.translatedFacilities = translatedFacilities.join(", ");
      } else {
        hotel.translatedFacilities = "";
      }
    }
  }
}

// ─── Homestay Translator ────────────────────────────────────────────────────

class HomestayTranslator {
  static Future<void> translateHomestays(
    List<UnifiedData> homestays,
    String langCode,
  ) async {
    final translator = TranslationService();

    for (var homestay in homestays) {
      homestay.translatedName = await translator.translateText(
        homestay.name ?? "",
        langCode,
      );
      homestay.translatedCityCountry = await translator.translateText(
        "${homestay.city ?? ""}, ${homestay.country ?? ""}",
        langCode,
      );
      homestay.translatedDescription = await translator.translateText(
        homestay.description ?? "",
        langCode,
      );
      homestay.translatedAddress = await translator.translateText(
        homestay.address ?? "",
        langCode,
      );

      if (homestay.facilities != null && homestay.facilities!.isNotEmpty) {
        List<String> translatedFacilities = [];
        for (var f in homestay.facilities!) {
          translatedFacilities.add(await translator.translateText(f, langCode));
        }
        homestay.translatedFacilities = translatedFacilities.join(", ");
      } else {
        homestay.translatedFacilities = "";
      }
    }
  }
}
