import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/payment_screen/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF5F8FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F8FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Booking Summary',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Stack(

        children: [
          Row(
            children: [
              Container(width: 4, color: Colors.orange),
              Expanded(child: Container()),
              Container(width: 4, color: Colors.green),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(PaymentScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'CONTINUE TO PAYMENT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),

            // Hotel card
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    AssetsScreen.hotelImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AYANA Resort',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Bali, Indonesia',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '\$350',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          TextSpan(
                            text: ' USD /night',
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

            // Booking Info
            const InfoRow(title: 'Booking Date', value: '1-Oct-2023'),
            InfoRow(title: 'Check-in', value: '24-Oct-2023'),
            InfoRow(title: 'Check-out', value: '26-Oct-2023'),
            InfoRow(title: 'Guests', value: '3'),
            InfoRow(title: 'Room(s)', value: '1'),

            const SizedBox(height: 20),
            const Divider(thickness: 0.8),

            const SizedBox(height: 20),

            // Price Summary
            const InfoRow(title: 'Amount', value: '\$350 x 2'),
            InfoRow(title: 'Tax', value: '\$30'),
            const SizedBox(height: 10),
            const InfoRow(
              title: 'Total',
              value: '\$730',
              isBold: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 15,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title, style: textStyle)),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}
