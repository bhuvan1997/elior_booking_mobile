import 'package:elior/response_model/get_all_coupons_response.dart';
import 'package:elior/response_model/home_stay_respnse/budget_firendly_homestay_response.dart';
import 'package:elior/response_model/nearby_properties_response.dart';
import 'package:elior/response_model/top_hotel_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../network/service_provider.dart';

class TopHotelController extends GetxController {
  TopHotelModel topHotelModel = TopHotelModel();
  NearbyPropertiesResponse nearbyProperties = NearbyPropertiesResponse();
  CouponResponse couponResponse = CouponResponse();
  BudgetFriendlyHomestaysResponse budgetFriendlyHomestays = BudgetFriendlyHomestaysResponse();

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // fetchHotels();
      fetchNearby();
      fetchAllCoupons();
      budgetHomeStays();
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

  Future<void> fetchNearby() async {
    try {
      nearbyProperties = await ServiceProvider().getNearbyProperties();
    } catch (e) {
      debugPrint('Statelistdata error: $e');
    }
  }

  Future<void> fetchAllCoupons() async {
    try {
      couponResponse = await ServiceProvider().fetchAllCoupons();
    } catch (e) {
      debugPrint('Statelistdata error: $e');
    }
  }


  Future<void> budgetHomeStays() async {
    try {
      budgetFriendlyHomestays = await ServiceProvider().getBudgetFriendlyHomestays();
    } catch (e) {
      debugPrint('Statelistdata error: $e');
    }
  }


}
