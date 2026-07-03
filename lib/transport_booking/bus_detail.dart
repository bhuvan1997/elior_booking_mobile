import 'package:elior/app_values/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../response_model/transport_response/bus_seat_botttom_model.dart';
import '../network/service_provider.dart';

class BusDetailsBottomSheet extends StatefulWidget {
  const BusDetailsBottomSheet({
    super.key,
    required this.busId,
    required this.busRouteId,
  });

  final int busId;
  final int busRouteId;

  @override
  State<BusDetailsBottomSheet> createState() => _BusDetailsBottomSheetState();
}

class _BusDetailsBottomSheetState extends State<BusDetailsBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isTabClicked = false;

  final sectionKeys = {
    "highlights".tr: GlobalKey(),
    "boarding".tr: GlobalKey(),
    "dropping".tr: GlobalKey(),
    "amenities".tr: GlobalKey(),
  };

  BusSeatBottomModel? _busSeatBottomModel;

  Future<void> loadSeats() async {
    try {
      final data = await ServiceProvider().busSeatBottomDetailApi(
        busId: widget.busId,
        busRouteId: widget.busRouteId,
      );
      setState(() {
        _busSeatBottomModel = data;
      });
    } catch (e) {
      debugPrint("Error loading bus bottom details: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: sectionKeys.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSeats();
    });
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_isTabClicked) return;

    double currentOffset = _scrollController.offset;
    double minDiff = double.infinity;
    int targetIndex = 0;

    sectionKeys.values.toList().asMap().forEach((i, key) {
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        double diff = (position.dy - 150).abs();
        if (diff < minDiff) {
          minDiff = diff;
          targetIndex = i;
        }
      }
    });

    if (_tabController.index != targetIndex) {
      _tabController.animateTo(targetIndex);
    }
  }

  Future<void> _scrollToSection(int index) async {
    _isTabClicked = true;
    final key = sectionKeys.values.elementAt(index);
    final ctx = key.currentContext;
    if (ctx != null) {
      final box = ctx.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      await _scrollController.animateTo(
        _scrollController.offset + position.dy - 150,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      _isTabClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _busSeatBottomModel?.data;
    final highlight = data?.busBookHighlight;
    final boarding = data?.boardingPoint;
    final dropping = data?.droppingPoint;
    final amenities = data?.busFeatures ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.companyName ?? "unknown_company".tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${data?.busType ?? ''} (${data?.busModel ?? ''})",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "4.2/5",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.star, size: 14, color: Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // TabBar
          TabBar(
            controller: _tabController,
            onTap: _scrollToSection,
            isScrollable: true,
            indicatorColor: AppTheme.appThemeColor,
            labelColor: AppTheme.appThemeColor,
            unselectedLabelColor: Colors.grey,
            tabs: sectionKeys.keys.map((e) => Tab(text: e)).toList(),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHighlightSection(highlight),
                  buildBoardingSection(boarding),
                  buildDroppingSection(dropping),
                  buildAmenitiesSection(amenities),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Highlights Section
  Widget buildHighlightSection(BusBookHighlight? data) {
    final images = data?.busImages ?? [];

    return Container(
      key: sectionKeys["highlights".tr],
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "highlights".tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppTheme.appThemeColor),
              const SizedBox(width: 6),
              Text(
                "${data?.departureTime ?? '--'} → ${data?.arrivalTime ?? '--'}",
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("${"departure_date".tr}: ${data?.departureDate ?? '--'}"),
          const SizedBox(height: 12),
          if (images.isNotEmpty)
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    images[i],
                    width: 180,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 🔹 Boarding Section
  Widget buildBoardingSection(BoardingPoint? boarding) {
    final city = boarding?.boardingPointCity ?? '';
    final stops = boarding?.boardingPointStops ?? [];

    return Container(
      key: sectionKeys["boarding".tr],
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${"boarding_point".tr} - $city",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...stops.map((stop) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.directions_bus, color: AppTheme.appThemeColor),
                title: Text(stop.pointname ?? ''),
                subtitle: Text(stop.address ?? ''),
                trailing: Text(stop.time ?? ''),
              ),
            );
          }),
        ],
      ),
    );
  }

  // 🔹 Dropping Section
  Widget buildDroppingSection(DroppingPoint? dropping) {
    final city = dropping?.droppingPointCity ?? '';
    final stops = dropping?.droppingPointStops ?? [];

    return Container(
      key: sectionKeys["dropping".tr],
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${"dropping_point".tr} - $city",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...stops.map((stop) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: AppTheme.appThemeColor,
                ),
                title: Text(stop.pointname ?? ''),
                subtitle: Text(stop.address ?? ''),
                trailing: Text(stop.time ?? ''),
              ),
            );
          }),
        ],
      ),
    );
  }

  // 🔹 Amenities Section
  Widget buildAmenitiesSection(List<String> amenities) {
    return Container(
      key: sectionKeys["amenities".tr],
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "amenities".tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: amenities
                .map(
                  (a) => Chip(
                label: Text(a),
                backgroundColor: Colors.blue.shade50,
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}