import 'package:flutter_test/flutter_test.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/presentation/slide_formatter.dart';

void main() {
  group('SlideFormatter Tests', () {
    final testHymn = Hymn(
      id: 'test-1',
      hymnalCode: 'TEST',
      hymnalName: 'Test Hymnal',
      number: 1,
      title: 'Peace Test',
      rights: const RightsRecord(type: RightsType.publicDomain),
      music: const MusicResource(defaultKey: 'C', defaultBpm: 100),
      sections: const [
        HymnSection(
          type: 'verse',
          number: 1,
          label: 'Verse 1',
          lines: [
            'Line 1',
            'Line 2',
            'Line 3',
            'Line 4',
            'Line 5',
            'Line 6',
            'Line 7',
            'Line 8',
          ],
          chords: ['[C] Line 1', '[G] Line 2'],
        ),
        HymnSection(
          type: 'chorus',
          label: 'Refrain',
          lines: [
            'Chorus Line 1',
            'Chorus Line 2',
          ],
          chords: ['[F] Chorus Line 1', '[C] Chorus Line 2'],
        ),
        HymnSection(
          type: 'verse',
          number: 2,
          label: 'Verse 2',
          lines: [
            'V2 Line 1',
            'V2 Line 2',
            'V2 Line 3',
            'V2 Line 4',
          ],
        ),
      ],
    );

    test('Splits 8-line stanza into 4-line slides', () {
      final slides = SlideFormatter.formatHymn(
        testHymn,
        linesPerSlide: 4,
        autoInsertChorus: false,
      );

      // Verse 1 (2 slides) + Chorus (1 slide) + Verse 2 (1 slide) = 4 slides
      expect(slides.length, 4);
      expect(slides[0].lines.length, 4);
      expect(slides[0].lines.first, 'Line 1');
      expect(slides[1].lines.length, 4);
      expect(slides[1].lines.first, 'Line 5');
    });

    test('Auto inserts chorus after each verse', () {
      final slides = SlideFormatter.formatHymn(
        testHymn,
        linesPerSlide: 4,
        autoInsertChorus: true,
      );

      // Verse 1 (2 parts) -> Chorus -> Verse 2 -> Chorus
      expect(slides.any((s) => s.sectionType == 'chorus'), isTrue);
      expect(slides.last.sectionType, 'chorus');
    });

    test('Transposes chord strings accurately', () {
      // C -> D (+2 semitones)
      expect(SlideFormatter.transposeChordString('[C] Amazing [G7]', 2), '[D] Amazing [A7]');
      // F -> G (+2 semitones)
      expect(SlideFormatter.transposeChordString('[F] Lord [Bb]', 2), '[G] Lord [C]');
      // Bb -> Ab (-2 semitones)
      expect(SlideFormatter.transposeChordString('[Bb] Holy', -2), '[Ab] Holy');
    });

    test('Transposes root note accurately', () {
      expect(SlideFormatter.transposeRootNote('C', 2), 'D');
      expect(SlideFormatter.transposeRootNote('G', -2), 'F');
      expect(SlideFormatter.transposeRootNote('Bb', 2), 'C');
      expect(SlideFormatter.transposeRootNote('Eb', -1), 'D');
    });
  });
}
