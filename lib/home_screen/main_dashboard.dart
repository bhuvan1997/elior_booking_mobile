import 'dart:io';

import 'package:country_flags/country_flags.dart';
import 'package:elior/app_values/app_theme.dart';
import 'package:elior/auth/login_screen.dart';
import 'package:elior/home_screen/webview_screen.dart';
import 'package:elior/profile_screen/profile_screen.dart';
import 'package:elior/response_model/get_all_coupons_response.dart';
import 'package:elior/utils/project_utils.dart';
import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constatnt/assets_image.dart';
import '../controller/hotel_controller/top_hotel_controller.dart';
import '../help_support/view.dart';
import '../home_stay/home_stay_booking_screen.dart';
import '../hotel_booking/booking_history_screen.dart';
import '../hotel_booking/hotel_detail.dart';
import '../hotel_booking/hotel_home_search_screen.dart';
import '../hotel_booking/trip_detail_screen.dart';
import '../network/service_provider.dart';
import '../response_model/property/property_search_response.dart';
import '../response_model/trip_model/travel_vlogs.dart';
import '../response_model/trip_model/tripModel.dart';
import '../transport_booking/date_bus_booking.dart';
import 'blog_webview.dart';
import 'home_screen_widgets/categroy_card.dart';
import 'myfavscreen.dart';

class MainScreenWithButtons extends StatefulWidget {
  const MainScreenWithButtons({super.key});

  @override
  State<MainScreenWithButtons> createState() => _MainScreenWithButtonsState();
}

