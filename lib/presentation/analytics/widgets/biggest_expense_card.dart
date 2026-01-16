import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Biggest expense card
class BiggestExpenseCard extends StatelessWidget {
  const BiggestExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biggest Expense',
            style: AppTextStyles.heading.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackground : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trend indicator
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '12% VS LAST MONTH',
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Merchant name
                          Text(
                            'Apple Store',
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Category and date
                          Text(
                            'Shopping • Oct 12, 2023',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Amount
                          Text(
                            '\$1,299.00',
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // View Details button
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to expense details
                            },
                            icon: const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                            label: Text(
                              'View Details',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: BorderSide(
                                color: isDark
                                    ? AppColors.cardBackground.withOpacity(0.5)
                                    : Colors.grey.shade300,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Receipt thumbnail
                    Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardBackground.withOpacity(0.5)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          // Placeholder for receipt image
                          Center(
                            child: Icon(
                              Icons.receipt_long,
                              color: AppColors.textSecondary,
                              size: 40,
                            ),
                          ),
                          // Wallet icon overlay
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.textPrimary,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
