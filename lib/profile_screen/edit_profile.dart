import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/storage.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late dio.Dio _dio;

  final nameCtrl = TextEditingController(text: LocalStorages().getName());
  final emailCtrl = TextEditingController(text: LocalStorages().getEmail());
  final mobileCtrl = TextEditingController(text: LocalStorages().getMobile());
  final dobCtrl = TextEditingController(text: LocalStorages().getDob());
  final addressCtrl = TextEditingController(text: LocalStorages().getAddress());

  String selectedGender = "M";
  String selectedCountryCode = LocalStorages().getMobileCode()??"";

  File? localPickedImage;
  String? apiImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: "https://eliorbooking.com/api/",
        followRedirects: true,
        validateStatus: (status) => status! < 500,
        headers: {
          "Authorization": "Bearer ${LocalStorages().getToken() ?? ""}",
          "Accept": "application/json",
        },
      ),
    );

    // Load local saved image
    final savedPath = LocalStorages().getProfileImage();
    if (savedPath != null &&
        savedPath.isNotEmpty &&
        File(savedPath).existsSync()) {
      localPickedImage = File(savedPath);
    }

    loadProfileData();
  }

  Future<void> loadProfileData() async {
    try {
      final response = await _dio.get("profile");

      if (response.statusCode == 200 && response.data["status"] == true) {
        final data = response.data["data"] ?? {};

        nameCtrl.text = data["name"] ?? "";
        emailCtrl.text = data["email"] ?? "";
        mobileCtrl.text = data["mobile"] ?? "";
        selectedCountryCode = data["mobile_code"] ?? "+225";
        dobCtrl.text = data["dob"] ?? "";
        addressCtrl.text = data["address"] ?? "";

        if (data["profile_image"] != null) {
          apiImageUrl =
              "https://eliorbooking.com/public/uploads/profile/${data['profile_image']}";

          /// IMPORTANT – Save the API URL locally
          LocalStorages().saveProfileImage(apiImageUrl!);
        }

        setState(() {});
      }
    } catch (e) {
      print("Profile Load Error: $e");
    }
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = picked.path.split("/").last;
    final savedImage = File("${directory.path}/$fileName");

    await File(picked.path).copy(savedImage.path);

    setState(() => localPickedImage = savedImage);

    /// Save local picked image path
    LocalStorages().saveProfileImage(savedImage.path);
  }

  bool isLoading = false;

  Future<void> submitForm() async {
    try {
      setState(() => isLoading = true); // START LOADER

      final formData = dio.FormData.fromMap({
        "name": nameCtrl.text,
        "email": emailCtrl.text,
        "mobile_code": selectedCountryCode,
        "mobile": mobileCtrl.text,
        "gender": selectedGender,
        "dob": dobCtrl.text,
        "address": addressCtrl.text,
      });

      if (localPickedImage != null) {
        formData.files.add(
          MapEntry(
            "profile_image",
            await dio.MultipartFile.fromFile(localPickedImage!.path),
          ),
        );
      }

      final response = await _dio.post("update-profile", data: formData);

      if (response.statusCode == 200 && response.data["status"] == true) {
        LocalStorages().saveName(name: nameCtrl.text);
        LocalStorages().saveEmail(email: emailCtrl.text);
        LocalStorages().saveMobile(mobile: mobileCtrl.text);
        LocalStorages().saveMobileCode(mobileCode: selectedCountryCode);
        LocalStorages().saveAddress(address: addressCtrl.text);
        LocalStorages().saveDob(dob: dobCtrl.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomBarScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false); // STOP LOADER
    }
  }

  Widget buildProfileAvatar() {
    final savedPath = LocalStorages().getProfileImage();

    /// 1. If user picked image → show it
    if (localPickedImage != null && localPickedImage!.existsSync()) {
      return CircleAvatar(
        radius: 55,
        backgroundImage: FileImage(localPickedImage!),
      );
    }

    /// 2. If saved path is a local file
    if (savedPath != null &&
        savedPath.isNotEmpty &&
        File(savedPath).existsSync()) {
      return CircleAvatar(
        radius: 55,
        backgroundImage: FileImage(File(savedPath)),
      );
    }

    /// 3. If saved path is a URL from API
    if (savedPath != null && savedPath.startsWith("http")) {
      return CircleAvatar(radius: 55, backgroundImage: NetworkImage(savedPath));
    }

    /// 4. Default image
    return const CircleAvatar(
      radius: 55,
      backgroundImage: AssetImage("assets/images/default_user.png"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                children: [
                  buildProfileAvatar(),
                  const Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Text fields
            buildField(nameCtrl, "Full Name", Icons.person),
            const SizedBox(height: 15),
            buildField(emailCtrl, "Email", Icons.email),
            const SizedBox(height: 15),

            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (c) {
                        setState(() => selectedCountryCode = "+${c.phoneCode}");
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(selectedCountryCode),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildField(
                    mobileCtrl,
                    "Mobile",
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            buildField(
              dobCtrl,
              "Date of Birth",
              Icons.calendar_today,
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.tryParse(dobCtrl.text) ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  dobCtrl.text = picked.toIso8601String().split("T").first;
                }
              },
            ),

            const SizedBox(height: 15),
            buildField(addressCtrl, "Address", Icons.home),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitForm,
                // DISABLED WHEN LOADING
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Update Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