class _MainScreenWithButtonsState extends State<MainScreenWithButtons> {
  var controller = Get.put(TopHotelController());
  TripModel bookingHistoryModel = TripModel();
  TravelVlogsModel travelVlogsModel = TravelVlogsModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchBookingHotels();
      travelfetchBookingHotels();

    });
  }

  Future<void> fetchBookingHotels() async {
    try {
      isLoading = true;
      setState(() {});
      bookingHistoryModel = await ServiceProvider().tripApi();
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> travelfetchBookingHotels() async {
    try {
      isLoading = true;
      setState(() {});
      travelVlogsModel = await ServiceProvider().TraveltripApi();
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Image.asset(AssetsScreen.eliordasAppLogo, height: 40),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildLanguageDropdown(),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await fetchBookingHotels();
          await travelfetchBookingHotels();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildCategoryRow(),
              const SizedBox(height: 20),

              if (controller.nearbyProperties.data != null && controller.nearbyProperties.data!.isNotEmpty) ...[
                _buildSectionHeader("nearby_properties".tr),
                _buildNearbyPropertiesCarousel(),
                const SizedBox(height: 20),
              ],

              if (controller.budgetFriendlyHomestays.data != null && controller.budgetFriendlyHomestays.data!.isNotEmpty) ...[
                _buildSectionHeader("budget_friendly_homestays".tr),
                _buildBudgetFriendlyHomeStaysCarousel(),
                const SizedBox(height: 20),
              ],

              _buildSectionHeader("offers_available".tr),
              _buildOffersSection(controller.couponResponse.data ?? []),
              const SizedBox(height: 20),

              _buildSectionHeader("top_rated_hotels".tr),
              _buildTripCarousel(),

              const SizedBox(height: 25),

              _buildSectionHeader("your_daily_travel_blogs".tr),
              _buildTravelBlogCarousel(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  //-------------------- CATEGORY BUTTON ROW ---------------------
  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: CategoryCard(
              icon: Icons.hotel_outlined,
              label: "hotels".tr,
              iconColor: const Color(0xff2140C0),
              onTap: () => Get.to(HotelHomeSearchScreen(), arguments: "hotel"),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CategoryCard(
              icon: Icons.home_outlined,
              label: "homestays".tr,
              iconColor: Colors.red,
              onTap: () =>
                  Get.to(HotelHomeSearchScreen(), arguments: "homestay"),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CategoryCard(
              icon: Icons.directions_bus_outlined,
              label: "bus".tr,
              iconColor: Colors.green,
              onTap: () => Get.to(BusBookingScreen()),
            ),
          ),
        ],
      ),
    );
  }

  //--------------------- SECTION HEADER ----------------------
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: AppTheme.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  //--------------------- Nearby Properties ----------------------
  Widget _buildNearbyPropertiesCarousel() {
    return SizedBox(
      height: 225,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: controller.nearbyProperties.data?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final nearbyProperties = controller.nearbyProperties;
          final property = nearbyProperties.data![index];
          if (nearbyProperties.data == null || nearbyProperties.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "no_nearby_properties".tr,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppTheme.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
          return SizedBox(
            width: 240,
            child: _displayCard(
              imageUrl: property.images!.first,
              tripName: property.name ?? "unnamed_hotel".tr,
              tripAddress: property.address ?? "n_a".tr,
              tripCurrency: property.currency ?? "XOF",
              pricePerNight: property.pricePerNight ?? 0,
              starRating: property.starRating ?? 0,
              onTap: () => property.navigateToDetail(context),
            ),
          );
        },
      ),
    );
  }

  //--------------------- Budget Friendly Homestays ----------------------
  Widget _buildBudgetFriendlyHomeStaysCarousel() {
    return SizedBox(
      height: 225,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: controller.budgetFriendlyHomestays.data?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final nearbyProperties = controller.budgetFriendlyHomestays;
          final property = nearbyProperties.data![index];
          if (nearbyProperties.data == null || nearbyProperties.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "no_nearby_properties".tr,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppTheme.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
          return SizedBox(
            width: 240,
            child: _displayCard(
              imageUrl: property.images!.first,
              tripName: property.name ?? "unnamed_hotel".tr,
              tripAddress: property.address ?? "n_a".tr,
              tripCurrency: property.currency ?? "XOF",
              pricePerNight: property.pricePerNight ?? 0,
              starRating: property.starRating ?? 0,
              onTap: () => Get.to(
                    () => UnifiedPropertyDetailsScreen(
                  id: property.id ?? 0,
                  fac: '', // You can pass appropriate value if needed
                  slug: "home",
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //--------------------- TRIP CAROUSEL ----------------------
  Widget _buildTripCarousel() {
    if (bookingHistoryModel.data == null || bookingHistoryModel.data!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "no_trips_found".tr,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 225,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: bookingHistoryModel.data!.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final trip = bookingHistoryModel.data![index];

          return SizedBox(
            width: 240,
            child: _displayCard(
              imageUrl: trip.images!.first,
              tripName: trip.name ?? "unnamed_trip".tr,
              tripAddress: trip.address ?? "",
              tripCurrency: trip.currency ?? "XOF",
              pricePerNight: trip.pricePerNight ?? 0,
              starRating: trip.starRating ?? 0,
              onTap: () {
                Get.to(() => UnifiedPropertyDetailsScreen(
                  id: trip.id ?? 0,
                  fac: trip.description ?? "",
                  slug: "hotel",
                ));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _displayCard({
    required String imageUrl,
    required String tripName,
    required String tripAddress,
    required String tripCurrency,
    required num pricePerNight,
    required num starRating,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: getImage(
                height: 120,
                width: double.infinity,
                url: imageUrl,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tripName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              tripAddress,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withValues(alpha: 0.4),
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$tripCurrency $pricePerNight${"per_night".tr}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amberAccent, size: 16),
                          Text(
                            "$starRating.0",
                            style: GoogleFonts.poppins(
                              color: AppTheme.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _offerCard({
    required String imageUrl,
    required String couponCode,
    required String title,
  }) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: couponCode));

        Get.snackbar(
          "coupon_copied".tr,
          "$couponCode ${"copied_to_clipboard".tr}",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: getImage(
                    height: 120,
                    width: double.infinity,
                    url: imageUrl,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: AlignmentGeometry.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.grey.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      couponCode,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------- TRAVEL BLOG CAROUSEL ----------------------
  Widget _buildTravelBlogCarousel() {
    if (travelVlogsModel.data == null || travelVlogsModel.data!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: travelVlogsModel.data!.length,
        itemBuilder: (context, index) {
          final blog = travelVlogsModel.data![index];

          return GestureDetector(
            onTap: () {
              if (blog.id != null) {
                String url =
                    "https://eliorbooking.com/view_mobile_blog/${blog.id}";

                Get.to(() => BlogWebviewScreen(url: url));
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              ),
              child: SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: getImage(
                        height: 120,
                        width: double.infinity,
                        url: blog.coverImage,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.title ?? "untitled_blog".tr,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            blog.content ?? "no_content".tr,
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    Locale currentLocale = Get.locale ?? const Locale('en');
    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: currentLocale,
        icon: const Icon(Icons.language, color: Colors.black87),
        onChanged: (Locale? locale) {
          if (locale != null) {
            Get.updateLocale(locale);
            Get.snackbar(
              "language_changed".tr,
              locale.languageCode == 'en'
                  ? "app_now_in_english".tr
                  : "app_now_in_french".tr,
            );
          }
        },
        items: [
          DropdownMenuItem(
            value: const Locale('en'),
            child: Row(
              children: [
                CountryFlag.fromCountryCode('GB', height: 18, width: 26),
                const SizedBox(width: 8),
                const Text(""),
              ],
            ),
          ),
          DropdownMenuItem(
            value: const Locale('fr'),
            child: Row(
              children: [
                CountryFlag.fromCountryCode('FR', height: 18, width: 26),
                const SizedBox(width: 8),
                const Text(""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection(
      List<Coupon> coupons
      ) {
    return SizedBox(
      height: 164,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: coupons.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final image = "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1200";
          final offer = coupons[index];

          return _offerCard(
            imageUrl: image,
            couponCode: offer.name ?? "NA",
            title: offer.description ?? "",
          );
        },
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  _sectionTitle("account".tr),

                  _drawerTile(
                    icon: Icons.person_outline,
                    title: "profile".tr,
                    onTap: () => Get.to(const ProfileScreen()),
                  ),

                  _drawerTile(
                    icon: Icons.airplane_ticket_outlined,
                    title: "my_bookings".tr,
                    onTap: () => Get.to(BookingHistoryScreen()),
                  ),

                  _drawerTile(
                    icon: Icons.favorite_border,
                    title: "wishlist".tr,
                    onTap: () => Get.to(MyFavScreen()),
                  ),

                  const SizedBox(height: 18),

                  _sectionTitle("support_section".tr),

                  _drawerTile(
                    icon: Icons.support_agent_outlined,
                    title: "help_support".tr,
                    onTap: () => Get.to(ContactUsScreen()),
                  ),

                  _drawerTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "privacy_policy".tr,
                    onTap: () {
                      Get.to(
                            () => const WebViewScreen(
                          url:
                          "https://eliorbooking.com/privacy_mobile",
                          title: "privacy_policy",
                        ),
                      );
                    },
                  ),

                  _drawerTile(
                    icon: Icons.gavel_outlined,
                    title: "terms_conditions".tr,
                    onTap: () {
                      Get.to(
                            () => const WebViewScreen(
                          url:
                          "https://eliorbooking.com/terms_condition_mobile",
                          title: "terms_conditions",
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  _sectionTitle("business_section".tr),

                  _drawerTile(
                    icon: Icons.home_work_outlined,
                    title: "list_your_property".tr,
                    onTap: () {
                      Get.to(
                            () => const WebViewScreen(
                          url:
                          "https://eliorbooking.com/list_property_mobile",
                          title: "list_your_property",
                        ),
                      );
                    },
                  ),

                  _drawerTile(
                    icon: Icons.info_outline,
                    title: "about_app".tr,
                    onTap: () {
                      Get.to(
                            () => const WebViewScreen(
                          url:
                          "https://eliorbooking.com/about_app_mobile",
                          title: "about_app",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            _logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(const ProfileScreen()),
          child: Container(
            height: 86,
            width: 86,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: ClipOval(
              child: _buildProfileImage(),
            ),
          ),
        ),

        const SizedBox(height: 14),

        Text(
          LocalStorages().getName() ?? "guest_user".tr,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          LocalStorages().getEmail() ?? "",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppTheme.black.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 6,
        bottom: 10,
        top: 8,
      ),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 12,
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.appThemeColor.withOpacity(.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.appThemeColor,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: Text(
            "logout".tr,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            LocalStorages().removeToken();
            LocalStorages().clearAll();

            Get.offAll(LoginScreen());

            Get.snackbar(
              "logged_out".tr,
              "logged_out_message".tr,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final imagePath = LocalStorages().getProfileImage();

    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset(
        "assets/images/default_user.png",
        fit: BoxFit.cover,
      );
    }

    if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      );
    }

    if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
      );
    }

    return Image.asset(
      "assets/images/default_user.png",
      fit: BoxFit.cover,
    );
  }
}