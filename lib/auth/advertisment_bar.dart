import 'package:elior/hotel_booking/top_rated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/hotel_controller/top_hotel_controller.dart';
import '../home_screen/main_dashboard.dart';
import '../hotel_booking/booking_history_screen.dart';
import '../notification_screen/notification_screen.dart';
import 'advertisement_screen.dart';
import 'login_screen.dart';

class AdvertismentBottomBarScreen extends StatefulWidget {
  const AdvertismentBottomBarScreen({super.key});

  @override
  State<AdvertismentBottomBarScreen> createState() => _AdvertismentBottomBarScreenState();
}

class _AdvertismentBottomBarScreenState extends State<AdvertismentBottomBarScreen> {
  int _selectedIndex = 0;
  final controller = Get.put(TopHotelController());

  final List<Widget> _screens = [
    AdvertisementScreen(),
    LoginScreen(),
    LoginScreen(),
    LoginScreen(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login',
          ),
        ],
      ),
    );
  }
}
