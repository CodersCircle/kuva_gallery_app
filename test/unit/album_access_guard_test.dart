import 'package:flutter_test/flutter_test.dart';

import 'package:kuva_gallery_app/ui/widgets/locked_album_placeholder.dart';

void main() {
  group('AlbumAccessGuard — locked album regression', () {
    test('cold session: locked album without unlock blocks navigation', () {
      expect(
        AlbumAccessGuard.canNavigate(
          isLocked: true,
          unlockedAlbumIds: {},
          albumId: 'telegram',
        ),
        isFalse,
      );
    });

    test('locked album with session unlock allows navigation', () {
      expect(
        AlbumAccessGuard.canNavigate(
          isLocked: true,
          unlockedAlbumIds: {'telegram'},
          albumId: 'telegram',
        ),
        isTrue,
      );
    });

    test('unlocked album always allows navigation', () {
      expect(
        AlbumAccessGuard.canNavigate(
          isLocked: false,
          unlockedAlbumIds: {},
          albumId: 'camera',
        ),
        isTrue,
      );
    });

    test('double-tap race: still blocked until album id in unlocked set', () {
      const albumId = 'vn';
      final unlocked = <String>{};
      expect(
        AlbumAccessGuard.canNavigate(
          isLocked: true,
          unlockedAlbumIds: unlocked,
          albumId: albumId,
        ),
        isFalse,
      );
      expect(
        AlbumAccessGuard.canNavigate(
          isLocked: true,
          unlockedAlbumIds: unlocked,
          albumId: albumId,
        ),
        isFalse,
      );
      unlocked.add(albumId);
      expect(
        AlbumAccessGuard.canNavigate(
          isLocked: true,
          unlockedAlbumIds: unlocked,
          albumId: albumId,
        ),
        isTrue,
      );
    });
  });
}
