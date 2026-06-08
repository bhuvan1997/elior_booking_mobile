import 'package:elior/response_model/search_hotel_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../network/service_provider.dart';
import '../../response_model/home_stay_respnse/search_homeStay_model.dart';

class HomeStayController extends GetxController {
  SearchHotelModel searchHotelModel = SearchHotelModel();
  TextEditingController searchLocation = TextEditingController();
  DateTime? checkInDate;
  DateTime? checkOutDate;

  int guestsCount = 1;
  int roomsCount = 1;

  // Format date
  String formatDate(DateTime? date) {
    if (date == null) return 'yyyy-MM-dd';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future searchHotel() async {
    try {
      searchHotelModel = await ServiceProvider().searchHomeStayApi(
        search: searchLocation.text.trim(),
        startDate: formatDate(checkInDate),
        endDate: formatDate(checkOutDate),

      );
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
