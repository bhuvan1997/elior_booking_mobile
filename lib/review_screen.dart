import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'network/service_provider.dart';

class ReviewScreen extends StatefulWidget {
  final int bookingId;

  const ReviewScreen({super.key, required this.bookingId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int selectedIndex = 0;
  int rating = 0;
  bool isLoading = false;

  final TextEditingController reviewController = TextEditingController();

  final List<String> reviewOptions = [
    "Great Stay, Worth the Money",
    "Average Experience, Could Be Better",
    "Comfortable Room & Good Service",
    "Not Worth the Price",
    "Disappointed with Cleanliness",
  ];

  Future<bool> reviewApi({
    required int id,
    required int star,
    required String title,
    required String review,
  }) async {
    try {
      setState(() => isLoading = true);

      final response = await ServiceProvider().review(
        bookingId: id,
        starRating: star,
        title: title,
        review: review,
      );

      setState(() => isLoading = false);

      /// assuming your API returns status true/false
      if (response.status == true) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Something went wrong")),
        );
        return false;
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error : $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));

      return false;
    }
  }

  bool validateForm() {
    if (rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select rating")));
      return false;
    }

    if (selectedIndex < 0 || selectedIndex >= reviewOptions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select review title")),
      );
      return false;
    }

    if (reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please write your review")));
      return false;
    }

    if (reviewController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review must be at least 10 characters")),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Review",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              "How was your stay\nexperience?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            /// ⭐ Rating
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.star,
                      size: 30,
                      color: index < rating
                          ? const Color(0xFFFFB400)
                          : const Color(0xFFD9D9D9),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            const Text(
              "Select your Review",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            /// Chips
            ...List.generate(reviewOptions.length, (index) {
              final bool isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFFF4E5)
                          : const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFF9800)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      reviewOptions[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFFFF9800)
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            const Text(
              "Write a detailed review of your stay",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: reviewController,
                    maxLines: 5,
                    maxLength: 300,
                    decoration: const InputDecoration(
                      hintText:
                          "Tell us more about your stay such as location, food, amenities, service etc.",
                      border: InputBorder.none,
                      counterText: "",
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "${reviewController.text.length}/300",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// SUBMIT BUTTON
            GestureDetector(
              onTap: isLoading
                  ? null
                  : () async {
                      if (!validateForm()) return;

                      final success = await reviewApi(
                        id: widget.bookingId,
                        star: rating,
                        title: reviewOptions[selectedIndex],
                        review: reviewController.text.trim(),
                      );

                      if (success) {
                        Get.offAll(BottomBarScreen());
                      }
                    },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
