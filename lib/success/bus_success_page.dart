import 'package:elior/app_values/app_theme.dart';
import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SuccessPageData {
  final String pnr;
  final String origin;
  final String destination;
  final String companyName;
  final String model;
  final String currency;
  final String fareTotal;
  final String departureDatetime;

  SuccessPageData({
    required this.pnr,
    required this.origin,
    required this.destination,
    required this.companyName,
    required this.model,
    required this.currency,
    required this.fareTotal,
    required this.departureDatetime,
  });

  factory SuccessPageData.fromJson(Map<String, dynamic> json) {
    return SuccessPageData(
      pnr: json['pnr'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      companyName: json['company_name'] ?? '',
      model: json['model'] ?? '',
      currency: json['currency'] ?? '',
      fareTotal: json['fare_total'] ?? '',
      departureDatetime: json['departure_datetime'] ?? '',
    );
  }
}

class BusSuccessPage extends StatefulWidget {
  final SuccessPageData data;

  const BusSuccessPage({
    super.key,
    required this.data,
  });

  @override
  State<BusSuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<BusSuccessPage> {
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

  String _formattedDeparture() {
    try {
      final dt = DateTime.parse(widget.data.departureDatetime);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return widget.data.departureDatetime;
    }
  }

  String _formattedFare() {
    return "${widget.data.currency} ${widget.data.fareTotal}";
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
                  _rowText("${"pnr".tr}:", widget.data.pnr),

                  const Divider(height: 22),

                  _rowText("${"operator_label".tr}:", widget.data.companyName),

                  const Divider(height: 22),

                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.bus,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.data.model,
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "from".tr,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data.origin,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.arrow_right,
                    color: primaryColor,
                    size: 22,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "to".tr,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data.destination,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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
                    "${"departure".tr}:",
                    _formattedDeparture(),
                  ),

                  const Divider(height: 20),

                  _iconTile(
                    CupertinoIcons.money_dollar_circle_fill,
                    "${"fare_total".tr}:",
                    _formattedFare(),
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
                    historyTab: 1,
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