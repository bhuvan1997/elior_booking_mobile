import 'package:elior/auth/reset_password.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/auth_controller/forgot_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ForgetPasswordScreen({super.key});

  var controller = Get.put(ForgotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: controller,
        builder: (value) => SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(width: 4, color: Colors.orange),
                    Expanded(child: Container()),
                    Container(width: 4, color: Colors.green),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Form(
                    key: _formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(AssetsScreen.elior),

                        Text(
                          "Forgot Password ",
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),

                        TextFormField(
                          controller: controller.forgotEmailInput,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Pleaseenteryouremail".tr;
                            }
                            if (!GetUtils.isEmail(value)) {
                              return "Enteravalidemailaddress".tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () {
                            // Get.offAll(() => ResetPasswordScreen());
                            if (_formKey.currentState!.validate()) {
                              controller.ForgotApi().whenComplete(() {
                                if (controller.forgotModel.status == true) {
                                  LocalStorages().saveForgotId(
                                    forgotId: controller.forgotModel.id ?? 0,
                                  );
                                  Get.to(() => ResetPasswordScreen());
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Sign Up Option
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
