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
      final existing = await db.query('user_profile', limit: 1);

      if (existing.isEmpty) {
        // Create new profile
        final profileMap = profile.toMap();
        profileMap.remove('updated_at'); // Let database set default
        await db.insert('user_profile', profileMap);
        Logger.info('User profile created');
      } else {
        // Update existing profile - use the actual ID from database
        final existingId = existing.first['id'] as int;
        final updateMap = profile.copyWith(updatedAt: DateTime.now()).toMap();
        updateMap.remove('created_at'); // Don't update created_at
        await db.update(
          'user_profile',
          updateMap,
          where: 'id = ?',
          whereArgs: [existingId],
        );
        Logger.info('User profile updated');
      }

      return true;
    } catch (e) {
      Logger.error('Failed to save user profile', e);
      rethrow; // Rethrow to get better error messages
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

      // Preserve existing values when updating
      return await saveProfile(
        profile.copyWith(
          name: name,
          updatedAt: DateTime.now(),
        ),
      );
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

      // Preserve existing values when updating
      return await saveProfile(
        profile.copyWith(
          profilePicturePath: imagePath,
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      Logger.error('Failed to update profile picture', e);
      return false;
    }
  }
}
