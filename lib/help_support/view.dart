import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
import '../utils/storage.dart';

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
      Get.snackbar("Error", "All fields are required!",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
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
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Get.snackbar("Success", "Support ticket submitted!",
            backgroundColor: Colors.green, colorText: Colors.white);

        _nameController.clear();
        _emailController.clear();
        _contactController.clear();
        _descriptionController.clear();
      } else {
        print(response.body);
        Get.snackbar("Failed", "Something went wrong!",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      setState(() => isLoading = false);

      Get.snackbar("Error", "Unable to connect to server!",
          backgroundColor: Colors.redAccent, colorText: Colors.white);

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

  // -----------------------------------------------------
  // INPUT FIELD UI
  // -----------------------------------------------------
  Widget _buildInputField({
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  // -----------------------------------------------------
  // MAIN SCREEN UI
  // -----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let us know how we can assist you.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            // NAME
            const Text("Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _buildInputField(controller: _nameController),

            const SizedBox(height: 20),

            // EMAIL
            const Text("Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _buildInputField(controller: _emailController),

            const SizedBox(height: 20),

            // CONTACT NUMBER ROW
            const Text("Contact Number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _buildPhoneRow(),

            const SizedBox(height: 20),

            // MESSAGE
            const Text("Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _buildInputField(controller: _descriptionController, maxLines: 4),

            const SizedBox(height: 40),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitSupportTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
