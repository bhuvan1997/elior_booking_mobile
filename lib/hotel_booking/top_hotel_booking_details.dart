import 'dart:convert';

import 'package:elior/response_model/top_hotel_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TopHotelDetailsScreen extends StatelessWidget {
  TopHotelDetailsScreen({super.key});
  String formatTime(String? time) {
    if (time == null || time.isEmpty) return "";
    try {
      final parsedTime = DateFormat("HH:mm").parse(time); // Expecting 24hr format like "13:30"
      return DateFormat("hh:mm a").format(parsedTime); // Converts to 12hr format
    } catch (e) {
      return time; // if parsing fails, return as is
    }
  }
  final Data? hotel = Get.arguments; // ✅ null-safe
  @override
  Widget build(BuildContext context) {
    if (hotel == null) {
      return const Scaffold(body: Center(child: Text("No hotel data found")));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel!.name ?? "Hotel Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel image
            // if (hotel!.images != null && hotel!.images!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              child: Image.network(
                hotel!.images![0],
                // "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?fit=crop&w=800&q=80",

                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name + Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hotel!.name ?? "",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          hotel!.starRating ?? 0,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${hotel!.address ?? ""}, ${hotel!.city ?? ""}, ${hotel!.state ?? ""}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Description
                  Text(
                    hotel!.description ?? "No description available.",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  const SizedBox(height: 20),

                  // Contact
                  if (hotel!.phone != null)
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 6),
                        Text(hotel!.phone!),
                      ],
                    ),
                  if (hotel!.email != null)
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.blue),
                        const SizedBox(width: 6),
                        Expanded(child: Text(hotel!.email!)),
                      ],
                    ),

                  const SizedBox(height: 10),

                  // Facilities (if available in your model)

                  Text("Check in time: ${formatTime(hotel!.checkInTime)}"),
                  Text("Check out time: ${formatTime(hotel!.checkOutTime)}"),

                    SizedBox(height: 10,),
                    if (hotel!.facilities != null && hotel!.facilities!.isNotEmpty) ...[
                      const Text(
                        "Facilities",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Builder(
                        builder: (context) {
                          List<String> facilitiesList = [];
                          try {
                            if (hotel!.facilities != null) {
                              if (hotel!.facilities is String) {
                                // decode the JSON string into List
                                facilitiesList = List<String>.from(jsonDecode(hotel!.facilities!));
                              } else if (hotel!.facilities is List) {
                                // already a List from API/model
                                facilitiesList = List<String>.from(hotel!.facilities as List);
                              }
                            }
                          } catch (e) {
                            facilitiesList = [];
                          }

                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: facilitiesList.map((f) {
                              return Chip(
                                label: Text(f),
                                backgroundColor: Colors.deepPurple.shade50,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],


                  const SizedBox(height: 30),

                  // Book Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.snackbar("Booking", "Booking Coming Soon!");
                      },
                      child: const Text(
                        "Book Now",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
