import 'package:elior/app_values/app_theme.dart';
import 'package:elior/hotel_booking/top_rated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/hotel_controller/top_hotel_controller.dart';
import '../home_screen/main_dashboard.dart';
import '../home_screen/myfavscreen.dart';
import '../hotel_booking/booking_history_screen.dart';
import '../notification_screen/notification_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final controller = Get.put(TopHotelController());

  final List<Widget> _screens = [
    MainScreenWithButtons(),
    BookingHistoryScreen(),
    MyFavScreen(),
    NotificationScreen(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
