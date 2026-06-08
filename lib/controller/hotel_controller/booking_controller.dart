import 'package:elior/response_model/booking_history_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/service_provider.dart';
import 'package:translator/translator.dart';
class BookingHistoryController extends GetxController{
  BookingHistoryModel bookingHistoryModel = BookingHistoryModel();
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchBookingHotels();
    });
    super.onInit();
  }


  final translator = GoogleTranslator();

  Future<String> translateText(String text, String locale) async {
    var translation = await translator.translate(text, to: locale);
    return translation.text;
  }
  Future<void> fetchBookingHotels() async {
    try {
      bookingHistoryModel = await ServiceProvider().bookingHostoryApi();
    } catch (e) {
      debugPrint('Statelistdata error: $e');
    }
  }
}