import 'package:elior/widgets/debounced_tap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../app_values/app_theme.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isEnabled;
  final bool isOutlined;

  const AppButton({super.key, required this.title, this.onTap, this.isEnabled = true, this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    return DebouncedTap(
      onTap: onTap,
      child: Container(
        height: 44,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isOutlined ? Border.all(color: AppTheme.appThemeColor) : null,
          color: !isOutlined ? AppTheme.appThemeColor : null,
          // boxShadow: !isOutlined ? [BoxShadow(color: AppTheme.black.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        child: Text(title,style: GoogleFonts.poppins(color: isOutlined ? AppTheme.appThemeColor : AppTheme.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}