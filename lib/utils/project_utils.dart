import 'package:cached_network_image/cached_network_image.dart';
import 'package:elior/app_values/app_theme.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getImage({String? url, required double height, required double width}) {
  try {
    if (url == null || url.isEmpty) {
      return Image.asset(AssetsScreen.elior, height: height, width: width);
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      placeholder: (context, url) => const CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => Image.asset(AssetsScreen.elior),
      fit: BoxFit.cover,
    );
  } catch (e) {
    return Image.asset(AssetsScreen.elior, height: height, width: width);
  }
}


Widget pageIndicator(int servicesLength, int currentIndex, PageController pageController, void Function(int) onDotTapped) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      servicesLength,
          (index) => GestureDetector(
        onTap: () {
          onDotTapped(index);
          pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? AppTheme.appThemeColor : AppTheme.appThemeColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}