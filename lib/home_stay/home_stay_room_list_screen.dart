import 'package:carousel_slider/carousel_slider.dart';
import 'package:elior/app_values/app_theme.dart';
import 'package:elior/hotel_booking/booking_detail.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../network/service_provider.dart';
import '../response_model/home_stay_respnse/accomendation_booking_screen.dart';
import '../response_model/home_stay_respnse/accomendation_response.dart';
import '../utils/storage.dart';
import 'home_pay_details_screen.dart';

class HomeStayRoomListScreen extends StatefulWidget {
  final int id;
  final String checkIn;
  final String checkOut;
  final String homeName;

  const HomeStayRoomListScreen({
    super.key,
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.homeName,
  });

  @override
  State<HomeStayRoomListScreen> createState() => _HomeStayRoomListScreenState();
}

class _HomeStayRoomListScreenState extends State<HomeStayRoomListScreen> {
  AccomendationModel? roomAvailableModel;

  Future<void> fetchRooms(int id, String checkIn, String checkOut) async {
    try {
      final result = await ServiceProvider().homeStayRoomAvailableApi(
        id,
        checkIn,
        checkOut,
      );
      setState(() {
        roomAvailableModel = result;
      });
    } catch (e) {
      debugPrint('Error loading rooms: $e');
    }
  }

  AccommodationBookingModel accomendationBookingModel =
  AccommodationBookingModel();

  Future<void> bookConfirm({
    required String id,
    required String checkIn,
    required String checkOut,
    required String acc,
    required int person,
  }) async {
    try {
      final result = await ServiceProvider().AccomendationId(
        homeStayId: id,
        checkInDate: checkIn,
        checkOutDate: checkOut,
        accomodation: acc,
        person: person,
      );
      setState(() {
        accomendationBookingModel = result;
      });
    } catch (e) {
      debugPrint('Error loading rooms: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRooms(
        widget.id,
        LocalStorages().getCheckIn() ?? "",
        LocalStorages().getCheckOut() ?? "",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final rooms = roomAvailableModel?.data ?? [];

    return Scaffold(
      appBar: getAppBar(context, widget.homeName),
      body: rooms.isEmpty == true
          ? Center(
        child: Text(
          "room_not_available".tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          int totalRooms = room.accomodationId?.length ?? 0;
          int availableRooms = room.availableAccomodationId?.length ?? 0;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: (room.images ?? [])
                        .map(
                          (imgUrl) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    )
                        .toList(),
                    options: CarouselOptions(
                      height: 180,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        room.accomodationName ?? "room".tr,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          "available".tr,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  /// Room Details
                  Text(
                    "${"has_beds".tr} ${room.beds ?? 0} ${"beds".tr} ",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${"has_guest_capacity".tr} ${room.guest ?? 0} ${"guests".tr}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${"has_bedrooms".tr} ${room.bedroom ?? 0} ${"bedrooms".tr} ",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${"has_bathrooms".tr} ${room.bathroom ?? 0} ${"bathrooms".tr} ",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  /// Price per Night
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${room.currency ?? ''} ${room.pricePerNight ?? 0} + ${room.currency ?? ''} ${room.tax} ${"taxes_fees_per_night".tr}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// Book Now Button
                  AppButton(
                    title: availableRooms > 0 ? "book_now".tr : "sold_out".tr,
                    onTap: () {
                      _showBookingBottomSheet(
                        context,
                        room,
                        room.images ?? [],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Booking Bottom Sheet
  void _showBookingBottomSheet(
      BuildContext context,
      Data room,
      List<String> images,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int selectedGuests = 1;
        int selectedRooms = 1;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${"book".tr} ${room.accomodationName ?? "room".tr}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (images.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        images.first,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),

                  const SizedBox(height: 20),

                  /// Guest count selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _counterBox(
                        title: "guests".tr,
                        value: selectedGuests,
                        onAdd: () => setState(() => selectedGuests++),
                        onRemove: () {
                          if (selectedGuests > 1) {
                            setState(() => selectedGuests--);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  /// Confirm Booking Button
                  ElevatedButton(
                    onPressed: () async {
                      await bookConfirm(
                        id: room.propertyId.toString(),
                        checkIn: LocalStorages().getCheckIn() ?? "",
                        checkOut: LocalStorages().getCheckOut() ?? "",
                        acc: room.accomodationName ?? "",
                        person: selectedGuests,
                      ).whenComplete(() {
                        if (accomendationBookingModel.status == true) {
                          var homeBooking = accomendationBookingModel.data;

                          Get.to(
                            ReviewBookingScreen(),
                            arguments: homeBooking?.toBookingData(),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.appThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      "confirm_booking".tr,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _counterBox({
    required String title,
    required int value,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            ),
            Text(
              "$value",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }
}