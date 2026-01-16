import '../database/database_helper.dart';
import '../models/category_model.dart';
import '../../core/utils/logger.dart';

/// Repository for category operations
class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Get all categories
  Future<List<CategoryModel>> getAllCategories({String? type}) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps;

      if (type != null) {
        maps = await db.query(
          'categories',
          where: 'type = ?',
          whereArgs: [type],
          orderBy: 'name ASC',
        );
      } else {
        maps = await db.query(
          'categories',
          orderBy: 'name ASC',
        );
      }

      return maps.map((map) => CategoryModel.fromMap(map)).toList();
    } catch (e) {
      Logger.error('Failed to get categories', e);
      rethrow;
    }
  }

  /// Get category by ID
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return CategoryModel.fromMap(maps.first);
    } catch (e) {
      Logger.error('Failed to get category by ID', e);
      rethrow;
    }
  }

  /// Create a new category
  Future<int> createCategory(CategoryModel category) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert('categories', category.toMap());
    } catch (e) {
      Logger.error('Failed to create category', e);
      rethrow;
    }
  }

  /// Update category
  Future<int> updateCategory(CategoryModel category) async {
    try {
      final db = await _dbHelper.database;
      return await db.update(
        'categories',
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    } catch (e) {
      Logger.error('Failed to update category', e);
      rethrow;
    }
  }

  /// Delete category
  Future<int> deleteCategory(int id) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      Logger.error('Failed to delete category', e);
      rethrow;
    }
  }
}
