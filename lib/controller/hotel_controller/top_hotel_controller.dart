import 'package:elior/response_model/top_hotel_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../network/service_provider.dart';

class TopHotelController extends GetxController {
  TopHotelModel topHotelModel = TopHotelModel();

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // fetchHotels();
    });
    super.onInit();
  }

  Future<void> fetchHotels() async {

    try {
      topHotelModel = await ServiceProvider().topHotelApi();
    } catch (e) {
      debugPrint('Statelistdata error: $e');
    }

  }
}
