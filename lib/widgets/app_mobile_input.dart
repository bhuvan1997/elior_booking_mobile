import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'country_code_picker.dart';

class AppMobileInput extends StatefulWidget {
  final TextEditingController controller;
  final Country initialCountry;
  final ValueChanged<Country>? onCountryChanged;
  final FormFieldValidator<String>? validator;

  const AppMobileInput({
    super.key,
    required this.controller,
    required this.initialCountry,
    this.onCountryChanged,
    this.validator,
  });

  @override
  State<AppMobileInput> createState() => _AppMobileInputState();
}

class _AppMobileInputState extends State<AppMobileInput> {
  late Country selectedCountry;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialCountry;
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.phone,
        maxLength: 15,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ],
        validator:
        widget.validator ??
                (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter mobile number";
              }
              return null;
            },
        decoration: InputDecoration(
          counterText: "",
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 4,
          ),
          labelStyle: TextStyle(
            color: _isFocused ? primaryColor : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primaryColor, width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.6),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryCodePicker(
                    initialCountry: selectedCountry,
                    onChanged: (country) {
                      setState(() {
                        selectedCountry = country;
                      });

                      widget.onCountryChanged?.call(country);
                    },
                  ),
                  const SizedBox(width: 10),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Colors.grey.shade300,
                    indent: 4,
                    endIndent: 4,
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