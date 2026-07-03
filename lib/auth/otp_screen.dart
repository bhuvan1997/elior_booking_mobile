import 'package:elior/app_values/app_theme.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../controller/auth_controller/verify_otp_controller.dart';
import '../hotel_booking/bottom_navigation_screen.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final VerifyOtpController controller = Get.put(VerifyOtpController());

  void _verifyOtp() {
    final otp = controller.otpInput.text.trim();

    if (otp.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter OTP",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (otp.length != 6) {
      Get.snackbar(
        "Validation Error",
        "OTP must be 6 digits",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    controller
        .verifyOtpApi(
      otp,
      LocalStorages().getEmail() ?? "",
    )
        .whenComplete(() {
      if (controller.verifyModel.status == true) {
        LocalStorages().saveToken(
          token: controller.verifyModel.token ?? "",
        );

        Get.offAll(() => BottomBarScreen());

        Get.snackbar(
          "Success",
          controller.verifyModel.message ?? "OTP Verified Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          "Error",
          controller.verifyModel.message ?? "Invalid OTP",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
    );

    return Scaffold(
      appBar: getAppBar(
        context,
        "OTP Verification",
        centerTitle: false,
      ),
      body: GetBuilder<VerifyOtpController>(
        init: controller,
        builder: (_) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        Text(
                          "Verify Your Account",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Enter the 6-digit OTP sent to your registered email address.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 40),

                        Center(
                          child: Pinput(
                            controller: controller.otpInput,
                            length: 6,
                            keyboardType: TextInputType.number,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyDecorationWith(
                              border: Border.all(
                                color: AppTheme.appThemeColor,
                                width: 2,
                              ),
                            ),
                            submittedPinTheme: defaultPinTheme.copyDecorationWith(
                              border: Border.all(
                                color: AppTheme.appThemeColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  AppButton(title: "Continue", onTap: _verifyOtp,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}