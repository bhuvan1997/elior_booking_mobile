import 'dart:io';

import 'package:country_flags/country_flags.dart';
import 'package:elior/app_values/app_theme.dart';
import 'package:elior/auth/login_screen.dart';
import 'package:elior/home_screen/webview_screen.dart';
import 'package:elior/profile_screen/profile_screen.dart';
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
import '../hotel_booking/hotel_home_search_screen.dart';
import '../hotel_booking/trip_detail_screen.dart';
import '../network/service_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBookingHotels();
      travelfetchBookingHotels();
      controller.fetchNearby();
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

              _buildSectionHeader("Nearby Properties", icon: Icons.navigation),
              _buildNearbyPropertiesCarousel(),
              const SizedBox(height: 20),

              _buildSectionHeader("Offers Available", icon: Icons.local_offer),

              _buildOffersSection(),
              const SizedBox(height: 20),

              _buildSectionHeader(
                "Top Rated Hotels",
                icon: Icons.airplane_ticket,
              ),
              _buildTripCarousel(),

              const SizedBox(height: 25),

              _buildSectionHeader(
                "Your Daily Travel Blogs",
                icon: Icons.explore,
              ),
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
              label: "Hotels",
              iconColor: const Color(0xff2140C0),
              onTap: () => Get.to(HotelHomeSearchScreen(), arguments: "hotel"),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CategoryCard(
              icon: Icons.home_outlined,
              label: "Homestays",
              iconColor: Colors.red,
              onTap: () =>
                  Get.to(HotelHomeSearchScreen(), arguments: "homestay"),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CategoryCard(
              icon: Icons.directions_bus_outlined,
              label: "Bus",
              iconColor: Colors.green,
              onTap: () => Get.to(BusBookingScreen()),
            ),
          ),
        ],
      ),
    );
  }

  //--------------------- SECTION HEADER ----------------------
  Widget _buildSectionHeader(String title, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.appThemeColor, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppTheme.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
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
                  "No Nearby properties found",
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
            width: 240,
            child: _displayCard(
              imageUrl: property.images!.first,
              tripName: property.name ?? "Unnamed hotel",
              tripAddress: property.address ?? "N/A",
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

  //--------------------- TRIP CAROUSEL ----------------------
  Widget _buildTripCarousel() {
    if (bookingHistoryModel.data == null || bookingHistoryModel.data!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "No trips found",
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
              tripName: trip.name ?? "Unnamed Trip",
              tripAddress: trip.address ?? "",
              tripCurrency: trip.currency ?? "XOF",
              pricePerNight: trip.pricePerNight ?? 0,
              starRating: trip.starRating ?? 0,
              onTap: () {},
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
                        "$tripCurrency $pricePerNight/Night",
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
          "Coupon Copied",
          "$couponCode copied to clipboard",
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
                            blog.title ?? "Untitled Blog",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),
                          Text(
                            blog.content ?? "No content",
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
              "Language Changed",
              locale.languageCode == 'en'
                  ? "App is now in English 🇬🇧"
                  : "L'application est maintenant en français 🇫🇷",
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

  Widget _buildOffersSection() {
    return SizedBox(
      height: 164,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final offers = [
            {
              "code": "ELIOR200",
              "title": "Get 200 Off on Booking",
              "image":
                  "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1200",
            },
            {
              "code": "WELCOME10",
              "title": "10% Off for New Users",
              "image":
                  "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200",
            },
            {
              "code": "SUMMER25",
              "title": "Save 25% This Summer",
              "image":
                  "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=1200",
            },
          ];

          return _offerCard(
            imageUrl: offers[index]["image"]!,
            couponCode: offers[index]["code"]!,
            title: offers[index]["title"]!,
          );
        },
      ),
    );
  }
}

//
// ✅ Drawer
//

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              LocalStorages().getName() ?? "",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              LocalStorages().getEmail() ?? "",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),

            currentAccountPicture: GestureDetector(
              onTap: () {
                Get.to(const ProfileScreen());
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: ClipOval(child: _buildProfileImage()),
              ),
            ),
          ),

          /// Menu Buttons
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              children: [
                drawerItem(
                  icon: Icons.person,
                  title: "Profile",
                  color: Colors.deepPurple,
                  onTap: () => Get.to(const ProfileScreen()),
                ),
                drawerItem(
                  icon: Icons.airplane_ticket,
                  title: "My Bookings",
                  color: Colors.orange,
                  onTap: () => Get.to(BookingHistoryScreen()),
                ),
                drawerItem(
                  icon: Icons.favorite,
                  title: "Wishlist",
                  color: Colors.red,
                  onTap: () => Get.to(MyFavScreen()),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  child: Text(
                    "More",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                drawerItem(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  color: Colors.blueGrey,
                  onTap: () {
                    Get.to(ContactUsScreen());
                  },
                ),
                drawerItem(
                  icon: Icons.privacy_tip,
                  title: "Privacy Policy",
                  color: Colors.blueGrey,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: "https://eliorbooking.com/privacy_mobile",
                        title: "Privacy Policy",
                      ),
                    ),
                  ),
                ),

                drawerItem(
                  icon: Icons.list_alt,
                  title: "Terms & Conditions",
                  color: Colors.blueGrey,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: "https://eliorbooking.com/terms_condition_mobile",
                        title: "Terms & Conditions",
                      ),
                    ),
                  ),
                ),

                drawerItem(
                  icon: Icons.home_work,
                  title: "List Your Property",
                  color: Colors.blueGrey,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: "https://eliorbooking.com/list_property_mobile",
                        title: "List Your Property",
                      ),
                    ),
                  ),
                ),
                drawerItem(
                  icon: Icons.info_outline,
                  title: "About App",
                  color: Colors.blueGrey,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: "https://eliorbooking.com/about_app_mobile",
                        title: "About App",
                      ),
                    ),
                  ),
                ),

                // drawerItem(
                //   icon: Icons.info_outline,
                //   title: "About App",
                //   color: Colors.blueGrey,
                //   onTap: () =>
                //       _openLink("https://eliorbooking.com/about_app_mobile"),
                // ),
                drawerItem(
                  icon: Icons.logout,
                  title: "Logout",
                  color: Colors.redAccent,
                  onTap: () {
                    LocalStorages().removeToken();
                    LocalStorages().clearAll();

                    Get.offAll(LoginScreen());
                    Get.snackbar(
                      "Logged Out",
                      "You have successfully logged out.",
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItem({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  Future<void> _openLink(String urlString) async {
    final url = Uri.parse(urlString);
    await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    );
  }

  Widget _buildProfileImage() {
    final imagePath = LocalStorages().getProfileImage();

    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset(
        "assets/images/default_user.png",
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    // LOCAL FILE CHECK
    if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    // NETWORK URL CHECK
    if (imagePath.startsWith("http")) {
      return Image.network(imagePath, width: 80, height: 80, fit: BoxFit.cover);
    }

    // FALLBACK
    return Image.asset(
      "assets/images/default_user.png",
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }
}
