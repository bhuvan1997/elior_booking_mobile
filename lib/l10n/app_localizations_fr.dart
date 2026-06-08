// // ignore: unused_import
// import 'package:intl/intl.dart' as intl;
// import 'app_localizations.dart';
//
// // ignore_for_file: type=lint
//
// /// The translations for French (`fr`).
// class AppLocalizationsFr extends AppLocalizations {
//   AppLocalizationsFr([String locale = 'fr']) : super(locale);
//
//   @override
//   String get welcomeElior => 'Bienvenue chez Elior 👋';
//
//   @override
//   String get loginYourAccount => 'Connectez-vous à votre compte';
//
//   @override
//   String get pleaseEnterYourEmail => 'Veuillez entrer votre e-mail';
//
//   @override
//   String greetUser(String name) {
//     return 'Bonjour $name';
//   }
//
//   @override
//   String nRooms(int count) {
//     String _temp0 = intl.Intl.pluralLogic(
//       count,
//       locale: localeName,
//       other: '$count chambres',
//       one: '1 chambre',
//       zero: 'Aucune chambre',
//     );
//     return '$_temp0';
//   }
//
//   @override
//   String hostGender(String gender) {
//     String _temp0 = intl.Intl.selectLogic(
//       gender,
//       {
//         'male': 'Hôte',
//         'female': 'Hôtesse',
//         'other': 'Hôte',
//       },
//     );
//     return '$_temp0';
//   }
// }
