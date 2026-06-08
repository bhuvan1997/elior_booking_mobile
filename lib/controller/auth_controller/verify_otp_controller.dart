import 'package:elior/response_model/verify_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../network/service_provider.dart';

class VerifyOtpController extends GetxController {
  TextEditingController otpInput = TextEditingController();
  VerifyModel verifyModel = VerifyModel();

  Future verifyOtpApi(String otp, String email) async {
    try {
      verifyModel = await ServiceProvider().verifyOtp(email: email, otp: otp);
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
