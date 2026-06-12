import 'package:elior/app_values/app_theme.dart';
import 'package:elior/hotel_booking/room_available_screen.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../network/service_provider.dart';
import '../response_model/hotel_detail_response.dart';
import '../utils/translator_service.dart';

class HotelDetailsScreen extends StatefulWidget {
  final int id;
  final String fac;

  const HotelDetailsScreen({super.key, required this.id, required this.fac});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  HotelDetailModel? hotelDetailModel;
  bool isLoading = true;
  bool isDescriptionExpanded = false;
  bool isFacilitiesExpanded = false;
  bool isRulesExpanded = false;

  Future<void> fetchHotels(int id) async {
    try {
      final result = await ServiceProvider().detailHotelApi(id);
      setState(() {
        hotelDetailModel = result;
        isLoading = false;
      });
      // 🔹 Translate lazily after UI renders
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        String langCode = Get.locale?.languageCode ?? "en";
        await HotelTranslator.translateHotels(result.data!, langCode);
        setState(() {}); // refresh only translated fields
      });
    } catch (e) {
      debugPrint('Hotel detail error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHotels(widget.id);
    });
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
    // ✅ After loading, check if data exists
    final hotel = hotelDetailModel?.data?.isNotEmpty == true
        ? hotelDetailModel!.data!.first
        : null;

    // ✅ Show “not found” only after loading
    if (hotel == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F8FF),
        body: Center(child: Text("Hotel details not found".tr)),
      );
    }

    // ✅ Otherwise, render hotel details UI
    return buildHotelDetailUI(hotel);
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

  String formatTime(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsed);
    } catch (e) {
      return time;
    }
  }

  Widget buildHotelDetailUI(Datas hotel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(
        context,
        hotel.translatedName ?? hotel.name ?? "",
        isSubtext: true,
        subtext:
            "${formatDate(LocalStorages().getCheckIn())} -${formatDate(LocalStorages().getCheckOut())} ",
        centerTitle: false,
        trailing: [
          GestureDetector(
            onTap: () => shareProperty(
              hotel.translatedName ?? hotel.name ?? "",
              hotel.city ?? "",
              hotel.website ?? "",
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
            _showDateSelectionBottomSheet(context, hotel);
          },
        ),
      ),
      body: ListView(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: Image.network(
              hotel.images?.isNotEmpty == true
                  ? hotel.images!.first
                  : 'https://via.placeholder.com/400x220',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Hotel Name
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hotel.translatedName ?? hotel.name ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        // Show filled stars for rating, else border stars
                        return Icon(
                          index < (hotel.starRating ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ✅ Address
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${hotel.city}, ${hotel.state}, ${hotel.country} - ${hotel.zipcode}\n${hotel.address}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(width: 6),
                      Text(
                        "Check-In: ${formatTime(hotel.checkInTime.toString())} | Check-out: ${formatTime(hotel.checkOutTime.toString())} ",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ✅ Description
                const Text(
                  'About the Property',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  hotel.translatedDescription ??
                      hotel.description ??
                      "No description available",
                  maxLines: isDescriptionExpanded ? null : 2,
                  // 2 lines when collapsed
                  overflow: isDescriptionExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black87, height: 1.4),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDescriptionExpanded = !isDescriptionExpanded; // toggle
                    });
                  },
                  child: Text(
                    isDescriptionExpanded ? "View Less" : "View More Details",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // // ✅ Contact Info
                // Text(
                //   'ContactInfo'.tr,
                //   style: const TextStyle(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 12),
                // Row(
                //   children: [
                //     const CircleAvatar(
                //       radius: 24,
                //       backgroundColor: Color(0xFFE3E9F9),
                //       child: Icon(Icons.phone, color: Colors.orange),
                //     ),
                //     const SizedBox(width: 12),
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             hotel.phone ?? "N/A",
                //             style: const TextStyle(fontWeight: FontWeight.bold),
                //           ),
                //           Text(
                //             hotel.email ?? "N/A",
                //             style: const TextStyle(
                //               fontSize: 12,
                //               color: Colors.grey,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20),

                // ✅ Facilities
                if (hotel.facilities != null &&
                    hotel.facilities!.isNotEmpty) ...[
                  Text(
                    "Facilities".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  ListView.separated(
                    separatorBuilder: (_, _) => const SizedBox(height: 4,),
                    shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: isFacilitiesExpanded
                          ? hotel.facilities!.length
                          : (hotel.facilities!.length > 4
                          ? 4
                          : hotel.facilities!.length),
                      itemBuilder: (context, index) {
                    final facility = hotel.facilities![index];
                    return Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                        const SizedBox(width: 8,),
                        Text(
                          facility,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),

                  if (hotel.facilities!.length > 4)
                    GestureDetector(
                      onTap: () {
                        _showFacilitiesBottomSheet(context, hotel.facilities!);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],

                const SizedBox(height: 20),
                if (hotel.rules != null && hotel.rules!.isNotEmpty) ...[
                  Text(
                    "Property Rules & Information".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                      separatorBuilder: (_, _) => const SizedBox(height: 4,),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: isRulesExpanded
                          ? hotel.rules!.length
                          : (hotel.rules!.length > 4
                          ? 4
                          : hotel.rules!.length),
                      itemBuilder: (context, index) {
                        final rule = hotel.rules![index];
                        return Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                            const SizedBox(width: 8,),
                            Text(
                              rule,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }),
                  if (hotel.rules!.length > 4)
                    GestureDetector(
                      onTap: () {
                        _showRulesBottomSheet(context, hotel.rules!);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
                // ✅ Reviews Section
                if (hotel.ratingReviews != null &&
                    hotel.ratingReviews!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Reviews".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: hotel.ratingReviews!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final review = hotel.ratingReviews![index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xff010101).withValues(alpha: 0.1),
                          ),
                          boxShadow: [BoxShadow(color: AppTheme.black.withValues(alpha: 0.1), offset: const Offset(1, 2), blurRadius: 90, spreadRadius: 4)],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Reviewer name and rating
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      review.name ?? "Anonymous",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < (review.rating ?? 0)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Review title
                              if (review.title != null)
                                Text(
                                  review.title!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              // Review text
                              const SizedBox(height: 4),
                              Text(
                                review.review ?? "",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Created date
                              if (review.createdAt != null)
                                Text(
                                  DateFormat(
                                    "d MMM yyyy",
                                  ).format(DateTime.parse(review.createdAt!)),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],

                SizedBox(height: 15),
                // ✅ Gallery
                Text(
                  'Gallery'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: hotel.images?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          final images = hotel.images!
                              .map((img) => Image.network(img).image)
                              .toList();

                          // MultiImageProvider multiImageProvider =
                          //     MultiImageProvider(images, initialIndex: index);
                          //
                          // showImageViewerPager(
                          //   context,
                          //   multiImageProvider,
                          //   swipeDismissible: true,
                          //   doubleTapZoomable: true,
                          // );
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              hotel.images![index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRulesBottomSheet(BuildContext context, List<String> rules) {
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
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "- $rule",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
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
              const Text(
                "All facilities",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "- $facility",
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

  String formatDateDisplay(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }

  void _showDateSelectionBottomSheet(BuildContext context, Datas hotel) {
    DateTime checkIn = DateTime.tryParse(LocalStorages().getCheckIn() ?? "") ?? DateTime.now();
    DateTime checkOut = DateTime.tryParse(LocalStorages().getCheckOut() ?? "") ?? DateTime.now().add(const Duration(days: 1));

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
                  const Text(
                    "Select Check-In & Check-Out Dates",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.black.withValues(alpha: 0.05),
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.orange, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Check-In", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                Text(formatDateDisplay(checkIn), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.black.withValues(alpha: 0.05),
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.orange, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Check-Out", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                Text(formatDateDisplay(checkOut), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: AppTheme.black.withValues(alpha: 0.5),),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Button
                  AppButton(title: "Confirm & Select Rooms", onTap: () {
                    LocalStorages().saveCheckIn(
                      checkIn: DateFormat("yyyy-MM-dd").format(checkIn),
                    );
                    LocalStorages().saveCheckOut(
                      checkOut: DateFormat("yyyy-MM-dd").format(checkOut),
                    );

                    LocalStorages().savehotelName(
                      hotelName: hotel.translatedName ?? "",
                    );
                    LocalStorages().savehotelAddress(
                      hotelAddress: hotel.translatedAddress ?? "",
                    );

                    Navigator.pop(context);

                    Get.to(
                      RoomListScreen(
                        id: hotel.id ?? 0,
                        checkIn: DateFormat("yyyy-MM-dd").format(checkIn),
                        checkOut: DateFormat("yyyy-MM-dd").format(checkOut),
                        hotelName: hotel.translatedName ?? hotel.name ?? "",
                      ),
                    );
                  },),
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
