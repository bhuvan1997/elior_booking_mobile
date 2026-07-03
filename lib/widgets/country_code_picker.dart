import 'package:elior/app_values/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/data_utils.dart';

class Country {
  final String name;
  final String code;

  Country(this.name, this.code);
}

class CountryCodePicker extends StatefulWidget {
  final Country initialCountry;
  final Function(Country) onChanged;

  const CountryCodePicker({
    super.key,
    required this.initialCountry,
    required this.onChanged,
  });

  @override
  CountryCodePickerState createState() => CountryCodePickerState();
}

class CountryCodePickerState extends State<CountryCodePicker> {
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
  }

  void _showCountryCodePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _CountryPickerSheet(
        selectedCountry: _selectedCountry,
        onSelected: (country) {
          setState(() {
            _selectedCountry = country;
          });
          widget.onChanged(country);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 12, right: 6),
      minSize: 0,
      onPressed: _showCountryCodePicker,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _selectedCountry.code,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            CupertinoIcons.chevron_down,
            size: 14,
            color: Colors.black.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onSelected;

  const _CountryPickerSheet({
    required this.selectedCountry,
    required this.onSelected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late List<Country> _filtered;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = DataUtils.countries;
  }

  void _filter(String query) {
    setState(() {
      _filtered = DataUtils.countries.where((country) {
        final q = query.toLowerCase();
        return country.name.toLowerCase().contains(q) ||
            country.code.contains(q);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Country Code',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: CupertinoColors.destructiveRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search country or code',
                onChanged: _filter,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                child: Text(
                  'No countries found',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: CupertinoColors.systemGrey5,
                ),
                itemBuilder: (context, index) {
                  final country = _filtered[index];
                  final isSelected =
                      country.code == widget.selectedCountry.code &&
                          country.name == widget.selectedCountry.name;

                  return CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    onPressed: () {
                      widget.onSelected(country);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            country.name,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: CupertinoColors.label,
                            ),
                          ),
                        ),
                        Text(
                          country.code,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            CupertinoIcons.check_mark,
                            size: 18,
                            color: AppTheme.appThemeColor,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}