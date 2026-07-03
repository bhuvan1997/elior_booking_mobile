import 'package:elior/widgets/country_code_picker.dart';
import 'package:get/get.dart';

class DataUtils {
  static final List<Country> countries = [
    Country('United States', '+1'),
    Country('Canada', '+1'),
    Country('Ivory Coast', '+225'),
    Country('United Kingdom', '+44'),
    Country('Australia', '+61'),
    Country('Germany', '+49'),
    Country('France', '+33'),
    Country('Brazil', '+55'),
  ];

  static Country getCountry(String code) {
    return countries.firstWhereOrNull((c) => c.code == "+$code") ??
        Country(
          'Ivory Coast',
          '+225',
        );
  }
}


class HotelHomePageUtils {
  static String getAppBarText(String slug) {
    switch (slug) {
      case "hotel":
        return "search_hotels".tr;
      default:
        return "search_homestays".tr;
    }
  }

  static String getPageText1(String slug) {
    switch (slug) {
      case "hotel":
        return "find_your_next_stay".tr;
      default:
        return "plan_your_stay_subtitle".tr;
    }
  }

  static String getPageText2(String slug) {
    switch (slug) {
      case "hotel":
        return "discover_perfect_stay".tr;
      default:
        return "find_homestays_near_you_subtitle".tr;
    }
  }

  static String getSearchText(String slug) {
    switch (slug) {
      case "hotel":
        return "search_hotel_or_area".tr;
      default:
        return "search_your_homestay".tr;
    }
  }
}