import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Centralized toast helper.
/// - isError: red background, for failures/validation errors
/// - isGeneral: neutral grey background, for informational messages
/// - default (neither flag): green background, for success messages
class AppToast {
  const AppToast._();

  static void show(
      String message, {
        bool isError = false,
        bool isGeneral = false,
        Toast length = Toast.LENGTH_SHORT,
        ToastGravity gravity = ToastGravity.BOTTOM,
      }) {
    if (message.trim().isEmpty) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      backgroundColor: _backgroundColor(isError: isError, isGeneral: isGeneral),
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static Color _backgroundColor({required bool isError, required bool isGeneral}) {
    if (isError) return Colors.red.shade600;
    if (isGeneral) return Colors.grey.shade800;
    return Colors.green.shade600; // success / default
  }
}