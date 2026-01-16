/// User profile model
class UserProfileModel {
  final String? name;
  final String? profilePicturePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel({
    this.name,
    this.profilePicturePath,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profile_picture_path': profilePicturePath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      name: map['name'] as String?,
      profilePicturePath: map['profile_picture_path'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  UserProfileModel copyWith({
    String? name,
    String? profilePicturePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
