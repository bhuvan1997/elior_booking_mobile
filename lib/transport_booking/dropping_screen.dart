import 'package:elior/app_values/app_theme.dart';
import 'package:elior/response_model/transport_response/proceed_model.dart';
import 'package:elior/transport_booking/passenger_inforrmation_screen.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        busRouteId: widget.busrouteId,
        BoardingPointId: BoardingPointId,
        droppingPointId: droppingPointId,
        SeatPrice: widget.seatPrice,
      );

      setState(() => isLoading = false);

      if (proceedModel?.status == true) {
        print("✅ Proceed API Success → ${proceedModel?.message}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${"error_prefix".tr} ${proceedModel?.message ?? "unknown_error".tr}"),
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
      appBar: getAppBar(
        context,
        "select_boarding_dropping".tr,
        subtext:
        "${busPikUpModel?.data?.boardingCity ?? ''} → ${busPikUpModel?.data?.droppingCity ?? ''}",
        isSubtext: true,
        centerTitle: false,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.appThemeColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.appThemeColor,
            tabs: [
              Tab(text: "boarding".tr),
              Tab(text: "dropping".tr),
            ],
          ),
          Expanded(
            child: TabBarView(
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
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppButton(
          title: "proceed".tr,
          onTap:
          (selectedBoardingPointId == null || selectedDroppingPointId == null)
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
                    proceedModel: proceedModel ?? ProceedModel(),
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("unable_to_proceed".tr)),
              );
            }
          },
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
                  ? "${"all_boarding_points_in".tr} $city"
                  : "${"all_dropping_points_in".tr} $city",
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
                activeColor: AppTheme.appThemeColor,
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