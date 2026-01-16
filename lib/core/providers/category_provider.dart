import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/category_model.dart';

/// Provider for category repository
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

/// Category list state
class CategoryListState {
  final List<CategoryModel> categories;
  final bool isLoading;
  final String? error;

  CategoryListState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoryListState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoryListState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Category list notifier
class CategoryListNotifier extends StateNotifier<CategoryListState> {
  final CategoryRepository _repository;

  CategoryListNotifier(this._repository) : super(CategoryListState()) {
    loadCategories();
  }

  /// Load all categories
  Future<void> loadCategories({String? type}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final categories = await _repository.getAllCategories(type: type);
      state = state.copyWith(
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get category by ID
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      return await _repository.getCategoryById(id);
    } catch (e) {
      return null;
    }
  }

  /// Create new category
  Future<bool> createCategory(CategoryModel category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.createCategory(category);
      await loadCategories();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update category
  Future<bool> updateCategory(CategoryModel category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateCategory(category);
      await loadCategories();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Delete category
  Future<bool> deleteCategory(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteCategory(id);
      await loadCategories();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
}

/// Category list provider
final categoryListProvider =
    StateNotifierProvider<CategoryListNotifier, CategoryListState>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryListNotifier(repository);
});

/// Provider for expense categories only
final expenseCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getAllCategories(type: 'expense');
});
