import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'transaction_item_new.dart';

/// Recent transactions section
class RecentTransactionsSectionNew extends StatelessWidget {
  const RecentTransactionsSectionNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: AppTextStyles.heading.copyWith(fontSize: 22),
              ),
              IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  // TODO: Show filter options
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Transaction items
          Column(
            children: [
              TransactionItemNew(
                merchant: 'Apple Store - Union Squ...',
                amount: -1299.00,
                date: DateTime.now(),
                category: 'Electronics',
                icon: Icons.shopping_bag,
                status: TransactionStatus.completed,
              ),
              const SizedBox(height: 12),
              TransactionItemNew(
                merchant: 'Blue Bottle Coffee',
                amount: -6.50,
                date: DateTime.now().subtract(const Duration(hours: 3)),
                category: 'Dining',
                icon: Icons.restaurant,
                status: TransactionStatus.completed,
              ),
              const SizedBox(height: 12),
              TransactionItemNew(
                merchant: 'Salary Deposit',
                amount: 8450.00,
                date: DateTime.now().subtract(const Duration(days: 1)),
                category: 'Income',
                icon: Icons.account_balance_wallet,
                status: TransactionStatus.received,
                isIncome: true,
              ),
              const SizedBox(height: 12),
              TransactionItemNew(
                merchant: 'Uber Technologies',
                amount: -24.80,
                date: DateTime.now().subtract(const Duration(days: 1)),
                category: 'Transport',
                icon: Icons.directions_car,
                status: TransactionStatus.pending,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
