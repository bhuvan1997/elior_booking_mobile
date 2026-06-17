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
import 'package:elior/response_model/home_stay_respnse/homestay_suggestion_response.dart';
import 'package:elior/response_model/login_model.dart';
import 'package:elior/response_model/nearby_properties_response.dart';
import 'package:elior/response_model/property/property_search_response.dart';
import 'package:elior/response_model/reset_password_response.dart';
import 'package:elior/response_model/search_hotel_response.dart';
import 'package:elior/response_model/top_hotel_model.dart';
import 'package:elior/response_model/transport_response/proceed_model.dart';
import 'package:elior/response_model/unified_detail_model.dart';
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
import '../response_model/paysuccess_model_response.dart';
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
import 'api_constants.dart';
import 'api_services.dart';
import 'error_model.dart';

class ServiceProvider {

  // ─── Core helpers ──────────────────────────────────────────────────────────

  /// GET → parse.  Pass [showLoad] = false to skip the loader (e.g. silent bg calls).
  Future<T> _get<T>(
      String url,
      T Function(Map<String, dynamic>) fromJson,
      T fallback, {
        bool showLoad = true,
      }) async {
    if (showLoad) showLoader();
    final res = await ApiService().get(url);
    if (showLoad) hideLoader();
    if (_ok(res)) return fromJson(res.body);
    _logError(url, res.body);
    return fallback;
  }

  /// POST → parse.
  Future<T> _post<T>(
      String url,
      Map<String, dynamic> body,
      T Function(Map<String, dynamic>) fromJson,
      T fallback, {
        bool showLoad = true,
      }) async {
    if (showLoad) showLoader();
    final res = await ApiService().post(url, body);
    print(res);
    if (showLoad) hideLoader();
    if (_ok(res)) return fromJson(res.body);
    _logError(url, res.body);
    return fallback;
  }

  bool _ok(Response res) =>
      (res.statusCode == 200 || res.statusCode == 201) && res.body != null;

  void _logError(String url, dynamic body) =>
      log("❌ [$url] → $body");

  // ─── Auth ──────────────────────────────────────────────────────────────────

