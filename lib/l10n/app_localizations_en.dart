// // ignore: unused_import
// import 'package:intl/intl.dart' as intl;
// import 'app_localizations.dart';
//
// // ignore_for_file: type=lint
//
// /// The translations for English (`en`).
// class AppLocalizationsEn extends AppLocalizations {
//   AppLocalizationsEn([String locale = 'en']) : super(locale);
//
//   @override
//   String get welcomeElior => 'Welcome to Elior 👋';
//
//   @override
//   String get loginYourAccount => 'Login to your account';
//
//   @override
//   String get pleaseEnterYourEmail => 'Please enter your email';
//
//   @override
//   String greetUser(String name) {
//     return 'Hello $name';
//   }
//
//   @override
//   String nRooms(int count) {
//     String _temp0 = intl.Intl.pluralLogic(
//       count,
//       locale: localeName,
//       other: '$count rooms',
//       one: '1 room',
//       zero: 'No rooms',
//     );
//     return '$_temp0';
//   }
//
//   @override
//   String hostGender(String gender) {
//     String _temp0 = intl.Intl.selectLogic(
//       gender,
//       {
//         'male': 'Host',
//         'female': 'Hostess',
//         'other': 'Host',
//       },
//     );
//     return '$_temp0';
//   }
// }
