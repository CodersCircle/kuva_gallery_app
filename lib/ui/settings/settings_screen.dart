import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../domain/models/album_sort_mode.dart';
import '../../providers/app_providers.dart';

/// App settings screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLockOn = ref.watch(appLockEnabledProvider);
    final sortMode = ref.watch(albumSortModeProvider);
    final autoPlayNext = ref.watch(autoPlayNextVideoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          const _BrandHeader(),
          const _SectionHeader('Appearance', icon: Icons.palette_outlined),
          const _ThemeSelector(),
          const _SectionHeader('Albums', icon: Icons.photo_album_outlined),
          ListTile(
            leading: Icon(Icons.sort, color: KuvaColors.primaryViolet),
            title: const Text('Sort albums by'),
            trailing: DropdownButton<AlbumSortMode>(
              value: sortMode,
              underline: const SizedBox.shrink(),
              items: AlbumSortMode.values
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.label),
                    ),
                  )
                  .toList(),
              onChanged: (m) async {
                if (m == null) return;
                await ref.read(albumSortModeProvider.notifier).setMode(m);
                ref.invalidate(albumsProvider);
              },
            ),
          ),
          const _SectionHeader('Playback', icon: Icons.play_circle_outline),
          SwitchListTile(
            secondary: Icon(Icons.skip_next, color: KuvaColors.primaryViolet),
            title: const Text('Auto-play next video'),
            subtitle: const Text('In album viewer when a video ends'),
            value: autoPlayNext,
            onChanged: (v) =>
                ref.read(autoPlayNextVideoProvider.notifier).setEnabled(v),
          ),
          const _SectionHeader('Security', icon: Icons.shield_outlined),
          SwitchListTile(
            secondary: Icon(Icons.lock_outline, color: KuvaColors.primaryViolet),
            title: const Text('Enable App Lock'),
            subtitle: const Text('Require PIN when opening the app'),
            value: appLockOn,
            onChanged: (v) async {
              if (v) {
                final hasPin = await ref.read(pinServiceProvider).isPinSet();
                if (!hasPin && context.mounted) {
                  final created = await context.push<bool>('/pin-setup');
                  if (created != true) return;
                }
              }
              await ref.read(appLockEnabledProvider.notifier).setEnabled(v);
              if (!v) {
                ref.read(appLockedProvider.notifier).state = false;
              }
            },
          ),
          if (appLockOn) ...[
            ListTile(
              leading: Icon(Icons.timer_outlined, color: KuvaColors.primaryViolet),
              title: const Text('Lock timeout'),
              subtitle: const Text('Minutes of inactivity before re-lock'),
              trailing: const _LockTimeoutSelector(),
            ),
            ListTile(
              title: const Text('Lock now'),
              leading: Icon(Icons.lock_outline, color: KuvaColors.primaryViolet),
              onTap: () {
                ref.read(appLockedProvider.notifier).state = true;
                Navigator.pop(context);
              },
            ),
          ],
          const _SectionHeader('Backup', icon: Icons.cloud_outlined),
          const _TogglePref(
            title: 'Data saver (compress images)',
            prefKey: AppConstants.prefDataSaver,
            icon: Icons.compress,
          ),
          const _TogglePref(
            title: 'Wi-Fi only backup',
            prefKey: AppConstants.prefWifiOnlyBackup,
            icon: Icons.wifi,
          ),
          const _TogglePref(
            title: 'Backup vault items (encrypted)',
            prefKey: AppConstants.prefBackupVault,
            icon: Icons.enhanced_encryption_outlined,
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/kuva_logo.png',
            height: 72,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: KuvaColors.primaryViolet,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: KuvaColors.primaryViolet),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: KuvaColors.primaryViolet,
                ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SegmentedButton<AppThemeMode>(
        segments: const [
          ButtonSegment(value: AppThemeMode.system, label: Text('System')),
          ButtonSegment(value: AppThemeMode.light, label: Text('Light')),
          ButtonSegment(value: AppThemeMode.dark, label: Text('Dark')),
        ],
        selected: {mode},
        onSelectionChanged: (s) =>
            ref.read(themeModeProvider.notifier).setMode(s.first),
      ),
    );
  }
}

class _TogglePref extends StatefulWidget {
  const _TogglePref({
    required this.title,
    required this.prefKey,
    required this.icon,
  });

  final String title;
  final String prefKey;
  final IconData icon;

  @override
  State<_TogglePref> createState() => _TogglePrefState();
}

class _TogglePrefState extends State<_TogglePref> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _value = prefs.getBool(widget.prefKey) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(widget.icon, color: KuvaColors.primaryViolet),
      title: Text(widget.title),
      value: _value,
      onChanged: (v) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(widget.prefKey, v);
        setState(() => _value = v);
      },
    );
  }
}

class _LockTimeoutSelector extends StatefulWidget {
  const _LockTimeoutSelector();

  @override
  State<_LockTimeoutSelector> createState() => _LockTimeoutSelectorState();
}

class _LockTimeoutSelectorState extends State<_LockTimeoutSelector> {
  int _minutes = 5;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _minutes = prefs.getInt(AppConstants.prefLockTimeoutMinutes) ?? 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: _minutes,
      items: [1, 5, 15, 30, 60]
          .map((m) => DropdownMenuItem(value: m, child: Text('$m min')))
          .toList(),
      onChanged: (v) async {
        if (v == null) return;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(AppConstants.prefLockTimeoutMinutes, v);
        setState(() => _minutes = v);
      },
    );
  }
}
