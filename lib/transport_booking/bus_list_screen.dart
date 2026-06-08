import 'dart:convert';

import 'package:elior/transport_booking/seat_booking.dart';
import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../response_model/transport_response/bus_route_response.dart';
import 'date_bus_booking.dart';

class BusListScreen extends StatefulWidget {
  BusListScreen({super.key});

  // final String Date

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  String selectedCategory = "Sort by";
  final BusRouteModel model = Get.arguments;

  String selectedSort = "Relevance";

  final Map<String, List<String>> filterOptions = {
    "Sort by": [
      "Relevance",
      "Price - Low to high",
      "Best rated first",
      "Early departure",
      "Late departure",
    ],
    "Departure time": [
      "Before 6 AM",
      "6 AM - 12 PM",
      "12 PM - 6 PM",
      "After 6 PM",
    ],
    "Bus Type": ["AC", "Non-AC", "Sleeper", "Seater"],
    "Bus Operator": ["Laxmi Travels", "OurBus", "Chandra Raj Travels"],
  };

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Filter Buses",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Content row
                  Expanded(
                    child: Row(
                      children: [
                        // Left category panel
                        Container(
                          width: 150,
                          color: Colors.grey.shade100,
                          child: ListView(
                            children: filterOptions.keys.map((category) {
                              bool isSelected = category == selectedCategory;
                              return InkWell(
                                onTap: () {
                                  setModalState(() {
                                    selectedCategory = category;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade100,
                                  child: Text(
                                    category,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? Colors.red
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // Right options panel
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListView(
                              children: filterOptions[selectedCategory]!.map((
                                option,
                              ) {
                                return RadioListTile<String>(
                                  title: Text(
                                    option,
                                    style: GoogleFonts.inter(fontSize: 14),
                                  ),
                                  value: option,
                                  groupValue: selectedSort,
                                  activeColor: Colors.red,
                                  onChanged: (value) {
                                    setModalState(() {
                                      selectedSort = value!;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom buttons
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                selectedSort = "Relevance";
                                selectedCategory = "Sort by";
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black26),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              "Clear all",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Applied: $selectedSort"),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              "View 60 buses",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    final redColor = const Color(0xFFE53935);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.data != null && model.data!.isNotEmpty)
              Text(
                "${model.data![0].origin} → ${model.data![0].destination}",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              )
            else
              Text(
                "No route available",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            Text(
              "${model.data?.length ?? 0} Buses",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () {
                Get.off(BusBookingScreen());
              },
              child: Text(
                "${LocalStorages().getBusDate()}",
                style: GoogleFonts.inter(
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),

      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    openFilterSheet();
                  },
                  child: _buildFilterChip(
                    Icons.filter_alt,
                    "Filter & Sort",
                    Colors.blue.shade100,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Bus List
          if (model.data == null || model.data!.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "No Data Available",
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: model.data!.length,
                itemBuilder: (context, index) {
                  var bus = model.data![index];
                  // final rating = 4.2; // static for now
                  final ratingColor = Colors.green;
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        BusSeatScreen(
                          origin: model.data![0].origin ?? "",
                          destination: model.data![0].destination ?? "",
                          busId: model.data?[index].busId ?? 0,
                          busRouteId: model.data?[0].busRouteId ?? 0,
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🕒 Time + Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${bus.departureDatetime?.split(' ').last.substring(0, 5)} - "
                                      "${bus.arrivalDatetime?.split(' ').last.substring(0, 5)}",
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${bus.currency} ${bus.fareBase}",
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    Text(
                                      "Onwards",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const Divider(height: 20, thickness: 0.8),

                            // ⏳ Duration + 💺 Seats
                            Row(
                              children: [
                                const Icon(
                                  Icons.route,
                                  size: 16,
                                  color: Colors.indigo,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${bus.distanceKm} km",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.event_seat,
                                  size: 16,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${bus.totalSeats} Seats",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // 🏢 Company + ⭐ Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.blueGrey,
                                      child: Icon(
                                        Icons.directions_bus,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      bus.companyName ?? "Unknown",
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 8,
                                //     vertical: 4,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color: ratingColor.withOpacity(0.15),
                                //     borderRadius: BorderRadius.circular(12),
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       Icon(
                                //         Icons.star,
                                //         color: ratingColor,
                                //         size: 14,
                                //       ),
                                //       const SizedBox(width: 3),
                                //       Text(
                                //         rating.toString(),
                                //         style: GoogleFonts.inter(
                                //           fontSize: 12,
                                //           fontWeight: FontWeight.w600,
                                //           color: ratingColor,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // 🚌 Bus Type
                            Text(
                              bus.busTypeName ?? "",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 🎛 Features
                            if (bus.features != null &&
                                bus.features!.isNotEmpty)
                              Wrap(
                                spacing: 6,
                                children:
                                    (jsonDecode(bus.features!) as List<dynamic>)
                                        .map(
                                          (f) => Chip(
                                            label: Text(
                                              f.toString(),
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            backgroundColor:
                                                Colors.blue.shade50,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),

                            const SizedBox(height: 8),

                            // 🖼 Bus Images
                            // if (bus.image != null && bus.image!.isNotEmpty)
                            //   SizedBox(
                            //     height: 90,
                            //     child: ListView(
                            //       scrollDirection: Axis.horizontal,
                            //       children: (jsonDecode(bus.image!) as List<dynamic>)
                            //           .map(
                            //             (img) => Container(
                            //           margin: const EdgeInsets.only(right: 8, top: 6),
                            //           width: 120,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(12),
                            //             image: DecorationImage(
                            //               image: NetworkImage(
                            //                 "https://yourcdn.com/uploads/$img", // replace with real URL
                            //               ),
                            //               fit: BoxFit.cover,
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //           .toList(),
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Filter Chip Widget (with gradient background)
  Widget _buildFilterChip(
    IconData icon,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Bus Card Widget
}
