import 'package:elior/auth/otp_screen.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../controller/auth_controller/register_controller.dart';

class SignupScreen extends StatelessWidget {
  final controller = Get.put(RegisterController());

  // ✅ Add form key
  final _formKey = GlobalKey<FormState>();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: controller,
        builder: (value) => Stack(
          children: [
            Row(
              children: [
                Container(width: 4, color: Colors.orange),
                Expanded(child: Container()),
                Container(width: 4, color: Colors.green),
              ],
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Form(
                key: _formKey, // ✅ wrap in Form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(AssetsScreen.elior, height: 160),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'createAccount'.tr,
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'signupToGetStarted'.tr,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 30),

                    // Name
                    TextFormField(
                      controller: controller.nameInput,
                      decoration: InputDecoration(
                        hintText: 'fullName'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "pleaseEnterFullName".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email
                    TextFormField(
                      controller: controller.emailInput,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'emailAddress'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "pleaseEnterEmail".tr;
                        }
                        if (!GetUtils.isEmail(value)) {
                          return "enterValidEmail".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Mobile Number with Country Code
                    IntlPhoneField(
                      controller: controller.phoneInput,
                      initialCountryCode: 'CI',
                      // default India 🇮
                      decoration: InputDecoration(
                        hintText: 'mobileNumber'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      onChanged: (phone) {
                        controller.mobileCode = phone.countryCode; // "+91"
                        // controller.fullPhoneNumber = phone.completeNumber;
                      },
                      validator: (value) {
                        if (value == null || value.number.isEmpty) {
                          return "pleaseEnterMobile".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    TextFormField(
                      controller: controller.passwordInput,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "pleaseEnterPassword".tr;
                        }
                        if (value.length < 6) {
                          return "passwordMinChars".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    TextFormField(
                      controller: controller.confirmPasswordInput,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'confirmPassword'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "confirmPasswordMsg".tr;
                        }
                        if (value != controller.passwordInput.text) {
                          return "passwordsDontMatch".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Signup Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.registerApi(

                          ).whenComplete(() {
                            if (controller.registerModel.status == true) {
                              LocalStorages().saveToken(
                                token: controller.registerModel.token ?? "",
                              );
                              LocalStorages().saveEmail(
                                email: controller.emailInput.text.trim(),
                              ); LocalStorages().saveName(
                                name: controller.nameInput.text.trim(),
                              ); LocalStorages().saveMobile(
                                mobile: controller.phoneInput.text.trim(),
                              );
                              LocalStorages().saveMobileCode(
                                mobileCode: controller.mobileCode.trim(),
                              );
                              Get.to(OtpScreen(),
                                arguments: controller.emailInput.text.trim(),
                              );
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'signUp'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('alreadyHaveAccount '.tr),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login'.tr,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
