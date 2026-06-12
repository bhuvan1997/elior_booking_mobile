import 'package:elior/app_values/app_theme.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elior/utils/storage.dart';
import 'package:get/get.dart';
import '../network/service_provider.dart';
import '../response_model/hotel_booking_response.dart';
import '../response_model/room_available_response.dart';
import '../utils/translator_service.dart';
import 'booking_detail.dart';

class RoomListScreen extends StatefulWidget {
  final int id;
  final String hotelName;
  final String checkIn;
  final String checkOut;

  const RoomListScreen({
    super.key,
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.hotelName,
  });

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  RoomAvailableModel? roomAvailableModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHotels(
        widget.id,
        LocalStorages().getCheckIn() ?? "",
        LocalStorages().getCheckOut() ?? "",
      );
    });
  }

  Future<void> fetchHotels(int id, String checkIn, String checkOut) async {
    try {
      final result = await ServiceProvider().roomAvailableApi(
        id,
        checkIn,
        checkOut,
      );
      if (result.data != null && result.data!.isNotEmpty) {
        String langCode = Get.locale?.languageCode ?? "en";
        await HotelTranslator.translateHotels(result.data!, langCode);
      }
      setState(() {
        roomAvailableModel = result;
      });
    } catch (e) {
      debugPrint('Hotel detail error: $e');
      setState(() {});
    }
  }

  RoomBookingModel roomBookingModel = RoomBookingModel();

  Future bookingHotel({
    required String hotelId,
    required String startDate,
    required String endDate,
    required String type,
    required int person,
    required int rooms,
  }) async {
    try {
      roomBookingModel = await ServiceProvider().hotelBookingApi(
        hotelId: hotelId,
        startDate: startDate,
        endDate: endDate,
        type: type,
        person: person,
        rooms: rooms,
      );
    } catch (e) {
      debugPrint('Error occurred: $e');
    }
  }

  void _showBookingDialog(
    BuildContext context,
    String roomType,
    List<String> images,
    int availableRooms,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int selectedCount = 1;
        int selectPersonCount = 1;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Book $roomType", style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 12),
                  if (images.isNotEmpty)
                    Image.network(images.first, height: 150, fit: BoxFit.cover),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text("Add Rooms"),
                          Row(
                            children: [
                              IconButton(
                                onPressed: selectedCount > 1
                                    ? () => setState(() => selectedCount--)
                                    : null,
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Text(
                                "$selectedCount",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: selectedCount < availableRooms
                                    ? () => setState(() => selectedCount++)
                                    : null,
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Add Guests"),
                          Row(
                            children: [
                              IconButton(
                                onPressed: selectPersonCount > 1
                                    ? () => setState(() => selectPersonCount--)
                                    : null,
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Text(
                                "$selectPersonCount",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    setState(() => selectPersonCount++),
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(" Available Rooms: $availableRooms".tr),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      bookingHotel(
                        hotelId: widget.id.toString(),
                        startDate: LocalStorages().getCheckIn() ?? "",
                        endDate: LocalStorages().getCheckOut() ?? "",
                        type: roomType,
                        person: selectPersonCount,
                        rooms: selectedCount,
                      ).whenComplete(() {
                        if (roomBookingModel.status == true) {
                          var hotelBooking = roomBookingModel.data;
                          LocalStorages().saveRoomType(RoomTyp: roomType);
                          Get.off(
                            () => ReviewBookingScreen(),
                            arguments: hotelBooking,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Booked $selectedCount x $roomType for $selectPersonCount guests ✅",
                              ),
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // 🔹 Blue background
                      foregroundColor: Colors.white, // Optional: text color
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = roomAvailableModel == null;

    return Scaffold(
      appBar: getAppBar(context, widget.hotelName, centerTitle: false),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : (roomAvailableModel!.data == null ||
                roomAvailableModel!.data!.isEmpty)
          ? Center(
              child: Text(
                "Rooms not Available".tr,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: roomAvailableModel!.data!.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                var room = roomAvailableModel!.data![index];
                int totalRooms = room.roomsId?.length ?? 0;
                int availableRooms = room.availableRoomId?.length ?? 0;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(
                      color: AppTheme.black.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.black.withValues(alpha: 0.1),
                        offset: const Offset(1, 2),
                        blurRadius: 90,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.translatedRoomType ?? "Room",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (room.roomImages != null &&
                          room.roomImages!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 180,
                              viewportFraction: 1,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                            ),
                            items: room.roomImages!.map((img) {
                              return Image.network(
                                img,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            }).toList(),
                          ),
                        ),

                      const SizedBox(height: 12),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        margin: const EdgeInsets.only(right: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Room Name
                              Text("Description:  ${room.description ?? ""}"),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.bed,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${room.bedType}".tr,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Capacity
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${room.capacity ?? 0} Adults",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.meeting_room,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${room.roomSize ?? ""} ",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Available: $availableRooms / $totalRooms rooms",
                        style: TextStyle(
                          color: availableRooms > 0
                              ? Colors.orange
                              : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            " ${room.currency} ${room.pricePerNight} + ",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${room.currency} ${room.tax} Taxes & fees per night",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      const SizedBox(height: 12),
                      AppButton(
                        title: availableRooms > 0 ? "Book Now" : "Sold Out",
                        onTap: availableRooms > 0
                            ? () => _showBookingDialog(
                                context,
                                room.translatedRoomType ?? "Room",
                                room.roomImages ?? [],
                                availableRooms,
                              )
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
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
      hotel.translatedBeds = await translator.translateText(
        hotel.beds ?? "",
        langCode,
      );
      hotel.translatedRoomType = await translator.translateText(
        hotel.roomType ?? "",
        langCode,
      );
    }
  }
}
