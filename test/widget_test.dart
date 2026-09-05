import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/screens/presentation_output_screen.dart';

void main() {
  testWidgets('PresentationOutputScreen displays slide lyrics cleanly',
      (WidgetTester tester) async {
    const testSlide = PresentationSlide(
      hymnId: 'cis-433',
      hymnalCode: 'CIS',
      hymnNumber: 433,
      title: 'Peace, Be Still!',
      sectionType: 'verse',
      sectionLabel: 'Verse 1',
      slideIndex: 0,
      totalSlides: 4,
      lines: [
        'Master, the tempest is raging!',
        'The billows are tossing high!',
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: PresentationOutputScreen(
          currentSlide: testSlide,
          themeName: 'midnight',
        ),
      ),
    );

    expect(find.text('Master, the tempest is raging!'), findsOneWidget);
    expect(find.text('The billows are tossing high!'), findsOneWidget);
    expect(find.textContaining('CIS #433'), findsOneWidget);
  });
}
