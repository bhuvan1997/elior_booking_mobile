import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../network/service_provider.dart';
import '../response_model/home_stay_respnse/accomendation_booking_screen.dart';
// import '../response_model/home_stay_respnse/accomendation_response.dart';
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

  // bool isLoading = true;

  Future<void> fetchRooms(int id, String checkIn, String checkOut) async {
    try {
      final result = await ServiceProvider().homeStayRoomAvailableApi(
        id,
        checkIn,
        checkOut,
      );
      setState(() {
        roomAvailableModel = result;
        // isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading rooms: $e');
      // setState(() => isLoading = false);
    }
  }

  AccomendationBookingModel accomendationBookingModel =
      AccomendationBookingModel();

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
        // isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading rooms: $e');
      // setState(() => isLoading = false);
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
      backgroundColor: const Color(0xFFF6FDF7),
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "🏡${widget.homeName}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: rooms.isEmpty == true
          ? Center(
              child: Text(
                "Rooms not available".tr,
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
                  margin: EdgeInsets.only(bottom: 20),
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ✅ Optional Image Carousel (if your API adds images later)
                        // if (index % 2 == 0)
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

                        /// ✅ Room Name
                        Text(
                          room.accomodationName ?? "Room",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 6),

                        /// ✅ Room Details
                        Text(
                          "• It has ${room.beds ?? 0} Beds ".tr,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "• It has ${room.guest ?? 0} Guest Capacity".tr,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "• It has ${room.bedroom ?? 0} Bedrooms ".tr,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "• It has ${room.bathroom ?? 0} Bathrooms ".tr,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),

                        /// ✅ Price per Night
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${room.currency ?? ''} ${room.pricePerNight ?? 0} + ${room.currency ?? ''} ${room.tax} Taxes & fees per night",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            // if (room.tax != null)
                            //   Text(
                            //     "Tax: ${room.tax}",
                            //     style: const TextStyle(
                            //       fontSize: 13,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                          ],
                        ),
                        // XOF 1000 + XOF 0.00 Taxes & fees per night
                        const SizedBox(height: 6),

                        /// ✅ Availability Info
                        Text(
                          "Available",
                          style: TextStyle(
                            color: availableRooms > 0
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// ✅ Book Now Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              _showBookingBottomSheet(
                                context,
                                room,
                                room.images ?? [],
                              );
                              // bookConfirm(
                              //   id: room.propertyId.toString(),
                              //   checkIn: LocalStorages().getCheckIn() ?? "",
                              //   checkOut: LocalStorages().getCheckOut() ?? "",
                              //   acc: room.accomodationName ?? "",
                              //   person: room.guest ?? 0,
                              // ).whenComplete(() {
                              //   if (accomendationBookingModel.status == true) {
                              //     var homeBooking = accomendationBookingModel.data;
                              //     print("Successs");
                              //
                              //     Get.to(ReviewHomeBookingScreen(),arguments:homeBooking );
                              //   }
                              // });
                            },
                            child: Text(
                              availableRooms > 0 ? "Book Now" : "Sold Out",
                              style: const TextStyle(
                                fontSize: 16,
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
            ),
    );
  }

  /// ✅ Booking Bottom Sheet
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
        int selectedGuests = 1; // ✅ defined here
        int selectedRooms = 1;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Book ${room.accomodationName ?? "Room"}",
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

                  /// Room count selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _counterBox(
                        title: "Guests",
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

                  /// ✅ Confirm Booking Button
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
                          print("Successs");

                          Get.to(
                            ReviewHomeBookingScreen(),
                            arguments: homeBooking,
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      "Confirm Booking",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
