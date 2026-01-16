import '../database/database_helper.dart';
import '../models/user_profile_model.dart';
import '../../core/utils/logger.dart';

/// Repository for user profile operations
class UserProfileRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Get user profile
  Future<UserProfileModel?> getProfile() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('user_profile', limit: 1);

      if (maps.isEmpty) return null;
      return UserProfileModel.fromMap(maps.first);
    } catch (e) {
      Logger.error('Failed to get user profile', e);
      return null;
    }
  }

  /// Create or update user profile
  Future<bool> saveProfile(UserProfileModel profile) async {
    try {
      final db = await _dbHelper.database;
      final existing = await getProfile();

      if (existing == null) {
        // Create new profile
        await db.insert('user_profile', profile.toMap());
      } else {
        // Update existing profile
        await db.update(
          'user_profile',
          profile.copyWith(updatedAt: DateTime.now()).toMap(),
          where: 'id = ?',
          whereArgs: [1], // Assuming single user
        );
      }

      Logger.info('User profile saved');
      return true;
    } catch (e) {
      Logger.error('Failed to save user profile', e);
      return false;
    }
  }

  /// Update user name
  Future<bool> updateName(String name) async {
    try {
      final profile = await getProfile();
      if (profile == null) {
        return await saveProfile(
          UserProfileModel(name: name, createdAt: DateTime.now()),
        );
      }

      return await saveProfile(profile.copyWith(name: name));
    } catch (e) {
      Logger.error('Failed to update name', e);
      return false;
    }
  }

  /// Update profile picture
  Future<bool> updateProfilePicture(String? imagePath) async {
    try {
      final profile = await getProfile();
      if (profile == null) {
        return await saveProfile(
          UserProfileModel(
            profilePicturePath: imagePath,
            createdAt: DateTime.now(),
          ),
        );
      }

      return await saveProfile(profile.copyWith(profilePicturePath: imagePath));
    } catch (e) {
      Logger.error('Failed to update profile picture', e);
      return false;
    }
  }
}
