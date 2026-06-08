import 'package:elior/response_model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/service_provider.dart';



class LoginController extends GetxController {
  TextEditingController emailInput = TextEditingController(text: "webalignsolutions@gmail.comg");
  TextEditingController passwordInput = TextEditingController(text: "12345678");
  LoginModel loginModel = LoginModel();

  Future loginApi() async {
    try {
      loginModel = await ServiceProvider().login(
        email: emailInput.text.trim(),
        password: passwordInput.text.trim(),
      );
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
