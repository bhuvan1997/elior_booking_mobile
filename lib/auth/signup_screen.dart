import 'package:elior/app_values/app_theme.dart';
import 'package:elior/auth/otp_screen.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/utils/data_utils.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/app_mobile_input.dart';
import 'package:elior/widgets/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../controller/auth_controller/register_controller.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final controller = Get.put(RegisterController());
  Country selectedCountry = DataUtils.getCountry("225");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (value) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Center(child: Image.asset(AssetsScreen.elior, height: 60)),
                    const SizedBox(height: 10),
                    Text(
                      'create_account'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.black,
                      ),
                    ),
                    Text(
                      'signup_to_get_started'.tr,
                      style: GoogleFonts.poppins(
                        color: AppTheme.black.withValues(alpha: 0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Name
                    AppTextField(
                      label: "full_name".tr,
                      placeholder: "enter_your_full_name".tr,
                      controller: controller.nameInput,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppTheme.appThemeColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    AppTextField(
                      label: "email".tr,
                      placeholder: "enter_email_address".tr,
                      controller: controller.emailInput,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: AppTheme.appThemeColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Mobile Number with Country Code
                    Text(
                      "mobile".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AppMobileInput(controller: controller.phoneInput, initialCountry: selectedCountry,),

                    // Password
                    const SizedBox(height: 20),
                    AppTextField(
                      label: "password".tr,
                      placeholder: "enter_password".tr,
                      controller: controller.passwordInput,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppTheme.appThemeColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    AppTextField(
                      label: "confirm_password".tr,
                      placeholder: "confirm_password_msg".tr,
                      controller: controller.confirmPasswordInput,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppTheme.appThemeColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              Column(
                children: [
                  AppButton(
                    title: "sign_up".tr,
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      if (!validateForm()) {
                        return;
                      }

                      await controller.registerApi();

                      if (controller.registerModel.status == true) {
                        LocalStorages().saveToken(
                          token: controller.registerModel.token ?? "",
                        );

                        LocalStorages().saveEmail(
                          email: controller.emailInput.text.trim(),
                        );

                        LocalStorages().saveName(
                          name: controller.nameInput.text.trim(),
                        );

                        LocalStorages().saveMobile(
                          mobile: controller.phoneInput.text.trim(),
                        );

                        LocalStorages().saveMobileCode(
                          mobileCode: controller.mobileCode,
                        );

                        Get.to(
                              () => OtpScreen(),
                          arguments: controller.emailInput.text.trim(),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // Login Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('already_have_account'.tr),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          ' login'.tr,
                          style: const TextStyle(
                            color: AppTheme.appThemeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateForm() {
    final name = controller.nameInput.text.trim();
    final email = controller.emailInput.text.trim();
    final phone = controller.phoneInput.text.trim();
    final password = controller.passwordInput.text;
    final confirmPassword = controller.confirmPasswordInput.text;

    String? error;

    if (name.isEmpty) {
      error = "please_enter_full_name".tr;
    } else if (name.length < 3) {
      error = "name_min_chars".tr;
    } else if (email.isEmpty) {
      error = "please_enter_email".tr;
    } else if (!GetUtils.isEmail(email)) {
      error = "enter_valid_email".tr;
    } else if (phone.isEmpty) {
      error = "please_enter_mobile".tr;
    } else if (phone.length < 8) {
      error = "enter_valid_mobile".tr;
    } else if (password.isEmpty) {
      error = "please_enter_password".tr;
    } else if (password.length < 6) {
      error = "password_min_chars".tr;
    } else if (confirmPassword.isEmpty) {
      error = "confirm_password_msg".tr;
    } else if (password != confirmPassword) {
      error = "passwords_dont_match".tr;
    }

    if (error != null) {
      Get.snackbar(
        "validation_error".tr,
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.black,
        colorText: AppTheme.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    return true;
  }
}