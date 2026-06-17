class HotelHomePageUtils {
  static String getAppBarText(String slug) {
    switch (slug) {
      case "hotel":
        return "Search Hotels";
      default:
        return "Search Homestays";
    }
  }

  static String getPageText1(String slug) {
    switch (slug) {
      case "hotel":
        return "Find your next stay!";
      default:
        return "Plan your stay";
    }
  }

  static String getPageText2(String slug) {
    switch (slug) {
      case "hotel":
        return "Discover the perfect stay with Elior Booking";
      default:
        return "Find homestays near you or any location";
    }
  }

  static String getSearchText(String slug) {
    switch (slug) {
      case "hotel":
        return "Search with Hotel or Area name";
      default:
        return "Search Your Homestay";
    }
  }
}