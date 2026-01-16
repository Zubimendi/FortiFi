/// Category data model
class CategoryModel {
  final int? id;
  final String name;
  final int? iconCode;
  final String? colorHex;
  final String type; // 'expense' or 'income'
  final bool isDefault;
  final DateTime createdAt;

  CategoryModel({
    this.id,
    required this.name,
    this.iconCode,
    this.colorHex,
    this.type = 'expense',
    this.isDefault = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_code': iconCode,
      'color_hex': colorHex,
      'type': type,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      iconCode: map['icon_code'] as int?,
      colorHex: map['color_hex'] as String?,
      type: map['type'] as String? ?? 'expense',
      isDefault: (map['is_default'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    int? iconCode,
    String? colorHex,
    String? type,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
