/// Budget data model
class BudgetModel {
  final int? id;
  final int? categoryId;
  final String amountEncrypted; // Encrypted budget amount
  final String period; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime startDate;
  final DateTime? endDate;
  final double alertThreshold; // Alert at this percentage (e.g., 0.8 = 80%)
  final DateTime createdAt;

  BudgetModel({
    this.id,
    this.categoryId,
    required this.amountEncrypted,
    this.period = 'monthly',
    required this.startDate,
    this.endDate,
    this.alertThreshold = 0.8,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'amount_encrypted': amountEncrypted,
      'period': period,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'alert_threshold': alertThreshold,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as int?,
      categoryId: map['category_id'] as int?,
      amountEncrypted: map['amount_encrypted'] as String,
      period: map['period'] as String? ?? 'monthly',
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      alertThreshold: (map['alert_threshold'] as num?)?.toDouble() ?? 0.8,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  BudgetModel copyWith({
    int? id,
    int? categoryId,
    String? amountEncrypted,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    double? alertThreshold,
    DateTime? createdAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amountEncrypted: amountEncrypted ?? this.amountEncrypted,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
