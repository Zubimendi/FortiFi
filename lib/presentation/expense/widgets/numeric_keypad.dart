import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Numeric keypad for entering amounts
class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onInput;

  const NumericKeypad({
    super.key,
    required this.onInput,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Row 1: 1, 2, 3
            Row(
              children: [
                _KeypadButton(label: '1', onTap: () => onInput('1')),
                const SizedBox(width: 12),
                _KeypadButton(label: '2', onTap: () => onInput('2')),
                const SizedBox(width: 12),
                _KeypadButton(label: '3', onTap: () => onInput('3')),
              ],
            ),
            const SizedBox(height: 12),
            // Row 2: 4, 5, 6
            Row(
              children: [
                _KeypadButton(label: '4', onTap: () => onInput('4')),
                const SizedBox(width: 12),
                _KeypadButton(label: '5', onTap: () => onInput('5')),
                const SizedBox(width: 12),
                _KeypadButton(label: '6', onTap: () => onInput('6')),
              ],
            ),
            const SizedBox(height: 12),
            // Row 3: 7, 8, 9
            Row(
              children: [
                _KeypadButton(label: '7', onTap: () => onInput('7')),
                const SizedBox(width: 12),
                _KeypadButton(label: '8', onTap: () => onInput('8')),
                const SizedBox(width: 12),
                _KeypadButton(label: '9', onTap: () => onInput('9')),
              ],
            ),
            const SizedBox(height: 12),
            // Row 4: ., 0, backspace
            Row(
              children: [
                _KeypadButton(label: '.', onTap: () => onInput('.')),
                const SizedBox(width: 12),
                _KeypadButton(label: '0', onTap: () => onInput('0')),
                const SizedBox(width: 12),
                _KeypadButton(
                  label: '',
                  icon: Icons.backspace_outlined,
                  onTap: () => onInput('backspace'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _KeypadButton({
    required this.label,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: icon != null
                  ? Icon(
                      icon,
                      color: AppColors.textPrimary,
                      size: 24,
                    )
                  : Text(
                      label,
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
