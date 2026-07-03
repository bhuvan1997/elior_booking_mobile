import 'package:elior/app_values/app_theme.dart';
import 'package:flutter/material.dart';

class RouteIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.appThemeColor, width: 2),
            ),
          ),
          Container(width: 40, height: 1.5, color: Colors.grey.shade300),
          Icon(Icons.arrow_forward, size: 14, color: Colors.grey.shade400),
          Container(width: 40, height: 1.5, color: Colors.grey.shade300),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.appThemeColor,
            ),
          ),
        ],
      ),
    );
  }
}