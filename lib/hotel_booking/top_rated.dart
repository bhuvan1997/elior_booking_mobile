import 'package:elior/controller/hotel_controller/top_hotel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../network/service_provider.dart';
import '../response_model/trip_model/tripModel.dart';

class TopRatedHotelsGridView extends StatefulWidget {
  @override
  State<TopRatedHotelsGridView> createState() => _TopRatedHotelsGridViewState();
}

class _TopRatedHotelsGridViewState extends State<TopRatedHotelsGridView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final hotelController = Get.put(TopHotelController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBookingHotels();
    });
    tabController = TabController(length: 3, vsync: this);

    // Load hotel data
    // hotelController.getTopHotelsApi();
  }

  TripModel bookingHistoryModel = TripModel();
  bool isLoading = false;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> fetchBookingHotels() async {
    try {
      isLoading = true;
      setState(() {});
      bookingHistoryModel = await ServiceProvider().favApi();
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0057C2),
        title: const Text(
          "My Favourite Property",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: _buildTripCarousel(),
    );
  }

  Widget _buildTripCarousel() {
    if (bookingHistoryModel.data == null || bookingHistoryModel.data!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("No trips found",
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: bookingHistoryModel.data!.length,
      itemBuilder: (context, index) {
        final trip = bookingHistoryModel.data![index];

        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼️ Beautiful Image
                  Stack(
                    children: [
                      Image.network(
                        trip.images?.isNotEmpty == true
                            ? trip.images!.first
                            : 'https://via.placeholder.com/400x200.png?text=No+Image',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      // 🔥 Bottom gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ⭐ Top Right Favorite Icon (Optional)
                      const Positioned(
                        right: 12,
                        top: 12,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.favorite_border,
                              color: Colors.red, size: 20),
                        ),
                      ),
                    ],
                  ),

                  // 📄 Details Section
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🏨 Hotel Name
                        Text(
                          trip.name ?? "Unnamed Hotel",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // 📍 Location
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                trip.address ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // 💵 Price Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${trip.currency ?? "INR"} ${trip.pricePerNight ?? 0}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF0057C2),
                              ),
                            ),
                            const Text(
                              "/ Night",
                              style:
                              TextStyle(color: Colors.grey, fontSize: 14),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ========================================================
  // HOTELS GRID
}
