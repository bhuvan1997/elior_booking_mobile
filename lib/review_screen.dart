import 'package:elior/hotel_booking/bottom_navigation_screen.dart';
import 'package:elior/widgets/app_button.dart';
import 'package:elior/widgets/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_values/app_theme.dart';
import 'network/service_provider.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
var _amber = AppTheme.appThemeColor;
const _amberSoft = Color(0xFFFFF4E5);
var _starFilled = AppTheme.appThemeColor;
const _starEmpty = Color(0xFFE0E0E0);
const _surface = Color(0xFFF7F7F7);
const _border = Color(0xFFEAEAEA);
const _textPrimary = Color(0xFF1A1A1A);
const _textSecondary = Color(0xFF7A7A7A);

// ── Label copy for each star count ───────────────────────────────────────────
const _ratingLabels = ['', 'Poor', 'Fair', 'Good', 'Great', 'Excellent'];

class ReviewScreen extends StatefulWidget {
  final int bookingId;

  const ReviewScreen({super.key, required this.bookingId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _selectedChip = 0;
  int _rating = 0;
  bool _isLoading = false;

  final _reviewController = TextEditingController();

  static const _chips = [
    'Great Stay, Worth the Money',
    'Average Experience, Could Be Better',
    'Comfortable Room & Good Service',
    'Not Worth the Price',
    'Disappointed with Cleanliness',
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // ── API call ────────────────────────────────────────────────────────────────

  Future<bool> _submitReview() async {
    try {
      setState(() => _isLoading = true);

      final response = await ServiceProvider().review(
        bookingId: widget.bookingId,
        starRating: _rating,
        title: _chips[_selectedChip],
        review: _reviewController.text.trim(),
      );

      if (response.status == true) return true;

      _showSnack(response.message ?? 'Something went wrong');
      return false;
    } catch (e) {
      debugPrint('ReviewScreen error: $e');
      _showSnack('Something went wrong');
      return false;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ── Validation ──────────────────────────────────────────────────────────────

  bool _validate() {
    if (_rating == 0) {
      _showSnack('Please select a rating');
      return false;
    }
    final text = _reviewController.text.trim();
    if (text.isEmpty) {
      _showSnack('Please write your review');
      return false;
    }
    if (text.length < 10) {
      _showSnack('Review must be at least 10 characters');
      return false;
    }
    return true;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_validate()) return;
    if (await _submitReview()) Get.offAll(BottomBarScreen());
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, 'Review', centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            _buildHeader(),
            const SizedBox(height: 24),
            _buildStarRating(),
            const SizedBox(height: 32),
            _buildSectionLabel('Select your review'),
            const SizedBox(height: 12),
            _buildChips(),
            const SizedBox(height: 28),
            _buildSectionLabel('Write a detailed review'),
            const SizedBox(height: 12),
            _buildTextArea(),
            const SizedBox(height: 32),
            AppButton(
              title: 'Submit Review',
              onTap: _isLoading ? null : _onSubmit,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Sub-widgets ─────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How was your stay?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your feedback helps us improve for everyone.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: _rating > 0 ? _amberSoft : _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _rating > 0 ? _amber.withValues(alpha: 0.3) : _border,
        ),
      ),
      child: Row(
        children: [
          // Stars
          Expanded(
            child: Row(
              children: List.generate(5, (i) {
                final filled = i < _rating;
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        filled ? Icons.star_rounded : Icons.star_outline_rounded,
                        key: ValueKey(filled),
                        size: 36,
                        color: filled ? _starFilled : _starEmpty,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Rating label
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _rating > 0
                ? Container(
              key: ValueKey(_rating),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _ratingLabels[_rating],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
      ),
    );
  }

  Widget _buildChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_chips.length, (i) {
        final selected = _selectedChip == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedChip = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? _amberSoft : _surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: selected ? _amber : _border,
                width: 1.5,
              ),
            ),
            child: Text(
              _chips[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? _amber : _textSecondary,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextArea() {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _reviewController,
            maxLines: 6,
            maxLength: 300,
            onChanged: (_) => setState(() {}),
            cursorColor: _amber,
            style: const TextStyle(fontSize: 14, color: _textPrimary),
            decoration: InputDecoration(
              hintText:
              'Tell us about the location, food, amenities, service…',
              hintStyle: const TextStyle(color: _textSecondary, fontSize: 14),
              counterText: '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, bottom: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_reviewController.text.length} / 300',
                style: const TextStyle(fontSize: 12, color: _textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}