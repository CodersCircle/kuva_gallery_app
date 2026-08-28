import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/app_providers.dart';

/// First-launch PIN setup screen.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  var _enableBiometric = false;
  var _error = '';

  Future<void> _save() async {
    final pin = _pinController.text;
    final confirm = _confirmController.text;
    if (pin.length != AppConstants.pinLength) {
      setState(() => _error = 'PIN must be exactly ${AppConstants.pinLength} digits');
      return;
    }
    if (pin != confirm) {
      setState(() => _error = 'PINs do not match');
      return;
    }
    try {
      await ref.read(pinServiceProvider).setPin(pin);
      final prefs = await SharedPreferences.getInstance();
      if (_enableBiometric) {
        await prefs.setBool(AppConstants.prefBiometricEnabled, true);
      }
      await prefs.setInt(
        AppConstants.prefPinSchemaVersion,
        AppConstants.currentPinSchemaVersion,
      );
      await prefs.setBool(AppConstants.prefForcePinReset, false);
      ref.read(appLockedProvider.notifier).state = false;
      ref.invalidate(pinSetupProvider);
      if (mounted) context.pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set up PIN')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create a ${AppConstants.pinLength}-digit PIN to protect your gallery and vault.',
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: AppConstants.pinLength,
              decoration: const InputDecoration(labelText: 'PIN'),
            ),
            TextField(
              controller: _confirmController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: AppConstants.pinLength,
              decoration: const InputDecoration(labelText: 'Confirm PIN'),
            ),
            if (_error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            SwitchListTile(
              title: const Text('Enable biometric unlock'),
              value: _enableBiometric,
              onChanged: (v) => setState(() => _enableBiometric = v),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _save,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
}
