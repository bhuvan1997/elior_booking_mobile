import 'dart:async';

import 'package:elior/auth/advertisement_screen.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'advertisment_bar.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Image.asset(
          AssetsScreen.eliorLogo,
          width: Get.width,
          height: Get.height,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  void setData() {
    Future.delayed(const Duration(seconds: 3), () {
      final token = LocalStorages().getToken();
      if (token == null || token.isEmpty) {
        Get.off(() => AdvertismentBottomBarScreen());
      } else {
        Get.off(() => BottomBarScreen());
      }
      print("Neeraj${token}");
    });
  }
}
