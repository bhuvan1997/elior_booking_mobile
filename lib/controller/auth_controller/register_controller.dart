import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../network/service_provider.dart';
import '../../response_model/register_model.dart';



class RegisterController extends GetxController {
  TextEditingController nameInput = TextEditingController();
  TextEditingController emailInput = TextEditingController();
  TextEditingController phoneInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController confirmPasswordInput = TextEditingController();

  RegisterModel registerModel = RegisterModel();
  String mobileCode = "";
  Future registerApi() async {
    try {
      registerModel = await ServiceProvider().register(
        name: nameInput.text.trim(),
        phone: phoneInput.text.trim(),
        email: emailInput.text.trim(),
        password: passwordInput.text.trim(),
        mobileCode: mobileCode,
      );
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
