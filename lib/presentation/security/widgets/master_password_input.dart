import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Password strength levels
enum PasswordStrength {
  weak,
  medium,
  strong,
  veryStrong,
}

/// Master password input widget with strength indicator
class MasterPasswordInput extends StatefulWidget {
  final TextEditingController controller;

  const MasterPasswordInput({
    super.key,
    required this.controller,
  });

  @override
  State<MasterPasswordInput> createState() => _MasterPasswordInputState();
}

class _MasterPasswordInputState extends State<MasterPasswordInput> {
  bool _isPasswordVisible = false;
  PasswordStrength _strength = PasswordStrength.weak;

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    if (score <= 5) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return AppColors.error;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  double _getStrengthProgress(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  String _getStrengthMessage(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Use a mix of letters, numbers, and symbols';
      case PasswordStrength.medium:
        return 'Good, but could be stronger';
      case PasswordStrength.strong:
        return 'Great! This password is very secure.';
      case PasswordStrength.veryStrong:
        return 'Excellent! This password is extremely secure.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Password Label
        Text(
          'Master Password',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        // Password Input Field
        TextField(
          controller: widget.controller,
          obscureText: !_isPasswordVisible,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              _strength = _calculateStrength(value);
            });
          },
        ),
        const SizedBox(height: 24),
        // Password Strength Label
        Text(
          'Password Strength',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        // Strength Progress Bar
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _getStrengthProgress(_strength),
                  backgroundColor: AppColors.cardBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getStrengthColor(_strength),
                  ),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _getStrengthText(_strength),
              style: AppTextStyles.body.copyWith(
                color: _getStrengthColor(_strength),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Strength Message
        if (widget.controller.text.isNotEmpty)
          Row(
            children: [
              Icon(
                _strength == PasswordStrength.strong ||
                        _strength == PasswordStrength.veryStrong
                    ? Icons.check_circle
                    : Icons.info_outline,
                color: _getStrengthColor(_strength),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getStrengthMessage(_strength),
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: _getStrengthColor(_strength),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
