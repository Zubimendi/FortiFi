import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/utils/logger.dart';

/// Database helper for SQLite operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fortifi.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // App Settings Table
    await db.execute('''
      CREATE TABLE app_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        master_password_hash TEXT NOT NULL,
        salt TEXT NOT NULL,
        biometric_enabled BOOLEAN DEFAULT 0,
        currency_code VARCHAR(3) DEFAULT 'USD',
        theme_mode VARCHAR(10) DEFAULT 'system',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Categories Table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(100) NOT NULL,
        icon_code INTEGER,
        color_hex VARCHAR(7),
        type VARCHAR(20) DEFAULT 'expense',
        is_default BOOLEAN DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Expenses Table
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount_encrypted TEXT NOT NULL,
        category_id INTEGER,
        description_encrypted TEXT,
        date DATE NOT NULL,
        payment_method VARCHAR(50),
        receipt_path TEXT,
        tags TEXT,
        is_recurring BOOLEAN DEFAULT 0,
        recurring_id INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
        FOREIGN KEY (recurring_id) REFERENCES recurring_expenses(id) ON DELETE CASCADE
      )
    ''');

    // Budgets Table
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        amount_encrypted TEXT NOT NULL,
        period VARCHAR(20) DEFAULT 'monthly',
        start_date DATE NOT NULL,
        end_date DATE,
        alert_threshold REAL DEFAULT 0.8,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');

    // Recurring Expenses Table
    await db.execute('''
      CREATE TABLE recurring_expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount_encrypted TEXT NOT NULL,
        category_id INTEGER,
        description_encrypted TEXT,
        frequency VARCHAR(20) NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE,
        next_occurrence DATE NOT NULL,
        is_active BOOLEAN DEFAULT 1,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
      )
    ''');

    // Analytics Cache Table
    await db.execute('''
      CREATE TABLE analytics_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cache_key VARCHAR(100) UNIQUE NOT NULL,
        data_encrypted TEXT NOT NULL,
        valid_until TIMESTAMP NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create indexes for performance
    await db.execute('CREATE INDEX idx_expenses_date ON expenses(date)');
    await db.execute('CREATE INDEX idx_expenses_category ON expenses(category_id)');
    await db.execute('CREATE INDEX idx_budgets_category ON budgets(category_id)');
    await db.execute('CREATE INDEX idx_budgets_dates ON budgets(start_date, end_date)');

    // Insert default categories
    await _insertDefaultCategories(db);

    Logger.info('Database created successfully');
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {'name': 'Housing', 'icon_code': 0xe88a, 'color_hex': '#2196F3', 'type': 'expense'},
      {'name': 'Utilities', 'icon_code': 0xe0e7, 'color_hex': '#FF9800', 'type': 'expense'},
      {'name': 'Health', 'icon_code': 0xe548, 'color_hex': '#4CAF50', 'type': 'expense'},
      {'name': 'Fun', 'icon_code': 0xe30f, 'color_hex': '#9C27B0', 'type': 'expense'},
      {'name': 'Groceries', 'icon_code': 0xe8cc, 'color_hex': '#FF9800', 'type': 'expense'},
      {'name': 'Transport', 'icon_code': 0xe531, 'color_hex': '#2196F3', 'type': 'expense'},
      {'name': 'Dining', 'icon_code': 0xe561, 'color_hex': '#F44336', 'type': 'expense'},
      {'name': 'Shopping', 'icon_code': 0xe8cb, 'color_hex': '#E91E63', 'type': 'expense'},
      {'name': 'Savings', 'icon_code': 0xe227, 'color_hex': '#FFC107', 'type': 'expense'},
      {'name': 'Education', 'icon_code': 0xe80c, 'color_hex': '#2196F3', 'type': 'expense'},
      {'name': 'Travel', 'icon_code': 0xe539, 'color_hex': '#009688', 'type': 'expense'},
      {'name': 'Other', 'icon_code': 0xe5d2, 'color_hex': '#9E9E9E', 'type': 'expense'},
    ];

    for (final category in defaultCategories) {
      await db.insert(
        'categories',
        {
          ...category,
          'is_default': 1,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    Logger.info('Default categories inserted');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
