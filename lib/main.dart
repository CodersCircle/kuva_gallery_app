import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:workmanager/workmanager.dart';

import 'core/constants/app_constants.dart';
import 'core/services/background_upload_worker.dart';
import 'core/services/pin_migration_service.dart';
import 'data/repositories/album_repository.dart';
import 'core/widgets/app_lock_observer.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/isar_database.dart';
import 'providers/app_providers.dart';
import 'ui/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await IsarDatabase.open();
  await PinMigrationService().migrateIfNeeded();
  await LockRepository().clearOrphanedMasterPinLocks();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    AppConstants.uploadTaskTag,
    AppConstants.uploadTaskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  runApp(const ProviderScope(child: KuvaGalleryApp()));
}

/// Root widget with theme and router.
class KuvaGalleryApp extends ConsumerWidget {
  const KuvaGalleryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return AppLockObserver(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: switch (themeMode) {
          AppThemeMode.system => ThemeMode.system,
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
        },
        routerConfig: router,
      ),
    );
  }
}
