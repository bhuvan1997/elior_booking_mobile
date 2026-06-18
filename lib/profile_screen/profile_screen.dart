import 'dart:io';
import 'package:elior/app_values/app_theme.dart';
import 'package:elior/auth/login_screen.dart';
import 'package:elior/profile_screen/edit_profile.dart';
import 'package:elior/utils/storage.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = LocalStorages().getName() ?? "User Name";
    final email = LocalStorages().getEmail() ?? "user@example.com";
    final phone = LocalStorages().getMobile() ?? "+1 234 567 890";
    final image = LocalStorages().getProfileImage();
    final address = LocalStorages().getAddress() ?? "Address";
    final date = LocalStorages().getDob() ?? "DOB";

    return Scaffold(
      appBar: getAppBar(
        context,
        "Profile",
        centerTitle: false,
        trailing: [
          GestureDetector(
            onTap: () => Get.to(() => EditProfileScreen()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
              child: Text(
                "Edit",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.appThemeColor,
                ),
              ),
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),

            _buildInfoCard(),

            _buildLogoutCard(),

            const SizedBox(height: 20),

            Text(
              "Version 1.0.0 • ${Platform.isAndroid ? "Android" : "iOS"}",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: ClipOval(
            child: _buildProfileImage(),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          LocalStorages().getName() ?? "Guest User",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          LocalStorages().getEmail() ?? "",
          style: GoogleFonts.poppins(
            color: AppTheme.black.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoTile(
            Icons.person_outline,
            "Name",
            LocalStorages().getName() ?? "",
          ),

          _divider(),

          _infoTile(
            Icons.email_outlined,
            "Email",
            LocalStorages().getEmail() ?? "",
          ),

          _divider(),

          _infoTile(
            Icons.phone_outlined,
            "Mobile",
            LocalStorages().getMobile() ?? "",
          ),

          _divider(),

          _infoTile(
            Icons.location_on_outlined,
            "Address",
            LocalStorages().getAddress() ?? "",
          ),

          _divider(),

          _infoTile(
            Icons.cake_outlined,
            "Date of Birth",
            LocalStorages().getDob() ?? "",
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppTheme.appThemeColor.withOpacity(.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.appThemeColor,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? "Not Added" : value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            LocalStorages().removeToken();
            LocalStorages().clearAll();
            Get.offAll(() => LoginScreen());
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.red.shade700,
                ),
                const SizedBox(width: 12),
                Text(
                  "Logout",
                  style: GoogleFonts.poppins(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
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

  Widget _divider() {
    return Container(
      height: 1,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.grey.shade300,
    );
  }
}
