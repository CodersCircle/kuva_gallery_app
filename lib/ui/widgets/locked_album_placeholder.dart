import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// Placeholder for locked albums — no thumbnail fetch, clear lock affordance.
class LockedAlbumPlaceholder extends StatelessWidget {
  const LockedAlbumPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ColoredBox(
      color: KuvaColors.lockedTileTint(brightness),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 36,
            color: KuvaColors.primaryViolet,
          ),
          const SizedBox(height: 6),
          Text(
            'Locked',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: KuvaColors.primaryViolet,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// Navigation gate logic for locked albums (testable).
class AlbumAccessGuard {
  AlbumAccessGuard._();

  /// Returns true only when navigation to album content is allowed.
  static bool canNavigate({
    required bool isLocked,
    required Set<String> unlockedAlbumIds,
    required String albumId,
  }) {
    if (!isLocked) return true;
    return unlockedAlbumIds.contains(albumId);
  }
}
