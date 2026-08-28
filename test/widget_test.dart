import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kuva_gallery_app/main.dart';
import 'package:kuva_gallery_app/providers/app_providers.dart';

void main() {
  testWidgets('App renders without crashing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLockedProvider.overrideWith((ref) => false),
          albumsProvider.overrideWith((ref) async => []),
        ],
        child: const KuvaGalleryApp(),
      ),
    );
    await tester.pump();
    expect(find.text('Kuva Gallery'), findsOneWidget);
  });
}