  Future<RegisterModel> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String mobileCode,
  }) =>
      _post(
        ApiConstants.register,
        {"name": name, "mobile": phone, "email": email, "password": password, "mobile_code": mobileCode},
        RegisterModel.fromJson,
        RegisterModel(),
      );

  Future<LoginModel> login({required String email, required String password}) =>
      _post(ApiConstants.login, {"email": email, "password": password}, LoginModel.fromJson, LoginModel());

  Future<VerifyModel> verifyOtp({required String email, required String otp}) =>
      _post(ApiConstants.verifyOtp, {"email": email, "otp": otp}, VerifyModel.fromJson, VerifyModel());

  Future<ForgotModel> forgotApi({required String email}) =>
      _post(ApiConstants.verifyEmail, {"email": email}, ForgotModel.fromJson, ForgotModel());

  Future<ResetModel> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required int id,
  }) =>
      _post(
        ApiConstants.resetPassword,
        {"new_password": newPassword, "confirm_password": confirmPassword, "id": id},
        ResetModel.fromJson,
        ResetModel(),
      );

  // ─── Hotels ────────────────────────────────────────────────────────────────

  Future<TopHotelModel> topHotelApi() =>
      _get(ApiConstants.topHotel, TopHotelModel.fromJson, TopHotelModel());

  Future<PropertySearchResponse> searchHotelApi({
    required String search,
    required String startDate,
    required String endDate,
  }) =>
      _post(
        ApiConstants.searchHotel,
        {"search": search, "start_date": startDate, "end_date": endDate},
        PropertySearchResponse.fromJson,
        PropertySearchResponse(),
      );

  Future<HotelDetailModel> detailHotelApi(int id) =>
      _get("${ApiConstants.baseUrl}/search-hotels-by-id?hotel_id=$id", HotelDetailModel.fromJson, HotelDetailModel(), showLoad: false);

  Future<FilterModel> filterHotelApi() =>
      _get("${ApiConstants.baseUrl}/get_hotel_filters_data", FilterModel.fromJson, FilterModel());

  Future<FilterModel> filterHomeStayApi() =>
      _get("${ApiConstants.baseUrl}/get_homestay_filters_data", FilterModel.fromJson, FilterModel());

  Future<SearchFilterModel> searchFilterApi({
    required String search,
    required String startDate,
    required String endDate,
    List<int>? starRatings,
    List<String>? amenities,
    List<String>? rules,
    String? pricing,
  }) =>
      _post(
        ApiConstants.searchHotelFilter,
        {
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          if (starRatings != null && starRatings.isNotEmpty) "star_ratings": starRatings,
          if (amenities != null && amenities.isNotEmpty) "amenities": amenities,
          if (rules != null && rules.isNotEmpty) "rules": rules,
          if (pricing != null && pricing.isNotEmpty) "pricing": pricing,
        },
        SearchFilterModel.fromJson,
        SearchFilterModel(),
      );

  Future<SearchSotingModel> searchSortingApi({
    required String search,
    required String startDate,
    required String endDate,
    required String sort,
  }) =>
      _post(
        ApiConstants.searchHotelSorting,
        {"search": search, "start_date": startDate, "end_date": endDate, "sort_by": sort},
        SearchSotingModel.fromJson,
        SearchSotingModel(),
      );

  Future<RoomAvailableModel> roomAvailableApi(int id, String checkIn, String checkOut) =>
      _get(
        "${ApiConstants.baseUrl}/get-hotelrooms-by-id?hotel_id=$id&checkin_date=$checkIn&checkout_date=$checkOut",
        RoomAvailableModel.fromJson,
        RoomAvailableModel(),
      );

  Future<HotelBookingModel> hotelBookingApi({
    required String hotelId,
    required String startDate,
    required String endDate,
    required String type,
    required int person,
    required int rooms,
  }) =>
      _post(
        ApiConstants.hotelRoomsBooking,
        {"hotel_id": hotelId, "checkin_date": startDate, "checkout_date": endDate, "room_type": type, "room": rooms, "person": person},
        HotelBookingModel.fromJson,
        HotelBookingModel(),
      );

  Future<BookingPaymentModel> bookingPaymentDetailApi(
      int id, String checkIn, String checkOut, String type, String roomAllot, String guest,
      ) =>
      _get(
        "${ApiConstants.baseUrl}/pay-at-hotel-by-id?hotel_id=$id&room_type=$type Room&alloted_id=$roomAllot&checkin_date=$checkIn&checkout_date=$checkOut&guest=$guest",
        BookingPaymentModel.fromJson,
        BookingPaymentModel(),
      );

  Future<BookingHistoryModel> bookingHostoryApi() =>
      _get(ApiConstants.bookingHistory, BookingHistoryModel.fromJson, BookingHistoryModel());

  Future<NearbyPropertiesResponse> getNearbyProperties() => _get(ApiConstants.getNearbyProperties, NearbyPropertiesResponse.fromJson, NearbyPropertiesResponse());

  Future<BookingHistoryDetails> bookingHistoryDetail(int id) =>
      _get("${ApiConstants.baseUrl}/get-booking-history-by-id?booking_id=$id", BookingHistoryDetails.fromJson, BookingHistoryDetails(), showLoad: false);

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
  }) =>
      _post(
        ApiConstants.finalHotelApi,
        {
          "propertyId": propertyId, "check_in_date": checkInDate, "check_out_date": checkOutDate,
          "guests": guests, "room_type": roomtype, "roomId_allotted": roomIdAllotted,
          "base_price": basePrice, "taxFee": taxFee, "discount_amount": discountAmount,
          "totalAmount": totalAmount, "payPlan": payPlan,
        },
        FInalPaymentModel.fromJson,
        FInalPaymentModel(),
      );

  // ─── Home Stay ─────────────────────────────────────────────────────────────

  Future<PropertySearchResponse> searchHomeStayApi({
    required String search,
    required String startDate,
    required String endDate,
  }) =>
      _post(
        ApiConstants.searchHomeStay,
        {"search": search, "start_date": startDate, "end_date": endDate},
        PropertySearchResponse.fromJson,
        PropertySearchResponse(),
      );

  Future<SearchFilterModel> searchFilterHomeApi({
    required String search,
    required String startDate,
    required String endDate,
    List<String>? amenities,
    List<String>? rules,
    String? pricing,
  }) =>
      _post(
        ApiConstants.searchHomeStayFilter,
        {
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          if (amenities != null && amenities.isNotEmpty) "amenities": amenities,
          if (rules != null && rules.isNotEmpty) "rules": rules,
          if (pricing != null && pricing.isNotEmpty) "pricing": pricing,
        },
        SearchFilterModel.fromJson,
        SearchFilterModel(),
      );

  Future<SearchSotingModel> searchSortingHomeApi({
    required String search,
    required String startDate,
    required String endDate,
    required String sort,
  }) =>
      _post(
        ApiConstants.searchHomeStaySorting,
        {"search": search, "start_date": startDate, "end_date": endDate, "sort_by": sort},
        SearchSotingModel.fromJson,
        SearchSotingModel(),
      );

  Future<UnifiedDetailModel> detailHomeStayApi(int id) =>
      _get("${ApiConstants.baseUrl}/search-homestay-by-id?homestay_id=$id", UnifiedDetailModel.fromJson, UnifiedDetailModel());

  Future<AccomendationModel> homeStayRoomAvailableApi(int id, String checkIn, String checkOut) =>
      _get(
        "${ApiConstants.baseUrl}/get-homestay-accomodation-by-id?homestay_id=$id&checkin_date=$checkIn&checkout_date=$checkOut",
        AccomendationModel.fromJson,
        AccomendationModel(),
      );

  Future<AccommodationBookingModel> AccomendationId({
    required String homeStayId,
    required String checkInDate,
    required String checkOutDate,
    required String accomodation,
    required int person,
  }) =>
      _post(
        ApiConstants.accomendationId,
        {"homestay_id": homeStayId, "checkin_date": checkInDate, "checkout_date": checkOutDate, "accomodation": accomodation, "person": person},
        AccommodationBookingModel.fromJson,
        AccommodationBookingModel(),
      );

  Future<HomePaymentModel> homeStayPayApi(int id, String checkIn, String checkOut) =>
      _get(
        "${ApiConstants.baseUrl}/pay-at-homestay-by-id?homestay_id=$id&checkin_date=$checkIn-08&checkout_date=$checkOut",
        HomePaymentModel.fromJson,
        HomePaymentModel(),
      );

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
  }) =>
      _post(
        ApiConstants.finalPaymentApi,
        {
          "propertyId": propertyId, "check_in_date": checkInDate, "check_out_date": checkOutDate,
          "guests": guests, "room_type": roomtype, "roomId_allotted": roomIdAllotted,
          "base_price": basePrice, "taxFee": taxFee, "discount_amount": discountAmount,
          "totalAmount": totalAmount, "payPlan": payPlan,
        },
        FInalPaymentModel.fromJson,
        FInalPaymentModel(),
      );

  Future<HomestaySuggestionResponse> fetchHomestaysSuggestions(String query) =>
      _get(ApiConstants.homestaySuggestions(query), HomestaySuggestionResponse.fromJson, HomestaySuggestionResponse(), showLoad: false);

  // ─── Transport / Bus ───────────────────────────────────────────────────────

  Future<BusRouteModel> busRouteApi({
    required String origin,
    required String destination,
    required String journeyDate,
  }) =>
      _post(
        ApiConstants.searchBusRoute,
        {"origin": origin, "destination": destination, "journey_date": journeyDate},
        BusRouteModel.fromJson,
        BusRouteModel(),
      );

  Future<BusSeatModel> busSeatApi({required int busId, required int busRouteId}) =>
      _get("${ApiConstants.baseUrl}/bus-seat-selection?bus_id=$busId&bus_route_id=$busRouteId", BusSeatModel.fromJson, BusSeatModel());

  Future<BusSeatBottomModel> busSeatBottomDetailApi({required int busId, required int busRouteId}) =>
      _get("${ApiConstants.baseUrl}/bus-seat-selection-details?bus_id=$busId&bus_route_id=$busRouteId", BusSeatBottomModel.fromJson, BusSeatBottomModel());

  Future<BusPikUpModel> busSeatPickupApi({required int busId, required int busRouteId}) =>
      _get("${ApiConstants.baseUrl}/bus-selection-pickup-points?bus_id=$busId&bus_route_id=$busRouteId", BusPikUpModel.fromJson, BusPikUpModel());

  Future<ProceedModel> proceedApi({
    required String seats,
    required int busId,
    required int busRouteId,
    required int BoardingPointId,
    required int droppingPointId,
    required int SeatPrice,
  }) =>
      _post(
        ApiConstants.proceedApi,
        {
          "bus_id": busId, "bus_route_id": busRouteId,
          "boarding_point_id": BoardingPointId, "dropping_point_id": droppingPointId,
          "seats": seats, "seats_price": SeatPrice,
        },
        ProceedModel.fromJson,
        ProceedModel(),
      );

  /// Uses raw http because it sends a JSON list in the body (GetConnect encodes maps only).
  Future<Map<String, dynamic>> proceedPayNowSeatBooking({
    required int busId,
    required int busRouteId,
    required int boardingPointId,
    required int droppingPointId,
    required List<String> seats,
    required int seatsPrice,
    required List<Map<String, dynamic>> passengerData,
  }) async {
    final body = {
      "bus_id": busId, "bus_route_id": busRouteId,
      "boarding_point_id": boardingPointId, "dropping_point_id": droppingPointId,
      "seats": seats.join(','), "seats_price": seatsPrice,
      "passenger_data": passengerData,
    };
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/proceed-pay-now-seat-booking"),
      headers: {"Authorization": "Bearer ${LocalStorages().getToken() ?? ""}", "Accept": "application/json", "Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("❌ [proceedPayNowSeatBooking] ${response.statusCode}: ${response.body}");
  }

  Future<BusHistoryModel> busHostoryApi() =>
      _get(ApiConstants.busHistory, BusHistoryModel.fromJson, BusHistoryModel());

  Future<BusIicketHistoryModel> busTicketHistoryDetail(int id) =>
      _get("${ApiConstants.baseUrl}/get-bus-booking-history-by-id?booking_id=$id", BusIicketHistoryModel.fromJson, BusIicketHistoryModel(), showLoad: false);

  // ─── Trips & Travel blogs ──────────────────────────────────────────────────

  Future<TripModel> tripApi() =>
      _get(ApiConstants.tripApi, TripModel.fromJson, TripModel());

  Future<TripModel> tripApiUnauth() =>
      _get(ApiConstants.tripApiUnauthenticated, TripModel.fromJson, TripModel(), showLoad: false);

  Future<TripModel> ViewtripApi() =>
      _get(ApiConstants.ViewAlltripApi, TripModel.fromJson, TripModel());

  Future<HotelDetailModel> tripDetailHotelApi(int id) =>
      _get("${ApiConstants.baseUrl}/get-property-details?property_id=$id", HotelDetailModel.fromJson, HotelDetailModel());

  Future<TravelVlogsModel> TraveltripApi() =>
      _get(ApiConstants.traveltripApi, TravelVlogsModel.fromJson, TravelVlogsModel());

  Future<TravelVlogsModel> travelTripApiUN() =>
      _get(ApiConstants.travelTripApiUnAuth, TravelVlogsModel.fromJson, TravelVlogsModel(), showLoad: false);

  Future<TravelVlogsModel> TravelViewtripApi() =>
      _get(ApiConstants.travelViewAllTripApi, TravelVlogsModel.fromJson, TravelVlogsModel());

  // ─── Favourites ────────────────────────────────────────────────────────────

  Future<TripModel> favApi() =>
      _get(ApiConstants.favApi, TripModel.fromJson, TripModel());

  Future<GetFavModel> getFavProperty() =>
      _get(ApiConstants.getMyFav, GetFavModel.fromJson, GetFavModel());

  Future<SelectFaModel> selectFavProperty({required int propertyId}) =>
      _post(ApiConstants.selectMyFav, {"property_id": propertyId}, SelectFaModel.fromJson, SelectFaModel());

  Future<SelectFaModel> removeFavProperty({required int propertyId}) =>
      _post(ApiConstants.removeFav, {"property_id": propertyId}, SelectFaModel.fromJson, SelectFaModel());

  // ─── Reviews ──────────────────────────────────────────────────────────────

  Future<ReviewModel> review({
    required int bookingId,
    required int starRating,
    required String title,
    required String review,
  }) =>
      _post(
        ApiConstants.review,
        {"booking_id": bookingId, "star_rating": starRating, "title": title, "review": review},
        ReviewModel.fromJson,
        ReviewModel(),
        showLoad: false,
      );

  Future<ReviewModel> busReview({
    required int bookingId,
    required int starRating,
    required String title,
    required String review,
  }) =>
      _post(
        ApiConstants.busReview,
        {"booking_id": bookingId, "star_rating": starRating, "title": title, "review": review},
        ReviewModel.fromJson,
        ReviewModel(),
        showLoad: false,
      );

  // ─── Payments ──────────────────────────────────────────────────────────────

  Future<PaymentInitiatedModel> paymentInitiated({required int type, required int bookingId}) =>
      _get("${ApiConstants.baseUrl}/pay/kkiapay/$type/$bookingId", PaymentInitiatedModel.fromJson, PaymentInitiatedModel());

  Future<PaySuccessModel> paymentSuccess({required String transactionId}) =>
      _get("${ApiConstants.baseUrl}/pay/verifyPaymentKkiapay/$transactionId", PaySuccessModel.fromJson, PaySuccessModel());

  // ─── Profile ───────────────────────────────────────────────────────────────

  Future<NotificationModel> getNotification() =>
      _get(ApiConstants.getMyNotification, NotificationModel.fromJson, NotificationModel());

  // ─── Hotel suggestions (raw http, returns a list not a map) ───────────────

  Future<List<HotelSuggestion>> fetchHotelSuggestions(String query) async {
    if (query.isEmpty) return [];
    final response = await http.get(Uri.parse("${ApiConstants.baseUrl}/search/hotel-suggestions?q=$query"));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((e) => HotelSuggestion.fromJson(e)).toList();
    }
    return [];
  }

  // ─── UI helpers ────────────────────────────────────────────────────────────

  void showLoader() {
    if (Get.isDialogOpen ?? false) return;
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
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(image: AssetImage(AssetsScreen.eliorAppLogo), width: 60, height: 60),
                  ),
                  const SizedBox(height: 16),
                  CircularProgressIndicator(color: AppTheme.appThemeColor, strokeWidth: 3),
                  const SizedBox(height: 16),
                  Text("Loading...", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
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

  void hideLoader() {
    if (Get.isDialogOpen ?? false) {
      Navigator.of(Get.context!, rootNavigator: true).pop();
    }
  }

  void snackBarMessage({required String message, required String head, Color? color, bool isError = true}) {
    Get.snackbar(head, message,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      borderRadius: 20,
      margin: const EdgeInsets.all(20),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
  }

  // kept for backwards-compat but no longer used inside this class
  Response? checkResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
      case 401:
      case 404:
      case 409:
      case 422:
        snackBarMessage(message: ErrorModel.fromJson(response.body).message ?? "Something went wrong", head: "Error");
        return null;
      default:
        snackBarMessage(message: "Check Internet Connection", head: "Error");
        return null;
    }
  }
}