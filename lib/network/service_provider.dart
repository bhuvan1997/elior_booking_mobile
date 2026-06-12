import 'dart:convert';
import 'dart:developer';

import 'package:elior/app_values/app_theme.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/response_model/booking_history_details.dart';
import 'package:elior/response_model/booking_history_response.dart';
import 'package:elior/response_model/bus_seat_model.dart';
import 'package:elior/response_model/fav_model/add_fav_moodel.dart';
import 'package:elior/response_model/fav_model/get_fav_model.dart';
import 'package:elior/response_model/final_payment_model/final_payment_model.dart';
import 'package:elior/response_model/final_payment_model/payment_initiated_model.dart';
import 'package:elior/response_model/forgot_model_response.dart';
import 'package:elior/response_model/login_model.dart';
import 'package:elior/response_model/reset_password_response.dart';
import 'package:elior/response_model/search_hotel_response.dart';
import 'package:elior/response_model/top_hotel_model.dart';
import 'package:elior/response_model/transport_response/proceed_model.dart';
import 'package:elior/response_model/verify_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../response_model/booking_payment_detail_response.dart';
import '../response_model/bus_history_model.dart';
import '../response_model/bus_ticket_history_model.dart';
import '../response_model/filter_model.dart';
import '../response_model/home_stay_respnse/accomendation_booking_screen.dart';
import '../response_model/home_stay_respnse/accomendation_response.dart';
import '../response_model/home_stay_respnse/homestay_detail_model.dart';
import '../response_model/home_stay_respnse/homestay_payment_model.dart';
import '../response_model/hotel_booking_response.dart';
import '../response_model/hotel_detail_response.dart';
import '../response_model/hotel_suggestion_model.dart';
import '../response_model/notification_model.dart';
import '../response_model/paysuccess_model_response.dart' show PaySuccessModel;
import '../response_model/register_model.dart';
import '../response_model/review_model.dart';
import '../response_model/room_available_response.dart';
import '../response_model/search_filter_model.dart';
import '../response_model/search_sorting_model.dart';
import '../response_model/transport_response/bus_route_response.dart';
import '../response_model/transport_response/bus_seat_botttom_model.dart';
import '../response_model/transport_response/pickup_model.dart';
import '../response_model/trip_model/travel_vlogs.dart';
import '../response_model/trip_model/tripModel.dart';
import '../utils/storage.dart';
import '../utils/translator_service.dart';
import 'api_constants.dart';
import 'api_services.dart';
import 'error_model.dart';

class ServiceProvider {
  final TranslationService _translationService = TranslationService();

