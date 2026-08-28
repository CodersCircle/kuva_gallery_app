import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/colors.dart';

/// Rounded-rectangle violet keypad with white digits.
class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    this.showBiometric = false,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometric;
  final bool showBiometric;
  final bool enabled;

  static const _keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '',
    '0',
    '⌫',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: _keys.length,
      itemBuilder: (context, index) {
        final key = _keys[index];
        if (key.isEmpty) {
          if (!showBiometric || onBiometric == null) {
            return const SizedBox.shrink();
          }
          return _KeyButton(
            enabled: enabled,
            onPressed: onBiometric!,
            child: Icon(
              Icons.fingerprint,
              size: 30,
              color: KuvaColors.accentMint,
            ),
          );
        }
        if (key == '⌫') {
          return _KeyButton(
            enabled: enabled,
            onPressed: onBackspace,
            child: const Icon(Icons.backspace_outlined, color: KuvaColors.white),
          );
        }
        return _KeyButton(
          enabled: enabled,
          onPressed: () => onDigit(key),
          child: Text(
            key,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: KuvaColors.white,
            ),
          ),
        );
      },
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.onPressed,
    required this.child,
    required this.enabled,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool enabled;

  static const _radius = 14.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? KuvaColors.primaryViolet
          : KuvaColors.primaryViolet.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(_radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(_radius),
        child: Center(child: child),
      ),
    );
  }
}

/// Filled PIN dots — violet as digits are entered (4-digit PIN).
class PinDots extends StatelessWidget {
  const PinDots({
    super.key,
    required this.length,
    this.maxLength = AppConstants.pinLength,
  });

  final int length;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (i) {
        final filled = i < length;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled
                  ? KuvaColors.primaryViolet
                  : KuvaColors.primaryViolet.withValues(alpha: 0.2),
            ),
          ),
        );
      }),
    );
  }
}
