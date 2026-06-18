import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constatnt/assets_image.dart';
import '../network/service_provider.dart';
import '../response_model/bus_seat_model.dart';
import 'bus_detail.dart';
import 'dropping_screen.dart';

class BusSeatScreen extends StatefulWidget {
  BusSeatScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.busId,
    required this.busRouteId,
  });

  final int busId;
  final int busRouteId;
  final String origin;
  final String destination;

  @override
  State<BusSeatScreen> createState() => _BusSeatScreenState();
}

class _BusSeatScreenState extends State<BusSeatScreen>
    with TickerProviderStateMixin {
  BusSeatLayoutResponse? _busSeatLayoutResponse;

  final List<SeatModel> _selectedSeats = [];

  @override
  void initState() {
    super.initState();
    print("INIT STATE CALLED");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("POST FRAME CALLBACK");
      await loadSeats();
    });
  }

  Future<void> loadSeats() async {
    print("LOAD SEATS STARTED");
    try {
      final data = await ServiceProvider().busSeatApi(
        busId: widget.busId,
        busRouteId: widget.busRouteId,
      );

      print("STATUS => ${data.status}");
      print("SEATS => ${data.data?.seats?.length}");
      setState(() {
        _busSeatLayoutResponse = data;
      });
    } catch (e) {
      print("Error loading seats: $e");
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    final seats = _busSeatLayoutResponse?.data?.seats ?? [];

    if (seats.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No seat data available")),
      );
    }

    final lowerDeckSeats = seats
        .where((s) => (s.deck ?? '').toLowerCase() == 'lower')
        .toList();
    final upperDeckSeats = seats
        .where((s) => (s.deck ?? '').toLowerCase() == 'upper')
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your seats',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              "${widget.origin} → ${widget.destination}",
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// 🔹 Main seat layout
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Bus Layout",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),

                /// 🔹 Horizontal scroll for Lower + Upper Decks
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (lowerDeckSeats.isNotEmpty)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildDeckTitle(
                                "Lower Berth (${lowerDeckSeats.length})",
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: buildSeatLayout(lowerDeckSeats),
                              ),
                            ],
                          ),
                        ),

                      if (upperDeckSeats.isNotEmpty)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildDeckTitle(
                                "Upper Berth (${upperDeckSeats.length})",
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: buildSeatLayout(upperDeckSeats),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          /// 🔹 Draggable Bottom Sheet (middle layer)
          DraggableScrollableSheet(
            initialChildSize: 0.29,
            minChildSize: 0.19,
            maxChildSize: 1,
            snap: true,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 🔹 Small handle for drag
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: BusDetailsBottomSheet(
                          busId: widget.busId,
                          busRouteId: widget.busRouteId,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: !_selectedSeats.isNotEmpty
          ? FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("FAB clicked")));
        },
      )
          : null,
      bottomNavigationBar: _selectedSeats.isNotEmpty ? buildBottomBar() : null,
    );
  }

  Widget buildDeckTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        Image.asset(AssetsScreen.steering, height: 30),
      ],
    );
  }

  // ----------------- buildSeatLayout (updated for SeatModel) -----------------
  Widget buildSeatLayout(List<SeatModel> seats) {
    final int maxRow = seats.maxRow;
    final int maxCol = seats.maxCol;

    const double baseSeatBox = 55.0;
    final double seatBox = baseSeatBox;

    final double gridHeight = (maxRow > 0)
        ? (maxRow * seatBox + 20)
        : seatBox + 20;
    final double gridWidth = (maxCol > 0)
        ? (maxCol * seatBox + 40)
        : seatBox + 40;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: Get.height,
        width: gridWidth,
        child: GridView.builder(
          key: ValueKey(seats.hashCode),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: maxRow * maxCol,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: maxCol > 0 ? maxCol : 1,
            mainAxisSpacing: 0.9,
            crossAxisSpacing: 0.4,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final int row = (index ~/ (maxCol > 0 ? maxCol : 1)) + 1;
            final int col = (index % (maxCol > 0 ? maxCol : 1)) + 1;

            final seat = seats.firstWhere(
                  (s) => s.row == row && s.col == col,
              orElse: () => SeatModel(), // Use SeatModel instead of Seats
            );

            if (seat.seatNo == null || (seat.seatNo?.isEmpty ?? true)) {
              return const SizedBox();
            }

            final bool isBooked = seat.isBooked ?? false;
            final bool isSelected = _selectedSeats.contains(seat);

            Color color;
            if (isBooked) {
              color = Colors.red.shade400;
            } else if (isSelected) {
              color = Colors.blue.shade400;
            } else {
              color = Colors.green.shade400;
            }

            final bool isSleeper = (seat.type ?? '').toLowerCase() == 'sleeper';

            return GestureDetector(
              onTap: isBooked
                  ? null
                  : () {
                setState(() {
                  if (isSelected) {
                    _selectedSeats.remove(seat);
                  } else {
                    _selectedSeats.add(seat);
                  }
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSleeper)
                  // 🛏 Sleeper layout
                    Container(
                      height: 50,
                      width: 25,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        border: Border.all(color: color, width: 1.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Icon(Icons.hotel, size: 14, color: color),
                      ),
                    )
                  else
                  // 💺 Regular seat
                    Image.asset(AssetsScreen.seats, height: 30, color: color),
                  const SizedBox(height: 1),
                  Text(
                    seat.seatNo ?? "",
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.blue.shade700 : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    final fare = _busSeatLayoutResponse?.data?.fare ?? 0;
    double total = _selectedSeats.fold(
      0.0,
          (sum, seat) =>
      sum +
          (fare.toDouble() + (seat.extraFare?.toDouble() ?? 0.0)),
    );
    String seatNumbers = _selectedSeats
        .map((s) => s.seatNo ?? '')
        .where((e) => e.isNotEmpty)
        .join(',');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_selectedSeats.length} Seat(s) selected",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  border: Border.all(color: Colors.transparent),
                ),
                child: Text(
                  "Pay ${_busSeatLayoutResponse?.data?.currency ?? ""} ${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Get.to(
                  BoardingDroppingScreen(
                    Seats: seatNumbers,
                    seatPrice: total.toInt(),
                    busId: widget.busId,
                    busrouteId: widget.busRouteId,
                  ),
                );
              },
              child: const Text(
                "Select Boarding & Dropping Point",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}