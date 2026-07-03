import 'package:elior/app_values/app_theme.dart';
import 'package:elior/hotel_booking/top_rated.dart';
import 'package:elior/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/hotel_controller/top_hotel_controller.dart';
import '../home_screen/main_dashboard.dart';
import '../home_screen/myfavscreen.dart';
import '../hotel_booking/booking_history_screen.dart';
import '../notification_screen/notification_screen.dart';

class BottomBarScreen extends StatefulWidget {
  final int initialIndex;
  final int? historyTab;
  const BottomBarScreen({super.key, this.initialIndex = 0, this.historyTab});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late int _selectedIndex;
  final controller = Get.put(TopHotelController());

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {

    final _screens = [
      MainScreenWithButtons(),
      BookingHistoryScreen(
        initialTab: widget.historyTab ?? 0,
      ),
      MyFavScreen(),
      ProfileScreen(showActivity: false,),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: AppTheme.appThemeColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'bookings'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'wishlist'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile'.tr,
          ),
        ],
      ),
    );
  }
}
