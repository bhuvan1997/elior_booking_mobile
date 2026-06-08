import 'package:elior/response_model/transport_response/proceed_model.dart';
import 'package:elior/transport_booking/passenger_inforrmation_screen.dart';
import 'package:flutter/material.dart';

import '../network/service_provider.dart';
import '../response_model/transport_response/pickup_model.dart';

class BoardingDroppingScreen extends StatefulWidget {
  final String Seats;
  final int seatPrice;
  final int busId;
  final int busrouteId;

  const BoardingDroppingScreen({
    super.key,
    required this.Seats,
    required this.seatPrice,
    required this.busId,
    required this.busrouteId,
  });

  @override
  State<BoardingDroppingScreen> createState() => _BoardingDroppingScreenState();
}

class _BoardingDroppingScreenState extends State<BoardingDroppingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedDropPoint;
  String? selectedBoardPoint;

  int? selectedBoardingPointId;
  int? selectedDroppingPointId;

  BusPikUpModel? busPikUpModel;
  ProceedModel? proceedModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadPickupData();
    });
  }

  Future<void> loadPickupData() async {
    try {
      final data = await ServiceProvider().busSeatPickupApi(
        busId: widget.busId,
        busRouteId: widget.busrouteId,
      );
      setState(() {
        busPikUpModel = data;

        /// Default selections if available
        if (busPikUpModel
                ?.data
                ?.boardingPoint
                ?.boardingPointStops
                ?.isNotEmpty ??
            false) {
          final first =
              busPikUpModel!.data!.boardingPoint!.boardingPointStops!.first;
          selectedBoardPoint = first.pointname;
          selectedBoardingPointId = first.pointId;
        }

        if (busPikUpModel
                ?.data
                ?.droppingPoint
                ?.droppingPointStops
                ?.isNotEmpty ??
            false) {
          final first =
              busPikUpModel!.data!.droppingPoint!.droppingPointStops!.first;
          selectedDropPoint = first.pointname;
          selectedDroppingPointId = first.pointId;
        }
      });
    } catch (e) {
      debugPrint("❌ Error loading pickup data: $e");
    }
  }

  Future<void> proceedDataApi({
    required int BoardingPointId,
    required int droppingPointId,
  }) async {
    try {
      setState(() => isLoading = true);

      proceedModel = await ServiceProvider().proceedApi(
        seats: widget.Seats,
        busId: widget.busId,
        // You can make this dynamic if needed
        busRouteId: widget.busrouteId,
        // You can make this dynamic too
        BoardingPointId: BoardingPointId,
        droppingPointId: droppingPointId,
        SeatPrice: widget.seatPrice,
      );

      setState(() => isLoading = false);

      if (proceedModel?.status == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("✅ Proceed successful!")));
        print("✅ Proceed API Success → ${proceedModel?.message}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ ${proceedModel?.message ?? 'Unknown error'}"),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("❌ Error in proceedDataApi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final boardingStops =
        busPikUpModel?.data?.boardingPoint?.boardingPointStops ?? [];
    final droppingStops =
        busPikUpModel?.data?.droppingPoint?.droppingPointStops ?? [];

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select boarding & dropping points",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              "${busPikUpModel?.data?.boardingCity ?? ''} → ${busPikUpModel?.data?.droppingCity ?? ''}",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "Boarding points"),
            Tab(text: "Dropping points"),
          ],
        ),
      ),

      body: busPikUpModel == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                /// 🚌 Boarding Points
                _buildPointsList(
                  boardingStops
                      .map(
                        (e) => {
                          "time": e.time ?? "",
                          "title": e.pointname ?? "",
                          "date": e.date ?? "",
                          "sub": e.address ?? "",
                          "id": e.pointId?.toString() ?? "0",
                        },
                      )
                      .toList(),
                  selectedBoardPoint,
                  true,
                  busPikUpModel?.data?.boardingPoint?.boardingPointCity ?? "",
                ),

                /// 📍 Dropping Points
                _buildPointsList(
                  droppingStops
                      .map(
                        (e) => {
                          "time": e.time ?? "",
                          "title": e.pointname ?? "",
                          "date": e.date ?? "",
                          "sub": e.address ?? "",
                          "id": e.pointId?.toString() ?? "0",
                        },
                      )
                      .toList(),
                  selectedDropPoint,
                  false,
                  busPikUpModel?.data?.droppingPoint?.droppingPointCity ?? "",
                ),
              ],
            ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                (selectedBoardingPointId != null &&
                    selectedDroppingPointId != null)
                ? Colors.red
                : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed:
              (selectedBoardingPointId == null ||
                  selectedDroppingPointId == null)
              ? null
              : () async {
                  await proceedDataApi(
                    BoardingPointId: selectedBoardingPointId!,
                    droppingPointId: selectedDroppingPointId!,
                  );

                  if (proceedModel?.status == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerInformationScreen(
                          proceedModel: proceedModel!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Unable to proceed")),
                    );
                  }
                },

          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  /// 🔹 Boarding / Dropping Points List
  Widget _buildPointsList(
    List<Map<String, String>> points,
    String? selected,
    bool isBoarding,
    String city,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              isBoarding
                  ? "All boarding points in $city"
                  : "All dropping points in $city",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),

          ...points.map((point) {
            final isSelected = selected == point["title"];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: RadioListTile<String>(
                value: point["title"]!,
                groupValue: selected,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    if (isBoarding) {
                      selectedBoardPoint = value;
                      selectedBoardingPointId = int.tryParse(
                        point["id"] ?? "0",
                      );
                    } else {
                      selectedDropPoint = value;
                      selectedDroppingPointId = int.tryParse(
                        point["id"] ?? "0",
                      );
                    }
                  });
                },
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${point["time"] ?? ""}\n${point["date"] ?? ''}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        "${point["title"] ?? ""}\n${point["sub"] ?? ''}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