  Future<RegisterModel> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String mobileCode,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.register, {
      "name": name,
      "mobile": phone,
      "email": email,
      "password": password,
      "mobile_code": mobileCode,
    });

    hideLoader();
    final result = checkResponse(response);

    if (result != null && result.body != null) {
      return RegisterModel.fromJson(result.body);
    } else {
      print("❌Register failed: ${response.body}");
      return RegisterModel();
    }
  }

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.login, {
      "email": email,
      "password": password,
    });

    hideLoader();
    final result = checkResponse(response);

    if (result != null && result.body != null) {
      return LoginModel.fromJson(result.body);
    } else {
      log("❌ Login failed: ${response.body}");
      return LoginModel();
    }
  }

  Future<ForgotModel> forgotApi({required String email}) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.verifyEmail, {
      "email": email,
    });

    hideLoader();
    final result = checkResponse(response);

    if (result != null && result.body != null) {
      return ForgotModel.fromJson(result.body);
    } else {
      log("❌ Login failed: ${response.body}");
      return ForgotModel();
    }
  }

  Future<ResetModel> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required int id,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.resetPassword, {
      "new_password": newPassword,
      "confirm_password": confirmPassword,
      "id": id,
    });

    hideLoader();
    final result = checkResponse(response);

    if (result != null && result.body != null) {
      return ResetModel.fromJson(result.body);
    } else {
      log("❌ Login failed: ${response.body}");
      return ResetModel();
    }
  }

  Future<VerifyModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.verifyOtp, {
      "email": email,
      "otp": otp,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return VerifyModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return VerifyModel();
    }
  }

  Future<TopHotelModel> topHotelApi() async {
    showLoader();

    final response = await ApiService().get(
      ApiConstants.topHotel,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return TopHotelModel.fromJson(response.body);
    } else {
      return TopHotelModel();
    }
  }

  Future<SearchHotelModel> searchHotelApi({
    required String search,
    required String startDate,
    required String endDate,
    // required int person,
    // required int rooms,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.searchHotel, {
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
      // "person": person,
      // "rooms": rooms,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return SearchHotelModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return SearchHotelModel();
    }
  }

  Future<HotelDetailModel> detailHotelApi(int id) async {
    // showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/search-hotels-by-id?hotel_id=$id",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    // hideLoader();
    if (checkResponse(response) != null) {
      return HotelDetailModel.fromJson(response.body);
    } else {
      return HotelDetailModel();
    }
  }

  Future<FilterModel> filterHotelApi() async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/get_hotel_filters_data",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return FilterModel.fromJson(response.body);
    } else {
      return FilterModel();
    }
  }

  Future<FilterModel> filterHomeStayApi() async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/get_homestay_filters_data",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return FilterModel.fromJson(response.body);
    } else {
      return FilterModel();
    }
  }

  Future<SearchFilterModel> searchFilterApi({
    required String search,
    required String startDate,
    required String endDate,
    List<int>? starRatings,
    List<String>? amenities,
    List<String>? rules,
    String? pricing,
  }) async {
    showLoader();

    final Map<String, dynamic> body = {
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
    };

    if (starRatings != null && starRatings.isNotEmpty) {
      body["star_ratings"] = starRatings;
    }
    if (amenities != null && amenities.isNotEmpty) {
      body["amenities"] = amenities;
    }
    if (rules != null && rules.isNotEmpty) {
      body["rules"] = rules;
    }
    if (pricing != null && pricing.isNotEmpty) {
      body["pricing"] = pricing;
    }

    final response = await ApiService().post(
      ApiConstants.searchHotelFilter,
      body,
    );

    hideLoader();

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.body != null) {
      return SearchFilterModel.fromJson(response.body);
    } else {
      print("❌ Search Filter failed: ${response.body}");
      return SearchFilterModel();
    }
  }

  Future<SearchSotingModel> searchSortingApi({
    required String search,
    required String startDate,
    required String endDate,
    required String sort,
  }) async {
    showLoader();

    final Map<String, dynamic> body = {
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
      "sort_by": sort,
    };

    final response = await ApiService().post(
      ApiConstants.searchHotelSorting,
      body,
    );

    hideLoader();

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.body != null) {
      return SearchSotingModel.fromJson(response.body);
    } else {
      print("❌ Search Filter failed: ${response.body}");
      return SearchSotingModel();
    }
  }

  Future<SearchFilterModel> searchFilterHomeApi({
    required String search,
    required String startDate,
    required String endDate,
    // List<int>? starRatings,
    List<String>? amenities,
    List<String>? rules,
    String? pricing,
  }) async {
    showLoader();

    final Map<String, dynamic> body = {
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
    };

    // if (starRatings != null && starRatings.isNotEmpty) {
    //   body["star_ratings"] = starRatings;
    // }
    if (amenities != null && amenities.isNotEmpty) {
      body["amenities"] = amenities;
    }
    if (rules != null && rules.isNotEmpty) {
      body["rules"] = rules;
    }
    if (pricing != null && pricing.isNotEmpty) {
      body["pricing"] = pricing;
    }

    final response = await ApiService().post(
      ApiConstants.searchHomeStayFilter,
      body,
    );

    hideLoader();

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.body != null) {
      return SearchFilterModel.fromJson(response.body);
    } else {
      print("❌ Search Filter failed: ${response.body}");
      return SearchFilterModel();
    }
  }

  Future<SearchSotingModel> searchSortingHomeApi({
    required String search,
    required String startDate,
    required String endDate,
    required String sort,
  }) async {
    showLoader();

    final Map<String, dynamic> body = {
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
      "sort_by": sort,
    };

    final response = await ApiService().post(
      ApiConstants.searchHomeStaySorting,
      body,
    );

    hideLoader();

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.body != null) {
      return SearchSotingModel.fromJson(response.body);
    } else {
      print("❌ Search Filter failed: ${response.body}");
      return SearchSotingModel();
    }
  }

  Future<RoomAvailableModel> roomAvailableApi(
    int id,
    String checkIn,
    String checkOut,
  ) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/get-hotelrooms-by-id?hotel_id=$id&checkin_date=$checkIn&checkout_date=$checkOut",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return RoomAvailableModel.fromJson(response.body);
    } else {
      return RoomAvailableModel();
    }
  }

  Future<RoomBookingModel> hotelBookingApi({
    required String hotelId,
    required String startDate,
    required String endDate,
    required String type,
    required int person,
    required int rooms,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.hotelRoomsBooking, {
      "hotel_id": hotelId,
      "checkin_date": startDate,
      "checkout_date": endDate,
      "room_type": type,
      "room": rooms,
      "person": person,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return RoomBookingModel.fromJson(response.body);
    } else {
      print("❌ failed: ${response.body}");
      return RoomBookingModel();
    }
  }

  Future<BookingPaymentModel> bookingPaymentDetailApi(
    int id,
    String checkIn,
    String checkOut,
    String type,
    String roomAllot,
    String guest,
  ) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/pay-at-hotel-by-id?hotel_id=$id&room_type=$type Room&alloted_id=$roomAllot&checkin_date=$checkIn&checkout_date=$checkOut&guest=$guest",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return BookingPaymentModel.fromJson(response.body);
    } else {
      return BookingPaymentModel(); // fallback
    }
  }

  Future<BookingHistoryModel> bookingHostoryApi() async {
    showLoader();

    final response = await ApiService().get(
      ApiConstants.bookingHistory,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return BookingHistoryModel.fromJson(response.body);
    } else {
      return BookingHistoryModel(); // fallback
    }
  }

  Future<BusHistoryModel> busHostoryApi() async {
    showLoader();

    final response = await ApiService().get(
      ApiConstants.busHistory,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return BusHistoryModel.fromJson(response.body);
    } else {
      return BusHistoryModel(); // fallback
    }
  }

  Future<TripModel> tripApi() async {
    showLoader();

    final response = await ApiService().get(
      ApiConstants.tripApi,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return TripModel.fromJson(response.body);
    } else {
      return TripModel(); // fallback
    }
  }

  Future<TripModel> tripApiUnauth() async {
    // showLoader();

    final response = await ApiService().get(
      ApiConstants.tripApiUnauthenticated,
      headers: {
        // "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    // hideLoader();
    if (checkResponse(response) != null) {
      return TripModel.fromJson(response.body);
    } else {
      return TripModel(); // fallback
    }
  }

  Future<TripModel> favApi() async {
    showLoader();

    final response = await ApiService().get(
      ApiConstants.favApi,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return TripModel.fromJson(response.body);
    } else {
      return TripModel(); // fallback
    }
  }

  Future<TripModel> ViewtripApi() async {
    showLoader();

    final response = await ApiService().get(
      ApiConstants.ViewAlltripApi,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return TripModel.fromJson(response.body);
    } else {
      return TripModel(); // fallback
    }
  }

  /// HOME STAY API
  Future<SearchHotelModel> searchHomeStayApi({
    required String search,
    required String startDate,
    required String endDate,
    // required int person,
    // required int rooms,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.searchHomeStay, {
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
      // "person": person,
      // "rooms": rooms,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return SearchHotelModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return SearchHotelModel();
    }
  }

  Future<HomeStayDetailModel> detailHomeStayApi(int id) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/search-homestay-by-id?homestay_id=$id",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return HomeStayDetailModel.fromJson(response.body);
    } else {
      return HomeStayDetailModel();
    }
  }

  Future<AccomendationModel> homeStayRoomAvailableApi(
    int id,
    String checkIn,
    String checkOut,
  ) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/get-homestay-accomodation-by-id?homestay_id=$id&checkin_date=$checkIn&checkout_date=$checkOut",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return AccomendationModel.fromJson(response.body);
    } else {
      return AccomendationModel();
    }
  }

  Future<AccomendationBookingModel> AccomendationId({
    required String homeStayId,
    required String checkInDate,
    required String checkOutDate,
    required String accomodation,
    required int person,
    // required int rooms,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.accomendationId, {
      "homestay_id": homeStayId,
      "checkin_date": checkInDate,
      "checkout_date": checkOutDate,
      "accomodation": accomodation,
      "person": person,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return AccomendationBookingModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return AccomendationBookingModel();
    }
  }

  Future<HomePaymentModel> homeStayPayApi(
    int id,
    String checkIn,
    String checkOut,
  ) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/pay-at-homestay-by-id?homestay_id=$id&checkin_date=$checkIn-08&checkout_date=$checkOut",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return HomePaymentModel.fromJson(response.body);
    } else {
      return HomePaymentModel();
    }
  }
  Future<List<HotelSuggestion>> fetchHotelSuggestions(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse(
          "https://eliorbooking.com/api/search/hotel-suggestions?q=$query"),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .map((e) => HotelSuggestion.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load suggestions");
    }
  }
  // Future<RoomBookingModel> homeStayBookingApi({
  //   required String homeStayId,
  //   required String startDate,
  //   required String endDate,
  //   required String type,
  //   required int person,
  //   required int rooms,
  // }) async {
  //   showLoader();
  //
  //   final response = await ApiService().post(ApiConstants.bookHomeStayRoom, {
  //     "homestay_id": homeStayId,
  //     "checkin_date": startDate,
  //     "checkout_date": endDate,
  //     "room_type": type,
  //     "room": rooms,
  //     "person": person,
  //   });
  //
  //   hideLoader();
  //
  //   if (response.statusCode == 200 ||
  //       response.statusCode == 201 && response.body != null) {
  //     return RoomBookingModel.fromJson(response.body);
  //   } else {
  //     print("❌ failed: ${response.body}");
  //     return RoomBookingModel();
  //   }
  // }

  Future<BusRouteModel> busRouteApi({
    required String origin,
    required String destination,
    required String journeyDate,
    // required int person,
    // required int rooms,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.searchBusRoute, {
      "origin": origin,
      "destination": destination,
      "journey_date": journeyDate,
      // "person": person,
      // "rooms": rooms,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return BusRouteModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return BusRouteModel();
    }
  }

  Future<HotelDetailModel> tripDetailHotelApi(int id) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/get-property-details?property_id=$id",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return HotelDetailModel.fromJson(response.body);
    } else {
      return HotelDetailModel();
    }
  }

  Future<TravelVlogsModel> TraveltripApi() async {
    showLoader();

    final response = await ApiService().get(
      ApiConstants.traveltripApi,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return TravelVlogsModel.fromJson(response.body);
    } else {
      return TravelVlogsModel(); // fallback
    }
  }

  Future<TravelVlogsModel> travelTripApiUN() async {
    // showLoader();

    final response = await ApiService().get(
      ApiConstants.travelTripApiUnAuth,
      headers: {
        // "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    // hideLoader();
    if (checkResponse(response) != null) {
      return TravelVlogsModel.fromJson(response.body);
    } else {
      return TravelVlogsModel(); // fallback
    }
  }

  Future<TravelVlogsModel> TravelViewtripApi() async {
    showLoader();

    final response = await ApiService().get(
      ApiConstants.travelViewAllTripApi,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return TravelVlogsModel.fromJson(response.body);
    } else {
      return TravelVlogsModel(); // fallback
    }
  }

  Future<BusSeatModel> busSeatApi({
    required int busId,
    required int busRouteId,
  }) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/bus-seat-selection?bus_id=$busId&bus_route_id=$busRouteId",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return BusSeatModel.fromJson(response.body);
    } else {
      return BusSeatModel(); // fallback
    }
  }

  Future<BusSeatBottomModel> busSeatBottomDetailApi({
    required int busId,
    required int busRouteId,
  }) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/bus-seat-selection-details?bus_id=$busId&bus_route_id=$busRouteId",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return BusSeatBottomModel.fromJson(response.body);
    } else {
      return BusSeatBottomModel(); // fallback
    }
  }

  Future<BusPikUpModel> busSeatPickupApi({
    required int busId,
    required int busRouteId,
  }) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/bus-selection-pickup-points?bus_id=$busId&bus_route_id=$busRouteId",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return BusPikUpModel.fromJson(response.body);
    } else {
      return BusPikUpModel(); // fallback
    }
  }

  Future<ProceedModel> proceedApi({
    required String seats,
    required int busId,
    required int busRouteId,
    required int BoardingPointId,
    required int droppingPointId,
    required int SeatPrice,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.proceedApi, {
      "bus_id": busId,
      "bus_route_id": busRouteId,
      "boarding_point_id": BoardingPointId,
      "dropping_point_id": droppingPointId,
      "seats": seats,
      "seats_price": SeatPrice,
      // "person": person,
      // "rooms": rooms,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return ProceedModel.fromJson(response.body);
    } else {
      print("❌ proceed failed: ${response.body}");
      return ProceedModel();
    }
  }

  Future<Map<String, dynamic>> proceedPayNowSeatBooking({
    required int busId,
    required int busRouteId,
    required int boardingPointId,
    required int droppingPointId,
    required List<String> seats,
    required int seatsPrice,
    required List<Map<String, dynamic>> passengerData,
  }) async {
    final url = Uri.parse(
      'https://eliorbooking.com/api/proceed-pay-now-seat-booking',
    );

    final body = {
      "bus_id": busId,
      "bus_route_id": busRouteId,
      "boarding_point_id": boardingPointId,
      "dropping_point_id": droppingPointId,
      "seats": seats.join(','),
      "seats_price": seatsPrice,
      "passenger_data": passengerData,
    };

    log("📤 ProceedPayNow Request: ${jsonEncode(body)}");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
        "Content-Type": "application/json", // ✅ Important!
      },
      body: jsonEncode(body),
    );

    log("📥 ProceedPayNow Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("❌ Failed [${response.statusCode}]: ${response.body}");
    }
  }

  Future<FInalPaymentModel> payFinalPaymentApi({
    required String propertyId,
    required String checkInDate,
    required String checkOutDate,
    required String guests,
    required String roomtype,
    required String roomIdAllotted,
    required int basePrice,
    required int taxFee,
    required int discountAmount,
    required int totalAmount,
    required String payPlan,
  }) async {
    showLoader();
    final response = await ApiService().post(ApiConstants.finalPaymentApi, {
      "propertyId": propertyId,
      "check_in_date": checkInDate,
      "check_out_date": checkOutDate,
      "guests": guests,
      "room_type": roomtype,
      "roomId_allotted": roomIdAllotted,
      "base_price": basePrice,
      "taxFee": taxFee,
      "discount_amount": discountAmount,
      "totalAmount": totalAmount,
      "payPlan": payPlan,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return FInalPaymentModel.fromJson(response.body);
    } else {
      print("❌PaymentFailed: ${response.body}");
      return FInalPaymentModel();
    }
  }
Future<FInalPaymentModel> payFinalHotelPaymentApi({
    required String propertyId,
    required String checkInDate,
    required String checkOutDate,
    required String guests,
    required String roomtype,
    required String roomIdAllotted,
    required int basePrice,
    required int taxFee,
    required int discountAmount,
    required int totalAmount,
    required String payPlan,
  }) async {
    showLoader();
    final response = await ApiService().post(ApiConstants.finalHotelApi, {
      "propertyId": propertyId,
      "check_in_date": checkInDate,
      "check_out_date": checkOutDate,
      "guests": guests,
      "room_type": roomtype,
      "roomId_allotted": roomIdAllotted,
      "base_price": basePrice,
      "taxFee": taxFee,
      "discount_amount": discountAmount,
      "totalAmount": totalAmount,
      "payPlan": payPlan,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return FInalPaymentModel.fromJson(response.body);
    } else {
      print("❌PaymentFailed: ${response.body}");
      return FInalPaymentModel();
    }
  }

  Future<PaymentInitiatedModel> paymentInitiated({
    required int type,
    required int bookingId,
  }) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/pay/kkiapay/$type/$bookingId",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return PaymentInitiatedModel.fromJson(response.body);
    } else {
      return PaymentInitiatedModel(); // fallback
    }
  }

  Future<PaySuccessModel> paymentSuccess({
    required String transactionId,
  }) async {
    showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/pay/verifyPaymentKkiapay/$transactionId",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    hideLoader();
    if (checkResponse(response) != null) {
      return PaySuccessModel.fromJson(response.body);
    } else {
      return PaySuccessModel(); // fallback
    }
  }

  Future<SelectFaModel> selectFavProperty({
    required int propertyId,

    // required int rooms,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.selectMyFav, {
      "property_id": propertyId,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return SelectFaModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return SelectFaModel();
    }
  }

  Future<SelectFaModel> removeFavProperty({
    required int propertyId,

    // required int rooms,
  }) async {
    showLoader();

    final response = await ApiService().post(ApiConstants.removeFav, {
      "property_id": propertyId,
    });

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return SelectFaModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return SelectFaModel();
    }
  }

  Future<GetFavModel> getFavProperty() async {
    showLoader();

    final response = await ApiService().get(ApiConstants.getMyFav);

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return GetFavModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return GetFavModel();
    }
  }
  Future<NotificationModel> getNotification() async {
    showLoader();

    final response = await ApiService().get(ApiConstants.getMyNotification);

    hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return NotificationModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return NotificationModel();
    }
  }

  Future<BookingHistoryDetails> bookingHistoryDetail(int id) async {
    // showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/get-booking-history-by-id?booking_id=$id",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    // hideLoader();
    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return BookingHistoryDetails.fromJson(response.body);
    } else {
      return BookingHistoryDetails();
    }
  }

  Future<BusIicketHistoryModel> busTicketHistoryDetail(int id) async {
    // showLoader();

    final response = await ApiService().get(
      "https://eliorbooking.com/api/get-bus-booking-history-by-id?booking_id=$id",
      headers: {
        "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
        "Accept": "application/json",
      },
    );
    // hideLoader();
    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return BusIicketHistoryModel.fromJson(response.body);
    } else {
      return BusIicketHistoryModel();
    }
  }

  Future<ReviewModel> review({
    required int bookingId,
    required int starRating,
    required String title,
    required String review,

    // required int rooms,
  }) async {
    // showLoader();

    final response = await ApiService().post(ApiConstants.review, {
      "booking_id": bookingId,
      "star_rating": starRating,
      "title": title,
      "review": review,
    });

    // hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return ReviewModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return ReviewModel();
    }
  }
 Future<ReviewModel> busReview({
    required int bookingId,
    required int starRating,
    required String title,
    required String review,

    // required int rooms,
  }) async {
    // showLoader();

    final response = await ApiService().post(ApiConstants.busReview, {
      "booking_id": bookingId,
      "star_rating": starRating,
      "title": title,
      "review": review,
    });

    // hideLoader();

    if (response.statusCode == 200 ||
        response.statusCode == 201 && response.body != null) {
      return ReviewModel.fromJson(response.body);
    } else {
      print("❌ Otp failed: ${response.body}");
      return ReviewModel();
    }
  }

  snackBarMessage({
    required String message,
    required String head,
    Color? color,
    bool isError = true,
  }) {
    return Get.snackbar(
      head,
      message,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      borderRadius: 20,
      margin: const EdgeInsets.all(20),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
  }

  void showLoader() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image(image: AssetImage(AssetsScreen.eliorAppLogo), width: 60, height: 60,)),
                  const SizedBox(height: 16),
                  CircularProgressIndicator(
                    color: AppTheme.appThemeColor,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading...",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black45,
    );
  }

  hideLoader() {
    Navigator.of(Get.context!, rootNavigator: true).pop('dialog');
  }

  successSnackBarMessage({required String message, required String head}) {
    return Get.snackbar(
      head,
      message,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      borderRadius: 20,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.green,
    );
  }

  Response? checkResponse(Response response) {
    log("RESPONSE :${response.body}");
    final errorModel = ErrorModel.fromJson(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        // successSnackBarMessage(
        //   message: errorModel.message ?? "Success",
        //   head: "Success",
        // );
        return response;

      case 400:
      case 401:
      case 404:
      case 409:
      case 422:
        snackBarMessage(
          message: errorModel.message ?? "Something went wrong",
          head: "Error",
        );
        return null;

      default:
        snackBarMessage(message: "Check Internet Connection", head: "Error");
        return null;
    }
  }
}
