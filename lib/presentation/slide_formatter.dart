import 'package:hymnal_studio/models/hymn.dart';

class SlideFormatter {
  /// Transforms a [Hymn] into clean, beautifully formatted presentation slides.
  ///
  /// - [linesPerSlide]: Max lines per slide (2 or 4). Long 8-line stanzas are split cleanly.
  /// - [autoInsertChorus]: Automatically inserts the refrain slide after each verse.
  /// - [transposeSemitones]: Adjusts chords if present on the slide.
  static List<PresentationSlide> formatHymn(
    Hymn hymn, {
    int linesPerSlide = 4,
    bool autoInsertChorus = true,
    int transposeSemitones = 0,
  }) {
    final slides = <_TempSlide>[];

    // Find the primary chorus if one exists
    HymnSection? primaryChorus;
    try {
      primaryChorus = hymn.sections.firstWhere((s) => s.isChorus);
    } catch (_) {
      primaryChorus = null;
    }

    for (var i = 0; i < hymn.sections.length; i++) {
      final section = hymn.sections[i];

      if (section.lines.isEmpty) continue;

      // Split section lines into chunks of [linesPerSlide]
      final lineChunks = _chunkLines(section.lines, linesPerSlide);
      final chordChunks = section.chords != null
          ? _chunkLines(section.chords!, linesPerSlide)
          : null;

      for (var chunkIdx = 0; chunkIdx < lineChunks.length; chunkIdx++) {
        final chunkLines = lineChunks[chunkIdx];
        final chunkChords = chordChunks != null && chunkIdx < chordChunks.length
            ? _transposeChords(chordChunks[chunkIdx], transposeSemitones)
            : null;

        final label = lineChunks.length > 1
            ? '${section.label} (${chunkIdx + 1}/${lineChunks.length})'
            : section.label;

        slides.add(
          _TempSlide(
            sectionType: section.type,
            sectionLabel: label,
            lines: chunkLines,
            chords: chunkChords,
          ),
        );
      }

      // Auto-insert chorus after a verse if enabled and not already at a chorus
      if (autoInsertChorus &&
          !section.isChorus &&
          primaryChorus != null &&
          (i + 1 == hymn.sections.length || !hymn.sections[i + 1].isChorus)) {
        final chorusChunks = _chunkLines(primaryChorus.lines, linesPerSlide);
        final chorusChordChunks = primaryChorus.chords != null
            ? _chunkLines(primaryChorus.chords!, linesPerSlide)
            : null;

        for (var cIdx = 0; cIdx < chorusChunks.length; cIdx++) {
          final cLines = chorusChunks[cIdx];
          final cChords =
              chorusChordChunks != null && cIdx < chorusChordChunks.length
              ? _transposeChords(chorusChordChunks[cIdx], transposeSemitones)
              : null;

          final cLabel = chorusChunks.length > 1
              ? '${primaryChorus.label} (${cIdx + 1}/${chorusChunks.length})'
              : primaryChorus.label;

          slides.add(
            _TempSlide(
              sectionType: 'chorus',
              sectionLabel: cLabel,
              lines: cLines,
              chords: cChords,
            ),
          );
        }
      }
    }

    // Convert temp slides with complete totalSlides numbering
    final total = slides.length;
    return List.generate(total, (idx) {
      final s = slides[idx];
      return PresentationSlide(
        hymnId: hymn.id,
        hymnalCode: hymn.hymnalCode,
        hymnNumber: hymn.number,
        title: hymn.title,
        sectionType: s.sectionType,
        sectionLabel: s.sectionLabel,
        slideIndex: idx,
        totalSlides: total,
        lines: s.lines,
        chords: s.chords,
      );
    });
  }

  static List<List<String>> _chunkLines(List<String> lines, int maxLines) {
    if (lines.length <= maxLines) {
      return [List.from(lines)];
    }

    final chunks = <List<String>>[];
    for (var i = 0; i < lines.length; i += maxLines) {
      final end = (i + maxLines < lines.length) ? i + maxLines : lines.length;
      chunks.add(lines.sublist(i, end));
    }
    return chunks;
  }

  static List<String> _transposeChords(List<String> lines, int semitones) {
    if (semitones == 0) return lines;
    return lines.map((line) => transposeChordString(line, semitones)).toList();
  }

  /// Transposes chord notations inside brackets like `[C]` or `[G7]` or `[Bb/D]`
  static String transposeChordString(String input, int semitones) {
    if (semitones == 0) return input;

    final chordRegex = RegExp(r'\[([A-G][b#]?)([^\]]*)\]');
    return input.replaceAllMapped(chordRegex, (match) {
      final root = match.group(1)!;
      final suffix = match.group(2) ?? '';
      final transposedRoot = transposeRootNote(root, semitones);
      return '[$transposedRoot$suffix]';
    });
  }

  static final List<String> _scaleSharps = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];
  static final List<String> _scaleFlats = [
    'C',
    'Db',
    'D',
    'Eb',
    'E',
    'F',
    'Gb',
    'G',
    'Ab',
    'A',
    'Bb',
    'B',
  ];

  static String transposeRootNote(String note, int semitones) {
    var index = _scaleSharps.indexOf(note);
    if (index == -1) {
      index = _scaleFlats.indexOf(note);
    }
    if (index == -1) return note;

    var newIndex = (index + semitones) % 12;
    if (newIndex < 0) newIndex += 12;

    // Prefer flats for flat keys
    if (note.contains('b') || semitones < 0) {
      return _scaleFlats[newIndex];
    }
    return _scaleSharps[newIndex];
  }
}

class _TempSlide {
  final String sectionType;
  final String sectionLabel;
  final List<String> lines;
  final List<String>? chords;

  _TempSlide({
    required this.sectionType,
    required this.sectionLabel,
    required this.lines,
    this.chords,
  });
}
