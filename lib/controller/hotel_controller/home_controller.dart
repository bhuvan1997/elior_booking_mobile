import 'package:elior/response_model/search_hotel_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../network/service_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../response_model/hotel_suggestion_model.dart';
class HomeController extends GetxController {
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
      searchHotelModel = await ServiceProvider().searchHotelApi(
        search: searchLocation.text.trim(),
        startDate: formatDate(checkInDate),
        endDate: formatDate(checkOutDate),
        // person: guestsCount,
        // rooms: roomsCount,
      );
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  List<HotelSuggestion> suggestions = [];
  bool isSuggestionLoading = false;
  Timer? debounce;

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      update();
      return;
    }

    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        isSuggestionLoading = true;
        update();

        final response = await http.get(
          Uri.parse(
              "https://eliorbooking.com/api/search/hotel-suggestions?q=$query"),
        );

        if (response.statusCode == 200) {
          List data = jsonDecode(response.body);
          suggestions =
              data.map((e) => HotelSuggestion.fromJson(e)).toList();
        } else {
          suggestions = [];
        }
      } catch (e) {
        suggestions = [];
      }

      isSuggestionLoading = false;
      update();
    });
  }
}
