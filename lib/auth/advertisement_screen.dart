import 'package:elior/auth/login_screen.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../network/service_provider.dart';
import '../response_model/trip_model/travel_vlogs.dart';
import '../response_model/trip_model/tripModel.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  TripModel bookingHistoryModel = TripModel();
  TravelVlogsModel travelVlogsModel = TravelVlogsModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBookingHotels();
      travelfetchBookingHotels();
    });
  }

  Future<void> fetchBookingHotels() async {
    try {
      isLoading = true;
      setState(() {});
      bookingHistoryModel = await ServiceProvider().tripApiUnauth();
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> travelfetchBookingHotels() async {
    try {
      isLoading = true;
      setState(() {});
      travelVlogsModel = await ServiceProvider().travelTripApiUN();
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
      backgroundColor: const Color(0xfff5f5f5),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xfff97316)),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await fetchBookingHotels();
                await travelfetchBookingHotels();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ORANGE HEADER
                    // Container(
                    //   height: 180,
                    //   width: double.infinity,
                    //   decoration: const BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [Color(0xfff97316), Color(0xffffa94d)],
                    //       begin: Alignment.topCenter,
                    //       end: Alignment.bottomCenter,
                    //     ),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       "Elior Booking",
                    //       style: GoogleFonts.poppins(
                    //         fontSize: 26,
                    //         fontWeight: FontWeight.w700,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SafeArea(
                      child: Center(
                        child: Image.asset(
                          AssetsScreen.eliordasAppLogo,
                          height: 80,
                        ),
                      ),
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      child: Image.network(
                        "https://eliorbooking.com/public/uploads/property/1761911755_6904a3cb19972.jpg",
                      ),
                    ),

                    const SizedBox(height: 20),

                    _modernSectionTitle("Top Rated Hotels"),
                    const SizedBox(height: 10),
                    _buildModernTripCarousel(),

                    const SizedBox(height: 25),

                    _modernSectionTitle("Daily Travel Blogs"),
                    const SizedBox(height: 10),
                    _buildModernBlogCarousel(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _modernSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildModernTripCarousel() {
    if (bookingHistoryModel.data == null || bookingHistoryModel.data!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: bookingHistoryModel.data!.length,
        itemBuilder: (context, index) {
          final trip = bookingHistoryModel.data![index];

          return GestureDetector(
            onTap: () => Get.to(() => LoginScreen()),
            child: Container(
              width: 190,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// IMAGE
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.network(
                      trip.images?.isNotEmpty == true
                          ? trip.images!.first
                          : 'https://via.placeholder.com/400x200',
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.name ?? "Unnamed Hotel",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        /// STARS (static for now)
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.orange,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${trip.currency ?? "INR"} ${trip.pricePerNight ?? 0}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// BOOK BUTTON
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xfff97316), Color(0xffffa94d)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "BOOK NOW",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildModernBlogCarousel() {
    if (travelVlogsModel.data == null || travelVlogsModel.data!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: travelVlogsModel.data!.length,
        itemBuilder: (context, index) {
          final blog = travelVlogsModel.data![index];

          return GestureDetector(
            onTap: () => Get.to(() => LoginScreen()),
            child: Container(
              width: 220,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      blog.coverImage ??
                          (blog.image?.isNotEmpty == true
                              ? blog.image!.first
                              : 'https://via.placeholder.com/400x200'),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Text(
                      "READ MORE",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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

  //--------------------- SECTION HEADER ----------------------
  Widget _buildSectionHeader(String title, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  //--------------------- TRIP CAROUSEL ----------------------
  Widget _buildTripCarousel() {
    if (bookingHistoryModel.data == null || bookingHistoryModel.data!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "No trips found",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: bookingHistoryModel.data!.length,
        itemBuilder: (context, index) {
          final trip = bookingHistoryModel.data![index];

          return GestureDetector(
            onTap: () => Get.to(() => LoginScreen()),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              color: Colors.white,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    Image.network(
                      trip.images?.isNotEmpty == true
                          ? trip.images!.first
                          : 'https://via.placeholder.com/400x200.png?text=No+Image',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.name ?? "Unnamed Hotel",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  trip.address ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "${trip.currency ?? "INR"} ${trip.pricePerNight ?? 0} /Night",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black,
                            ),
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
      ),
    );
  }

  //--------------------- TRAVEL BLOG CAROUSEL ----------------------
  Widget _buildTravelBlogCarousel() {
    if (travelVlogsModel.data == null || travelVlogsModel.data!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: travelVlogsModel.data!.length,
        itemBuilder: (context, index) {
          final blog = travelVlogsModel.data![index];

          return GestureDetector(
            onTap: () => Get.to(() => LoginScreen()),

            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              color: Colors.white,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      blog.coverImage ??
                          (blog.image?.isNotEmpty == true
                              ? blog.image!.first
                              : 'https://via.placeholder.com/400x200'),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.title ?? "Untitled Blog",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            blog.content ?? "No content",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
