import 'package:elior/app_values/app_theme.dart';
import 'package:elior/auth/signup_screen.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/auth_controller/login_controller.dart';
import '../utils/storage.dart';
import 'forgotPassword_screen.dart' show ForgetPasswordScreen;

class LoginScreen extends StatelessWidget {

  LoginScreen({super.key});

  var controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (value) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Image.asset(AssetsScreen.elior, width: 200,),
                            const SizedBox(height: 10),
                            Text(
                              "login_to_your_account".tr,
                              style: TextStyle(
                                color: AppTheme.black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email Field
                      AppTextField(
                        label: "email".tr,
                        placeholder: "enter_email_address".tr,
                        controller: controller.emailInput,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email, color: AppTheme.appThemeColor,),
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      AppTextField(
                        label: "password".tr,
                        placeholder: "enter_your_password".tr,
                        controller: controller.passwordInput,
                        isPassword: true,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.lock, color: AppTheme.appThemeColor,),
                      ),

                      const SizedBox(height: 10),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.to(() => (ForgetPasswordScreen()));
                          },
                          child: Text(
                            'forgot_password'.tr,
                            style: GoogleFonts.poppins(
                              color: AppTheme.black.withValues(alpha: 0.75),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                // Login Button
                AppButton(
                  title: "login".tr,
                  onTap: () {
                    controller.loginApi().whenComplete(() {
                      if (controller.loginModel.status == true) {
                        LocalStorages().saveToken(
                          token: controller.loginModel.token ?? "",
                        );
                        LocalStorages().saveEmail(
                          email: controller.loginModel.email ?? "",
                        );
                        LocalStorages().saveName(
                          name: controller.loginModel.name ?? "",
                        );
                        LocalStorages().saveMobile(
                          mobile: controller.loginModel.mobile ?? "",
                        );
                        LocalStorages().saveMobileCode(
                          mobileCode: controller.loginModel.mobileCode ?? "",
                        );
                        LocalStorages().saveDob(
                          dob: controller.loginModel.dob ?? "",
                        );
                        LocalStorages().saveAddress(
                          address: controller.loginModel.address ?? "",
                        );
                        LocalStorages().saveGender(
                          gender: controller.loginModel.gender ?? "",
                        );
                        LocalStorages().saveMaritalStatus(
                          maritalStatus: controller.loginModel.maritalStatus ?? "",
                        );
                        LocalStorages().savePostalCode(
                          postalCode: controller.loginModel.postalCode ?? "",
                        );
                        LocalStorages().saveExpiryDate(
                          expiryDate: controller.loginModel.expiryDate ?? "",
                        );
                        LocalStorages().savePassportNumber(
                          passportNumber: controller.loginModel.passportNumber ?? "",
                        );
                        LocalStorages().saveProfileImage(
                          controller.loginModel.profileImage ?? "",
                        );

                        Get.offAll(() => BottomBarScreen());
                      }
                    });
                  },
                ),
                const SizedBox(height: 16,),
                // Sign Up Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("dont_have_an_account".tr),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignupScreen());
                      },
                      child: Text(
                        'sign_up'.tr,
                        style: GoogleFonts.poppins(
                          color: AppTheme.appThemeColor,
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
      ),
    );
  }
}