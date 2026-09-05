import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/screens/studio_home.dart';
import 'package:hymnal_studio/services/catalog_repository.dart';
import 'package:hymnal_studio/transport/worship_cast_server.dart';

void main() {
  testWidgets('StudioHomeScreen renders library, tabs, monitor and reacts to global B key', (
    WidgetTester tester,
  ) async {
    final repo = CatalogRepository();
    repo.loadFromData(
      [
        const Hymn(
          id: 'cis-433',
          hymnalCode: 'CIS',
          hymnalName: 'Christ in Song',
          number: 433,
          title: 'Peace, Be Still!',
          rights: RightsRecord(type: RightsType.publicDomain),
          music: MusicResource(defaultKey: 'C'),
          sections: [
            HymnSection(
              type: 'verse',
              label: 'Verse 1',
              lines: [
                'Master, the tempest is raging!',
                'The billows are tossing high!',
              ],
            ),
          ],
        ),
      ],
      [
        {'code': 'CIS', 'name': 'Christ in Song'},
      ],
    );

    final castServer = createWorshipCastServer();

    // Render in wide desktop size
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: StudioHomeScreen(
          repository: repo,
          castServer: castServer,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify UI Elements
    expect(find.text('HYMNAL STUDIO'), findsOneWidget);
    expect(find.text('Peace, Be Still!'), findsWidgets);
    expect(find.text('BLACK (B)'), findsOneWidget);
    expect(find.text('CLEAR (C)'), findsOneWidget);
    expect(find.text('ON AIR'), findsOneWidget);

    // Trigger global key B (Blackout) without clicking anything first
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    await tester.pumpAndSettle();

    // Expect Blackout to be ON
    expect(find.text('BLACKOUT ON (B)'), findsOneWidget);
    expect(find.text('BLACK'), findsOneWidget);

    // Trigger key B again to toggle off
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    await tester.pumpAndSettle();
    expect(find.text('BLACK (B)'), findsOneWidget);
    expect(find.text('ON AIR'), findsOneWidget);

    // Trigger key C (Clear)
    await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
    await tester.pumpAndSettle();
    expect(find.text('CLEARED (C)'), findsOneWidget);

    // Trigger key C again to un-clear
    await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
    await tester.pumpAndSettle();
    expect(find.text('CLEAR (C)'), findsOneWidget);
  });
}
