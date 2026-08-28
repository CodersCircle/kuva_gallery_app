import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../../providers/app_providers.dart';

/// Re-locks the app on background only when app lock is enabled (#5).
class AppLockObserver extends ConsumerStatefulWidget {
  const AppLockObserver({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockObserver> createState() => _AppLockObserverState();
}

class _AppLockObserverState extends ConsumerState<AppLockObserver>
    with WidgetsBindingObserver {
  DateTime? _lastActive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastActive = DateTime.now();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lockEnabled = ref.read(appLockEnabledProvider);
    if (!lockEnabled) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ref.read(appLockedProvider.notifier).state = true;
    }
    if (state == AppLifecycleState.resumed) {
      _checkTimeout();
    }
  }

  Future<void> _checkTimeout() async {
    if (!ref.read(appLockEnabledProvider)) return;
    final prefs = await SharedPreferences.getInstance();
    final minutes = prefs.getInt(AppConstants.prefLockTimeoutMinutes) ?? 5;
    if (_lastActive != null &&
        DateTime.now().difference(_lastActive!) >
            Duration(minutes: minutes)) {
      ref.read(appLockedProvider.notifier).state = true;
    }
    _lastActive = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _lastActive = DateTime.now(),
      child: widget.child,
    );
  }
}
