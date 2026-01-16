import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Individual budget card with progress and alert threshold
class BudgetCard extends StatefulWidget {
  final String category;
  final IconData icon;
  final Color iconColor;
  final double spent;
  final double limit;
  final double alertThreshold;

  const BudgetCard({
    super.key,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.spent,
    required this.limit,
    required this.alertThreshold,
  });

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  late double _currentThreshold;

  @override
  void initState() {
    super.initState();
    _currentThreshold = widget.alertThreshold;
  }

  void _handleEdit() {
    // TODO: Navigate to edit budget screen
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.spent / widget.limit * 100).round();
    final isOverBudget = widget.spent >= widget.limit;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon, Category, Progress Circle
            Row(
              children: [
                // Category Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Category Name and Percentage
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$percentage% of monthly limit used',
                        style: AppTextStyles.bodySecondary.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Circular Progress Indicator
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: widget.spent / widget.limit,
                          strokeWidth: 6,
                          backgroundColor: AppColors.cardBackground.withOpacity(0.5),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isOverBudget ? Colors.red : widget.iconColor,
                          ),
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Amount Row: Spent/Limit and Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$${widget.spent.toStringAsFixed(0)}',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isOverBudget ? Colors.red : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '/ \$${widget.limit.toStringAsFixed(0)}',
                          style: AppTextStyles.bodySecondary.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SPENT THIS MONTH',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                // Edit Button
                OutlinedButton.icon(
                  onPressed: _handleEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                  label: Text(
                    'Edit',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(
                      color: AppColors.cardBackground.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Alert Threshold Slider
            Row(
              children: [
                Text(
                  'Alert threshold',
                  style: AppTextStyles.bodySecondary.copyWith(
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_currentThreshold.round()}%',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _currentThreshold,
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: AppColors.primaryBlue,
              inactiveColor: AppColors.cardBackground.withOpacity(0.5),
              onChanged: (value) {
                setState(() {
                  _currentThreshold = value;
                });
                // TODO: Save threshold to database
              },
            ),
          ],
        ),
      ),
    );
  }
}
