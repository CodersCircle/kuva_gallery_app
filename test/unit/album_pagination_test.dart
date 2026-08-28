import 'package:flutter_test/flutter_test.dart';
import 'package:kuva_gallery_app/domain/models/paged_assets_result.dart';

void main() {
  group('albumPageHasMore', () {
    const pageSize = 80;

    test('1-item album: no more pages after first fetch', () {
      expect(
        albumPageHasMore(
          total: 1,
          start: 0,
          pageSize: pageSize,
          fetchedCount: 1,
        ),
        isFalse,
      );
    });

    test('2-item album: no more pages after first fetch', () {
      expect(
        albumPageHasMore(
          total: 2,
          start: 0,
          pageSize: pageSize,
          fetchedCount: 2,
        ),
        isFalse,
      );
    });

    test('exact page-size multiple: no phantom load-more tile', () {
      expect(
        albumPageHasMore(
          total: pageSize,
          start: 0,
          pageSize: pageSize,
          fetchedCount: pageSize,
        ),
        isFalse,
      );
    });

    test('page-size + 1: first page has more, second does not', () {
      expect(
        albumPageHasMore(
          total: pageSize + 1,
          start: 0,
          pageSize: pageSize,
          fetchedCount: pageSize,
        ),
        isTrue,
      );
      expect(
        albumPageHasMore(
          total: pageSize + 1,
          start: pageSize,
          pageSize: pageSize,
          fetchedCount: 1,
        ),
        isFalse,
      );
    });

    test('empty fetch means no more pages', () {
      expect(
        albumPageHasMore(
          total: 10,
          start: 10,
          pageSize: pageSize,
          fetchedCount: 0,
        ),
        isFalse,
      );
    });
  });
}
