import 'package:elior/app_values/app_theme.dart';
import 'package:elior/response_model/fav_model/get_fav_model.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../hotel_booking/hotel_detail.dart';
import '../hotel_booking/trip_detail_screen.dart';
import '../network/service_provider.dart';
import '../response_model/fav_model/add_fav_moodel.dart';
import '../utils/storage.dart';

class MyFavScreen extends StatefulWidget {
  @override
  State<MyFavScreen> createState() => _MyFavScreenState();
}

class _MyFavScreenState extends State<MyFavScreen> {
  GetFavModel bookingHistoryModel = GetFavModel();
  SelectFaModel selectFaModel = SelectFaModel();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBookingHotels();
    });
  }

  String formatTime(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("hh:mm a").format(parsed);
    } catch (e) {
      return time;
    }
  }

  // ================= FETCH FAVORITES =================

  Future<void> fetchBookingHotels() async {
    try {
      setState(() => isLoading = true);

      bookingHistoryModel =
      await ServiceProvider().getFavProperty();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // ================= REMOVE FAVORITE =================

  Future<void> removeFavApi({required int id}) async {
    try {
      await ServiceProvider().removeFavProperty(propertyId: id);
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  String formatDates(DateTime? date) {
    if (date == null) return 'yyyy-MM-dd';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatApiDate(String inputDate) {
    try {
      DateTime date = DateFormat("d/M/yyyy").parse(inputDate);
      return DateFormat("yyyy-MM-dd").format(date);
    } catch (e) {
      return inputDate; // fallback in case of error
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'yyyy-MM-dd';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: getAppBar(context, "wishlist".tr, isLeading: false),
      body: _buildTripSlider(),
    );
  }

  // ================= SLIDER =================

  Widget _buildTripSlider() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (bookingHistoryModel.data == null ||
        bookingHistoryModel.data!.isEmpty) {
      return Center(
        child: Text(
          "no_data_found".tr,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: bookingHistoryModel.data!.length,
      itemBuilder: (context, index) {
        final data = bookingHistoryModel.data![index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GestureDetector(
            onTap: () {
              Get.to(UnifiedPropertyDetailsScreen(
                id: data.id ?? 0,
                fac: data.name ?? "",
                slug: data.propertyType == "hotel" ? "hotel" : "homestay",
              ));
            },
            child: _buildHotelCard(data, index),
          ),
        );
      },
    );
  }

  // ================= HOTEL CARD =================

  Widget _buildHotelCard(Data data, int index) {
    String imageUrl = (data.images?.isNotEmpty ?? false)
        ? data.images!.first
        : "https://via.placeholder.com/400";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE + HEART BUTTON
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),

                // Gradient
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),

                // REMOVE FAVORITE HEART BUTTON
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () async {
                      int id = data.id ?? 0;

                      // Remove from UI instantly
                      setState(() {
                        bookingHistoryModel.data!.removeAt(index);
                      });

                      // Call API to remove from favorites
                      await removeFavApi(id: id);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // DETAILS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data.name ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star,
                            size: 16,
                            color: Colors.amber.shade600),
                        const SizedBox(width: 4),
                        Text(
                          "${data.starRating}/5",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16,
                        color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${data.city ?? ""}, ${data.country ?? ""}",
                        style: const TextStyle(
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${"check_in_label".tr} ${formatTime(data.checkInTime.toString())} | "
                      "${"check_out_label".tr} ${formatTime(data.checkOutTime.toString())}",
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "${data.currency ?? ""} ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${data.pricePerNight ?? ""} ${"per_night".tr}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}