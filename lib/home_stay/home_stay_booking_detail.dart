import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../network/service_provider.dart';
import '../response_model/home_stay_respnse/homestay_detail_model.dart';
import 'home_stay_room_list_screen.dart';

class HomeStayDetailsScreen extends StatefulWidget {
  final int id;
  final String fac;

  const HomeStayDetailsScreen({super.key, required this.id, required this.fac});

  @override
  State<HomeStayDetailsScreen> createState() => _HomeStayDetailsScreenState();
}

class _HomeStayDetailsScreenState extends State<HomeStayDetailsScreen> {
  final Color themeColor = const Color(0xFF388E3C);
  HomeStayDetailModel? hotelDetailModel;
  bool isDescriptionExpanded = false;
  bool isFacilitiesExpanded = false;
  bool isRulesExpanded = false;

  // bool isLoading = true;

  Future<void> fetchHomeAvailableApi(int id) async {
    try {
      final result = await ServiceProvider().detailHomeStayApi(id);

      setState(() {
        hotelDetailModel = result;
        // isLoading = false;
      });
    } catch (e) {
      debugPrint('Hotel detail error: $e');
      // setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHomeAvailableApi(widget.id);
    });
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

  @override
  Widget build(BuildContext context) {
    // ✅ Show loader while fetching
    // if (isLoading) {
    //   return const Scaffold(
    //     backgroundColor: Color(0xFFF5F8FF),
    //     body: Center(
    //       child: CircularProgressIndicator(color: Colors.green),
    //     ),
    //   );
    // }

    // ✅ After loading, check if data exists
    final hotelList = hotelDetailModel?.data;
    final hotel = hotelList != null && hotelList.isNotEmpty
        ? hotelList.first
        : null;

    if (hotel == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F8FF),
        body: Center(child: Text("No Data Found".tr)),
      );
    }

    // ✅ Render UI
    return buildHotelDetailUI(hotel);
  }
  void shareProperty(String name, String city, String link) {
    Share.share(
      "Check out this property on Elior Booking!\n\n"
          "🏨 $name\n📍 $city\n\n"
          "$link",
      subject: "Share Property",
    );
  }
  Widget buildHotelDetailUI(HomestayData hotel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.translatedName ?? hotel.name ?? "",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${formatDate(LocalStorages().getCheckIn())} - ${formatDate(LocalStorages().getCheckOut())}",
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
            GestureDetector(
                onTap: (){
                  shareProperty(
                    hotel.name ?? "",
                    hotel.city ?? "",
                    "https://eliorbooking.com/api/search-homestay-by-id?homestay_id=${hotel.id}",
                  );
                },
                child: const Icon(Icons.share_outlined)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
        ),
        child: ElevatedButton(
          onPressed: () {
            LocalStorages().savehotelName(hotelName: hotel.name ?? "");
            LocalStorages().savehotelAddress(hotelAddress: hotel.address ?? "");
            Get.to(() =>
              HomeStayRoomListScreen(
                id: widget.id,
                checkIn: LocalStorages().getCheckIn() ?? "",
                checkOut: LocalStorages().getCheckOut() ?? "",
                homeName: hotel.translatedName ?? hotel.name ?? "",
              ),
            );

            // Example navigation placeholder
            // Get.to(HomePayDetailsScreen(hotel: hotel));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Select Rooms',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: ListView(
        children: [
          // ✅ Hotel image
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
                // ✅ Hotel name
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                const SizedBox(height: 8),

                // ✅ Timings
                Text(
                  "Check-In: ${formatTime(hotel.checkInTime ?? "")} | Check-out: ${formatTime(hotel.checkOutTime ?? "")}",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),

                // ✅ Description
                const Text(
                  'About the Property',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  hotel.description ?? "No description available",
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
                    isDescriptionExpanded ? "View Less" : "View More Details",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Facilities
                if (hotel.facilities != null &&
                    hotel.facilities!.isNotEmpty) ...[
                  const Text(
                    "Facilities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  ...hotel.facilities!
                      .take(isFacilitiesExpanded ? hotel.facilities!.length : 4)
                      .map(
                        (facility) => Row(
                          children: [
                            const Icon(Icons.check, color: Colors.green),
                            const SizedBox(width: 4),
                            Expanded(child: Text(facility)),
                          ],
                        ),
                      )
                      .toList(),
                  if (hotel.facilities!.length > 4)
                    GestureDetector(
                      onTap: () => _showFacilitiesBottomSheet(
                        context,
                        hotel.facilities!,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          "View More",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],

                const SizedBox(height: 20),

                // ✅ Rules
                if (hotel.rules != null && hotel.rules!.isNotEmpty) ...[
                  const Text(
                    "Property Rules & Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...hotel.rules!
                      .take(isRulesExpanded ? hotel.rules!.length : 4)
                      .map(
                        (rule) => Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 6),
                            Expanded(child: Text(rule)),
                          ],
                        ),
                      )
                      .toList(),
                  if (hotel.rules!.length > 4)
                    GestureDetector(
                      onTap: () => _showRulesBottomSheet(context, hotel.rules!),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          "View More",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
                            // MultiImageProvider(images, initialIndex: index);
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
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>FractionallySizedBox(
    heightFactor: 0.5, child: _buildBottomSheetContent(
        "All Property Rules & Info",
        Icons.rule,
        Colors.green,
        rules,
      ),
      )
    );
  }

  void _showFacilitiesBottomSheet(
      BuildContext context,
      List<String> facilities,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.5, // 👈 makes it half the screen height
        child: _buildBottomSheetContent(
          "All Facilities",
          Icons.apartment,
          Colors.green,
          facilities,
        ),
      ),
    );
  }

  Widget _buildBottomSheetContent(
    String title,
    IconData icon,
    Color color,
    List<String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) => Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      items[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
