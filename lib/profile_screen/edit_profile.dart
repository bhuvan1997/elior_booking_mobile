import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../app_values/app_theme.dart';
import '../utils/storage.dart';
import '../widgets/app_text_field.dart';

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
          SnackBar(content: Text("profile_updated_success".tr)),
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
      ).showSnackBar(SnackBar(content: Text("${"error_label".tr}: $e")));
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
      appBar: getAppBar(context, "edit_profile".tr, centerTitle: false),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),

                const SizedBox(height: 24),

                _buildFormCard(),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AppButton(title: "update_profile".tr, onTap: isLoading ? null : submitForm,),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: pickImage,
      child: Stack(
        children: [
          Container(
            height: 110,
            width: 110,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: _buildProfileAvatarImage(),
            ),
          ),

          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.appThemeColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatarImage() {
    final savedPath = LocalStorages().getProfileImage();

    if (localPickedImage != null &&
        localPickedImage!.existsSync()) {
      return Image.file(
        localPickedImage!,
        fit: BoxFit.cover,
      );
    }

    if (savedPath != null &&
        File(savedPath).existsSync()) {
      return Image.file(
        File(savedPath),
        fit: BoxFit.cover,
      );
    }

    if (savedPath != null &&
        savedPath.startsWith("http")) {
      return Image.network(
        savedPath,
        fit: BoxFit.cover,
      );
    }

    return Image.asset(
      "assets/images/default_user.png",
      fit: BoxFit.cover,
    );
  }

  Widget _buildFormCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AppTextField(
            controller: nameCtrl,
            label: "full_name".tr,
            placeholder: "enter_your_full_name".tr,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppTheme.appThemeColor,
            ),
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: emailCtrl,
            label: "email_address".tr,
            placeholder: "enter_your_email".tr,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppTheme.appThemeColor,
            ),
          ),

          const SizedBox(height: 16),

          _buildPhoneField(),

          const SizedBox(height: 16),

          AppTextField(
            controller: dobCtrl,
            label: "date_of_birth".tr,
            placeholder: "select_date_of_birth".tr,
            readOnly: true,
            onTap: _selectDob,
            prefixIcon: const Icon(
              Icons.cake_outlined,
              color: AppTheme.appThemeColor,
            ),
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: addressCtrl,
            label: "address".tr,
            placeholder: "enter_your_address".tr,
            maxLines: 3,
            prefixIcon: const Icon(
              Icons.location_on_outlined,
              color: AppTheme.appThemeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (country) {
                setState(() {
                  selectedCountryCode = "+${country.phoneCode}";
                });
              },
            );
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  selectedCountryCode,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: AppTextField(
            controller: mobileCtrl,
            label: "mobile_number".tr,
            placeholder: "enter_mobile_number".tr,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppTheme.appThemeColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDob() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
      DateTime.tryParse(dobCtrl.text) ??
          DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobCtrl.text =
          picked.toIso8601String().split("T").first;
    }
  }
}