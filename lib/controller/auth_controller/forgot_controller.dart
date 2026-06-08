import 'package:elior/response_model/forgot_model_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/service_provider.dart';

class ForgotController extends GetxController {
  TextEditingController forgotEmailInput = TextEditingController();
  ForgotModel forgotModel = ForgotModel();

  Future ForgotApi() async {
    try {
      forgotModel = await ServiceProvider().forgotApi(
        email: forgotEmailInput.text.trim(),
      );
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
