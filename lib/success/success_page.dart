import 'package:elior/app_values/app_theme.dart';
import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SuccessPageData {
  final String id;
  final String bookingName;
  final String bookingAddress;
  final String checkIn;
  final String checkOut;
  final String room;
  final String payment;

  SuccessPageData({
    required this.id,
    required this.bookingName,
    required this.bookingAddress,
    required this.checkIn,
    required this.checkOut,
    required this.room,
    required this.payment,
  });
}

class SuccessPage extends StatefulWidget {
  final SuccessPageData data;

  const SuccessPage({
    super.key,
    required this.data,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final Color primaryColor = AppTheme.appThemeColor;

  final Color greenColor = AppTheme.greenColor;

  late final SuccessPageData? args;

  @override
  void initState() {
    super.initState();

    args = Get.arguments;

    print("ARGS => ${Get.arguments}");

    if (Get.arguments == null) {
      print("Arguments are NULL");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          children: [
            _buildSuccessIcon(),

            const SizedBox(height: 18),

            Text(
              "booking_successful".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: greenColor,
              ),
            ),

            const SizedBox(height: 22),

            _infoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowText("${"booking_id".tr}:", widget.data.id),

                  const Divider(height: 22),

                  _rowText(
                    "${"property_name".tr}:",
                    widget.data.bookingName,
                  ),

                  const Divider(height: 24),

                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.data.bookingAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _infoCard(
              child: Column(
                children: [
                  _iconTile(
                    CupertinoIcons.calendar,
                    "${"check_in_label".tr}",
                    widget.data.checkIn,
                  ),

                  const Divider(height: 20),

                  _iconTile(
                    CupertinoIcons.calendar_today,
                    "${"check_out_label".tr}",
                    widget.data.checkOut,
                  ),

                  const Divider(height: 20),

                  _iconTile(
                    CupertinoIcons.bed_double_fill,
                    "",
                    widget.data.room,
                  ),

                  const Divider(height: 20),

                  _iconTile(
                    CupertinoIcons.money_dollar_circle_fill,
                    "${"advance_payment".tr}:",
                    widget.data.payment,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            AppButton(
              title: "view_booking".tr,
              onTap: () {
                Get.offAll(
                      () => const BottomBarScreen(
                    initialIndex: 1,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xff4FCB4F), Color(0xff138C2E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 65),
    );
  }

  Widget _infoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _rowText(String title, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.black87),
        children: [
          TextSpan(
            text: "$title ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _iconTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 17, color: Colors.black87),
              children: [
                TextSpan(
                  text: title.isEmpty ? "" : "$title ",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}