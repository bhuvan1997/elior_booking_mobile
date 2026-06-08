import 'dart:io';
import 'package:elior/auth/login_screen.dart';
import 'package:elior/profile_screen/edit_profile.dart';
import 'package:elior/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = LocalStorages().getName() ?? "User Name";
    final email = LocalStorages().getEmail() ?? "user@example.com";
    final phone = LocalStorages().getMobile() ?? "+1 234 567 890";
    final image = LocalStorages().getProfileImage();
    final address = LocalStorages().getAddress()??"Address";
    final date = LocalStorages().getDob()??"DOB";

    return Scaffold(
      backgroundColor: Colors.white,

      // ---------------- APPBAR WITH EDIT BUTTON ----------------
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: true,

        actions: [
          TextButton(
            onPressed: () => Get.to(() => EditProfileScreen()),
            child: const Text(
              "Edit",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // ---------------- PROFILE IMAGE ----------------
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: _buildProfileImage(),
              ),
            ),


            const SizedBox(height: 40),

            // ---------------- PROFILE DATA ----------------
            _profileRow("Name", name),
            _divider(),

            _profileRow("Email", email),
            _divider(),

            _profileRow("Contact Number", phone),
            _divider(),

            _profileRow("Address", address),
            _divider(),

            _profileRow("Date of Birth", date),

            const SizedBox(height: 40),

            // ---------------- LOGOUT ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    LocalStorages().removeToken();
                    Get.offAll(() => LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "Version 1.0.0 • ${Platform.isAndroid ? "Android" : "iOS"}",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _buildProfileImage() {
    final imagePath = LocalStorages().getProfileImage();

    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset(
        "assets/images/default_user.png",
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    // LOCAL FILE CHECK
    if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    // NETWORK URL CHECK
    if (imagePath.startsWith("http")) {
      return Image.network(imagePath, width: 80, height: 80, fit: BoxFit.cover);
    }

    // FALLBACK
    return Image.asset(
      "assets/images/default_user.png",
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }

  // ------------------- ROW WIDGET -------------------
  Widget _profileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- DIVIDER -------------------
  Widget _divider() {
    return Container(
      height: 1,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.grey.shade300,
    );
  }
}
