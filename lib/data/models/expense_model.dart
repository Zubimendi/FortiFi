/// Expense data model
class ExpenseModel {
  final int? id;
  final String amountEncrypted; // Encrypted amount
  final int? categoryId;
  final String? descriptionEncrypted; // Encrypted description
  final DateTime date;
  final String? paymentMethod;
  final String? receiptPath;
  final String? tags; // JSON array
  final bool isRecurring;
  final int? recurringId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExpenseModel({
    this.id,
    required this.amountEncrypted,
    this.categoryId,
    this.descriptionEncrypted,
    required this.date,
    this.paymentMethod,
    this.receiptPath,
    this.tags,
    this.isRecurring = false,
    this.recurringId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount_encrypted': amountEncrypted,
      'category_id': categoryId,
      'description_encrypted': descriptionEncrypted,
      'date': date.toIso8601String().split('T')[0], // Store as date only
      'payment_method': paymentMethod,
      'receipt_path': receiptPath,
      'tags': tags,
      'is_recurring': isRecurring ? 1 : 0,
      'recurring_id': recurringId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as int?,
      amountEncrypted: map['amount_encrypted'] as String,
      categoryId: map['category_id'] as int?,
      descriptionEncrypted: map['description_encrypted'] as String?,
      date: DateTime.parse(map['date'] as String),
      paymentMethod: map['payment_method'] as String?,
      receiptPath: map['receipt_path'] as String?,
      tags: map['tags'] as String?,
      isRecurring: (map['is_recurring'] as int? ?? 0) == 1,
      recurringId: map['recurring_id'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  ExpenseModel copyWith({
    int? id,
    String? amountEncrypted,
    int? categoryId,
    String? descriptionEncrypted,
    DateTime? date,
    String? paymentMethod,
    String? receiptPath,
    String? tags,
    bool? isRecurring,
    int? recurringId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      amountEncrypted: amountEncrypted ?? this.amountEncrypted,
      categoryId: categoryId ?? this.categoryId,
      descriptionEncrypted: descriptionEncrypted ?? this.descriptionEncrypted,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      receiptPath: receiptPath ?? this.receiptPath,
      tags: tags ?? this.tags,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringId: recurringId ?? this.recurringId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
