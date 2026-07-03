class ApiConstants {
  static const baseUrl = "https://eliorbooking.com/api";
  static const register = '$baseUrl/register';
  static const login = '$baseUrl/login';
  static const verifyOtp = '$baseUrl/verify-otp';
  static const topHotel = '$baseUrl/hotels';
  static const searchHotel = '$baseUrl/search-hotels';
  static const hotelRoomsBooking = '$baseUrl/book-hotelrooms-by-id';
  static const bookingHistory = '$baseUrl/get-booking-history';
  static const busHistory = '$baseUrl/get-bus-booking-history';
  static const verifyEmail = '$baseUrl/verify-email';
  static const resetPassword = '$baseUrl/reset-password';
  static const searchHomeStay = '$baseUrl/search-homestay';
  static String homestaySuggestions(String query) => '$baseUrl/search/homestay-suggestions?q=$query';
  static const bookHomeStayRoom =
      'https://eliorbooking.com/api/book-homestayrooms-by-id';
  static const searchBusRoute = '$baseUrl/search-bus-route';
  static const tripApi = '$baseUrl/top-rated-hotels';
  static const tripApiUnauthenticated = '$baseUrl/top-rated-hotels-unauthenticated';
  static const favApi = '$baseUrl/get-my-favourites';
  static const ViewAlltripApi = '$baseUrl/view-all-top-rated-hotels';
  static const tripDetailApi = '$baseUrl/get-property-details?property_id=';
  static const traveltripApi = '$baseUrl/list-travel-blogs';
  static const travelTripApiUnAuth =
      '$baseUrl/list-travel-blogs-unauthenticated';
  static const travelViewAllTripApi = '$baseUrl/view-all-travel-blogs';
  static const updateProfile = '$baseUrl/update-profile';
  static const searchHotelFilter = '$baseUrl/search-hotels-with-filter';
  static const searchHomeStayFilter = '$baseUrl/search-homestay-with-filter';
  static const searchHotelSorting = '$baseUrl/search-hotels-with-sorting';
  static const searchHomeStaySorting = '$baseUrl/search-homestay-with-sorting';
  static const accomendationId = '$baseUrl/book-homestay-accomodation-by-id';
  static const proceedApi =
      'https://eliorbooking.com/api/proceed-select-seats-points';
  static const finalHomeApi = '$baseUrl/pay-homestay-booking-by-id';
  static const finalHotelApi = '$baseUrl/pay-hotel-booking-by-id'; //1
  static const selectMyFav = '$baseUrl/select-my-favourites';
  static const getMyFav = '$baseUrl/get-my-favourites';
  static const removeFav = '$baseUrl/remove-my-favourites';
  static const review = '$baseUrl/submit-property-booking-review';
  static const busReview = '$baseUrl/submit-bus-booking-review';
  static const getMyNotification = '$baseUrl/get-my-notification';
  static const getAllCoupons = '$baseUrl/get-all-coupons';
  static const getNearbyProperties = '$baseUrl/get-properties-nearby';
  static const getBudgetFriendlyHomestays = '$baseUrl/budget-friendly-homestays';

}
