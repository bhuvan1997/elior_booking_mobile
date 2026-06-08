import 'dart:async';

import 'package:elior/auth/spalash_screen.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../hotel_booking/bottom_navigation_screen.dart';
import '../utils/storage.dart';

class SplashScreen1 extends StatelessWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    setData();

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
    Future.delayed(const Duration(milliseconds: 100), () {
      final token = LocalStorages().getToken();
      if (token == null && token?.isEmpty == true) {
        Get.off(() => SplashScreen());
      } else {
        Get.off(() => BottomBarScreen());
      }
      print("Neeraj${token}");
    });
  }
}
