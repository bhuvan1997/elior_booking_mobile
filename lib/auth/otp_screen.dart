import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller/verify_otp_controller.dart';
import '../hotel_booking/bottom_navigation_screen.dart';

class OtpScreen extends StatelessWidget {
  var controller = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("OTP Verification"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "enter6digitcode".tr,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),

                      // OTP input field
                      // PinCodeTextField(
                      //   appContext: context,
                      //   length: 6,
                      //   controller: controller.otpInput,
                      //   keyboardType: TextInputType.number,
                      //   autoDismissKeyboard: true,
                      //   pinTheme: PinTheme(
                      //     shape: PinCodeFieldShape.box,
                      //     borderRadius: BorderRadius.circular(10),
                      //     fieldHeight: 50,
                      //     fieldWidth: 45,
                      //     activeFillColor: Colors.white,
                      //     selectedFillColor: Colors.grey.shade200,
                      //     inactiveFillColor: Colors.grey.shade100,
                      //     activeColor: Colors.teal,
                      //     selectedColor: Colors.teal,
                      //     inactiveColor: Colors.grey,
                      //   ),
                      //   cursorColor: Colors.teal,
                      //   enableActiveFill: true,
                      //   onChanged: (value) {},
                      // ),
                      SizedBox(height: 40),

                      // Dummy Button
                      ElevatedButton(
                        onPressed: () {
                          controller
                              .verifyOtpApi(
                                controller.otpInput.text.trim(),
                                LocalStorages().getEmail() ?? "",
                              )
                              .whenComplete(() {
                                if (controller.verifyModel.status == true) {
                                  LocalStorages().saveToken(
                                    token: controller.verifyModel.token ?? "",
                                  );
                                  Get.to(BottomBarScreen());
                                  Get.snackbar(
                                    "Success",
                                    controller.verifyModel.message ?? "",
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 20,
                                    margin: const EdgeInsets.all(20),
                                    backgroundColor: Colors.green,
                                  );
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Invalid Otp ",
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 20,
                                    margin: const EdgeInsets.all(20),
                                    backgroundColor: Colors.red,
                                  );
                                }
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
