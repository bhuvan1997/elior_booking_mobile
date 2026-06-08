import 'package:elior/auth/spalash_screen.dart';
import 'package:elior/review_screen.dart';
import 'package:elior/ticket_history.dart';
import 'package:elior/trip_history.dart';
import 'package:elior/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // For Android: Dark icons (works well on light backgrounds)
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.black,
      // For iOS: Use 'light' to get dark icons (due to opposite behavior)
      // statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static Locale? getLocale(BuildContext context) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    return state?._locale;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      // ✅ use GetX translations
      locale: _locale,
      fallbackLocale: const Locale('en'),
      home: SplashScreen(),

      // home: const ProfileScreen(),
    );
  }
}
