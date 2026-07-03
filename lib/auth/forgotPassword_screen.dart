import 'package:elior/auth/reset_password.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/app_text_field.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_values/app_theme.dart';
import '../controller/auth_controller/forgot_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ForgetPasswordScreen({super.key});

  var controller = Get.put(ForgotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Forgot Password", centerTitle: false),
      body: GetBuilder(
        init: controller,
        builder: (value) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter your mail",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        AppTextField(
                          label: "email".tr,
                          placeholder: "enter_email_address".tr,
                          controller: controller.forgotEmailInput,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: AppTheme.appThemeColor,
                          ),
                        ),
                        // const SizedBox(height: 20),
                        // TextFormField(
                        //   controller: controller.forgotEmailInput,
                        //   keyboardType: TextInputType.emailAddress,
                        //   decoration: InputDecoration(
                        //     hintText: 'emailAddress'.tr,
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     prefixIcon: const Icon(Icons.email),
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.trim().isEmpty) {
                        //       return "Pleaseenteryouremail".tr;
                        //     }
                        //     if (!GetUtils.isEmail(value)) {
                        //       return "Enteravalidemailaddress".tr;
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  AppButton(
                    title: "Submit",
                    onTap: () {
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
