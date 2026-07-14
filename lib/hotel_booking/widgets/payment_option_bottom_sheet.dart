import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elior/app_values/app_theme.dart';

class PaymentOptionBottomSheet extends StatelessWidget {
  final String selectedOption;
  final Function(String option, int paymentType) onOptionSelected;

  const PaymentOptionBottomSheet({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose Payment Option",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _PayOptionCard(
            text: "Pay Full Amount",
            isSelected: selectedOption == "Pay Full Amount",
            onTap: () {
              onOptionSelected("Pay Full Amount", 1);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
          _PayOptionCard(
            text: "Pay At Property",
            isSelected: selectedOption == "Pay At Property",
            subtext: "Pay 5% here and remaining at property",
            onTap: () {
              onOptionSelected("Pay At Property", 2);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _PayOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final String? subtext;
  final VoidCallback onTap;

  const _PayOptionCard({
    required this.text,
    required this.isSelected,
    this.subtext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.appThemeColor.withValues(alpha: 0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppTheme.appThemeColor
                : Colors.grey.withValues(alpha: 0.2),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtext != null) ...[
              const SizedBox(height: 4),
              Text(
                subtext!,
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}