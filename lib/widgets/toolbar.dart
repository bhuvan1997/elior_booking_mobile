import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_values/app_theme.dart';
import 'debounced_tap.dart';

class Toolbar extends StatelessWidget {
  final String text;
  final Widget? leading;
  final Widget? trailing;

  const Toolbar({
    super.key,
    required this.text,
    this.leading = const Icon(Icons.arrow_back_ios_new),
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          if (leading != null)
            Align(
              alignment: Alignment.centerLeft,
              child: DebouncedTap(
                onTap: () => Navigator.pop(context),
                child: leading!,
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Text(
              text, style: GoogleFonts.poppins(fontSize: 18,
              fontWeight: FontWeight.w600,),
            ),
          ),
          Visibility(
            visible: trailing != null,
            child: Align(alignment: Alignment.centerLeft, child: trailing),
          ),
        ],
      ),
    );
  }
}

AppBar getAppBar(
  BuildContext context,
  String text, {
  String? subtext,
      Widget? subtextWidget,
  Widget? customTitle,
  bool isLeading = true,
      bool isSubtext = false,
  List<Widget>? trailing,
  bool centerTitle = true,
      PreferredSizeWidget? bottom,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark,),
    elevation: 0,
    leading: isLeading
        ? Center(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.chevron_left_outlined,
                color: AppTheme.primaryTextColor,
              ),
            ),
          )
        : null,
    title:
        customTitle ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryTextColor,
              ),
            ),
            if (isSubtext)
              if (subtext != null)
              Text(
                subtext,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryTextColor.withValues(alpha: 0.6),
                ),
              ) else
                subtextWidget ?? SizedBox(),
          ],
        ),
    titleSpacing: 0,
    centerTitle: centerTitle,
    actions: trailing,
    bottom: bottom,
  );
}
