import 'dart:convert';
import 'package:elior/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
import '../app_values/app_theme.dart';
import '../utils/storage.dart';
import '../widgets/app_text_field.dart';
import '../widgets/toolbar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryCodeController = TextEditingController(text: "+91");
  final _contactController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isLoading = false;

  // -----------------------------------------------------
  // SUBMIT SUPPORT API CALL
  // -----------------------------------------------------
  Future<void> submitSupportTicket() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    const url = "https://eliorbooking.com/api/support-ticket-generate";

    final body = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "country_code": _countryCodeController.text.trim(),
      "phone": _contactController.text.trim(),
      "message": _descriptionController.text.trim(),
    };

    try {
      final token = LocalStorages().getToken() ?? "";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Get.snackbar(
          "Success",
          "Support ticket submitted!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        _nameController.clear();
        _emailController.clear();
        _contactController.clear();
        _descriptionController.clear();
      } else {
        print(response.body);
        Get.snackbar(
          "Failed",
          "Something went wrong!",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      Get.snackbar(
        "Error",
        "Unable to connect to server!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );

      print("API Error: $e");
    }
  }

  // -----------------------------------------------------
  // PHONE ROW (Country Code + Phone Number)
  // -----------------------------------------------------
  Widget _buildPhoneRow() {
    return Row(
      children: [
        // COUNTRY CODE BOX
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                favorite: ['IN', 'AE', 'US'],
                onSelect: (Country country) {
                  setState(() {
                    _countryCodeController.text = "+${country.phoneCode}";
                  });
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _countryCodeController.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.black54),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // PHONE NUMBER BOX
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: TextField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Enter number",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _nameController.text = LocalStorages().getName() ?? "";
    _emailController.text = LocalStorages().getEmail() ?? "";
    _contactController.text = LocalStorages().getMobile() ?? "";
    _countryCodeController.text = LocalStorages().getMobileCode() ?? "+91";
  }

  // -----------------------------------------------------
  // MAIN SCREEN UI
  // -----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Contact Us", centerTitle: false),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                _buildHeader(),

                const SizedBox(height: 20),

                _buildFormCard(),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AppButton(
              title: "Submit Ticket",
              onTap: isLoading ? null : submitSupportTicket,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.appThemeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppTheme.appThemeColor,
            child: const Icon(
              Icons.support_agent,
              size: 34,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            "Need Help?",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Tell us your issue and our team will get back to you shortly.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
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
            controller: _nameController,
            label: "Full Name",
            placeholder: "Enter your name",
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppTheme.appThemeColor,
            ),
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: _emailController,
            label: "Email Address",
            placeholder: "Enter your email",
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
            controller: _descriptionController,
            label: "Message",
            placeholder: "Describe your issue...",
            maxLines: 5,
            prefixIcon: const Icon(
              Icons.chat_bubble_outline,
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
              favorite: ['IN', 'AE', 'US'],
              onSelect: (country) {
                setState(() {
                  _countryCodeController.text = "+${country.phoneCode}";
                });
              },
            );
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  _countryCodeController.text,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: AppTextField(
            controller: _contactController,
            label: "Phone Number",
            placeholder: "Enter phone number",
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
}
