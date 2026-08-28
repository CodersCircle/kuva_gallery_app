import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/app_providers.dart';
import 'widgets/pin_keypad.dart';

/// PIN entry screen for app lock and album unlock.
class PinEntryScreen extends ConsumerStatefulWidget {
  const PinEntryScreen({
    super.key,
    required this.title,
    this.albumId,
    required this.onSuccessRoute,
    this.popOnSuccess = false,
  });

  final String title;
  final String? albumId;
  final String onSuccessRoute;
  final bool popOnSuccess;

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  var _pin = '';
  var _error = '';
  var _loading = false;
  var _ready = false;
  var _biometricAvailable = false;
  var _orphanedLock = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Warm secure-storage reads before verification can run.
    await ref.read(pinServiceProvider).isPinSet();

    final prefs = await SharedPreferences.getInstance();
    final biometricEnabled =
        prefs.getBool(AppConstants.prefBiometricEnabled) ?? false;
    final bio = ref.read(biometricServiceProvider);
    final bioAvailable = await bio.isAvailable();

    var orphaned = false;
    if (widget.albumId != null) {
      orphaned = await ref
          .read(lockRepositoryProvider)
          .isOrphanedAlbumLock(widget.albumId!);
    }

    if (!mounted) return;
    setState(() {
      _biometricAvailable = biometricEnabled && bioAvailable;
      _orphanedLock = orphaned;
      _ready = true;
    });
  }

  void _onDigit(String digit) {
    if (!_ready || _loading || _pin.length >= AppConstants.pinLength) return;
    setState(() {
      _pin += digit;
      _error = '';
    });
    if (_pin.length == AppConstants.pinLength) {
      _submit();
    }
  }

  void _onBackspace() {
    if (!_ready || _loading || _pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = '';
    });
  }

  Future<void> _submit() async {
    if (!_ready || _pin.length != AppConstants.pinLength) return;

    setState(() {
      _loading = true;
      _error = '';
    });

    final pin = _pin;
    var valid = false;

    if (widget.albumId != null) {
      valid = await ref
          .read(lockRepositoryProvider)
          .verifyAlbumPin(widget.albumId!, pin);
      if (valid) {
        ref.read(unlockedAlbumsProvider.notifier).update(
              (s) => {...s, widget.albumId!},
            );
      }
    } else {
      valid = await ref.read(pinServiceProvider).verifyPin(pin);
      if (valid) {
        ref.read(appLockedProvider.notifier).state = false;
      }
    }

    if (!mounted) return;
    setState(() => _loading = false);

    if (valid) {
      _onUnlockSuccess();
    } else {
      final orphaned = widget.albumId != null &&
          await ref
              .read(lockRepositoryProvider)
              .isOrphanedAlbumLock(widget.albumId!);
      setState(() {
        _orphanedLock = orphaned;
        _error = orphaned
            ? 'App PIN was reset. Set your PIN below to unlock.'
            : 'Incorrect PIN';
        _pin = '';
      });
    }
  }

  Future<void> _repairOrphanedLock() async {
    if (widget.albumId == null || _pin.length != AppConstants.pinLength) return;
    setState(() => _loading = true);
    try {
      await ref.read(lockRepositoryProvider).repairOrphanedAlbumLock(
            albumId: widget.albumId!,
            pin: _pin,
          );
      ref.read(unlockedAlbumsProvider.notifier).update(
            (s) => {...s, widget.albumId!},
          );
      if (mounted) _onUnlockSuccess();
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Could not set PIN. Try again.';
          _pin = '';
        });
      }
    }
  }

  Future<void> _removeAlbumLock() async {
    if (widget.albumId == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove album lock?'),
        content: const Text(
          'This will remove the PIN lock from this album without opening it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove lock'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await ref.read(lockRepositoryProvider).unlockAlbum(widget.albumId!);
    ref.invalidate(albumLockedProvider(widget.albumId!));
    if (mounted) context.pop(true);
  }

  void _onUnlockSuccess() {
    if (widget.popOnSuccess) {
      context.pop(true);
    } else {
      context.go(widget.onSuccessRoute);
    }
  }

  Future<void> _biometric() async {
    if (!_ready || _loading) return;
    final bio = ref.read(biometricServiceProvider);
    if (await bio.authenticate()) {
      if (widget.albumId != null) {
        ref.read(unlockedAlbumsProvider.notifier).update(
              (s) => {...s, widget.albumId!},
            );
      } else {
        ref.read(appLockedProvider.notifier).state = false;
      }
      if (mounted) _onUnlockSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(),
              PinDots(length: _pin.length),
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  _error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              if (_loading) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
              const Spacer(),
              PinKeypad(
                enabled: _ready && !_loading,
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                onBiometric: _biometric,
                showBiometric: _biometricAvailable,
              ),
              const SizedBox(height: 16),
              if (_orphanedLock && widget.albumId != null) ...[
                FilledButton(
                  onPressed: _ready &&
                          _pin.length == AppConstants.pinLength &&
                          !_loading
                      ? _repairOrphanedLock
                      : null,
                  child: const Text('Set PIN & unlock'),
                ),
                const SizedBox(height: 8),
              ],
              FilledButton(
                onPressed: _ready &&
                        _pin.length == AppConstants.pinLength &&
                        !_loading
                    ? _submit
                    : null,
                child: const Text('Unlock'),
              ),
              if (widget.albumId != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _loading ? null : _removeAlbumLock,
                  child: const Text('Remove album lock'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
