import 'package:elior/auth/login_screen.dart';
import 'package:elior/response_model/reset_password_response.dart';
import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../network/service_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  // final int Id;
  const ResetPasswordScreen({super.key, });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // void _changePassword() {
  //   String newPwd = newPasswordController.text.trim();
  //   String confirmPwd = confirmPasswordController.text.trim();
  //
  //   if (newPwd != confirmPwd) {
  //     _showSnackBar("newPasswordoNotMatch".tr);
  //   } else {
  //     _showSnackBar("Password changed successfully!");
  //     // Add your backend logic here
  //   }
  // }

  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text(message)));
  // }

  ResetModel resetModel = ResetModel();

  Future resetApi() async {
    try {
      resetModel = await ServiceProvider().resetPassword(
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        id: LocalStorages().getForgotId()??0,
      );
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "changePassword".tr,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Container(width: 4, color: Colors.orange),
              Expanded(child: Container()),
              Container(width: 4, color: Colors.green),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildPasswordField(
                  label: "newPassword".tr,
                  controller: newPasswordController,
                  obscure: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  label: "confirmPassword".tr,
                  controller: confirmPasswordController,
                  obscure: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      resetApi().whenComplete((){
                        if(resetModel.status==true){
                          Get.offAll(LoginScreen());
                        }
                      });
                    },
                    child: Text(
                      "savePassword".tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
