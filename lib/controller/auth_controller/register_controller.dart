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
  String mobileCode = "255";

  String error = "";
  Future registerApi() async {
    try {
      registerModel = await ServiceProvider().register(
        name: nameInput.text.trim(),
        phone: phoneInput.text.trim(),
        email: emailInput.text.trim(),
        password: passwordInput.text.trim(),
        mobileCode: mobileCode,
      );
      print("NIMACSOD: ${registerModel.toJson()}");
      print("NIMACSOD: ${registerModel.errors}");

      if (registerModel.errors != null && registerModel.errors!.isNotEmpty) {
        print("NIMACSOD: ${registerModel.errors}");


        if (registerModel.errors!["email"] != null) {
          error = registerModel.errors?["email"]?.first ?? "";
          print("NIMACSOD: $error");
        } else {
          error = registerModel.errors?["mobile"]?.first ?? "";
        }
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
