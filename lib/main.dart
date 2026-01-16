import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/providers/theme_provider.dart';
import 'data/database/database_helper.dart';
import 'core/utils/logger.dart';
import 'presentation/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  try {
    await DatabaseHelper.instance.database;
    Logger.info('Database initialized');
  } catch (e) {
    Logger.error('Failed to initialize database', e);
  }
  
  runApp(
    const ProviderScope(
      child: FortiFiApp(),
    ),
  );
}

class FortiFiApp extends ConsumerWidget {
  const FortiFiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
