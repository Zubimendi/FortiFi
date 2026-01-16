import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Transaction status enum
enum TransactionStatus { completed, pending, received }

/// Individual transaction item for recent transactions
class TransactionItemNew extends StatelessWidget {
  final String merchant;
  final double amount;
  final DateTime date;
  final String category;
  final IconData icon;
  final TransactionStatus status;
  final bool isIncome;

  const TransactionItemNew({
    super.key,
    required this.merchant,
    required this.amount,
    required this.date,
    required this.category,
    required this.icon,
    required this.status,
    this.isIncome = false,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today, ${_formatTime(date)}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
      case TransactionStatus.received:
        return AppColors.success;
      case TransactionStatus.pending:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'COMPLETED';
      case TransactionStatus.pending:
        return 'PENDING';
      case TransactionStatus.received:
        return 'RECEIVED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBgColor = isIncome ? AppColors.success : AppColors.cardBackground;
    final amountColor = isIncome
        ? AppColors.success
        : (amount < 0 ? AppColors.textPrimary : AppColors.success);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackground : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor.withOpacity(isDark ? 0.3 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isIncome ? AppColors.success : AppColors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Merchant and details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatDate(date),
                      style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                    ),
                    Text(
                      ' • $category',
                      style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Amount and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${amount >= 0 ? '+' : ''}\$${amount.abs().toStringAsFixed(2)}',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getStatusText(status),
                  style: AppTextStyles.badge.copyWith(
                    fontSize: 10,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
