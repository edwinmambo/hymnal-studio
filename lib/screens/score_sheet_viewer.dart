import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hymnal_studio/audio/midi_player_controller.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/presentation/slide_formatter.dart';

class ScoreSheetViewer extends StatefulWidget {
  final Hymn hymn;
  final MidiPlayerController midiController;

  const ScoreSheetViewer({
    super.key,
    required this.hymn,
    required this.midiController,
  });

  @override
  State<ScoreSheetViewer> createState() => _ScoreSheetViewerState();
}

class _ScoreSheetViewerState extends State<ScoreSheetViewer> {
  bool _invertColors = false;
  final TransformationController _transformController = TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    setState(() {
      _transformController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreAsset = widget.hymn.music.scoreAsset;
    final defaultKey = widget.hymn.music.defaultKey;
    final currentKey = widget.midiController.transposedKey;
    final semitones = widget.midiController.transposeSemitones;

    return Container(
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          // Musician toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF0284C7)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.music_note, size: 16, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 6),
                      Text(
                        'Key: $currentKey ${semitones != 0 ? "(${semitones > 0 ? '+$semitones' : semitones} st)" : ""}',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (widget.hymn.music.meter != null)
                  Text(
                    'Meter: ${widget.hymn.music.meter}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: 'Invert Stage Dark/Light Mode',
                  icon: Icon(
                    _invertColors ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.white70,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _invertColors = !_invertColors),
                ),
                IconButton(
                  tooltip: 'Reset Zoom',
                  icon: const Icon(Icons.refresh, color: Colors.white70, size: 20),
                  onPressed: _resetZoom,
                ),
              ],
            ),
          ),

          // Transposed chord preview strip
          if (widget.hymn.sections.isNotEmpty &&
              widget.hymn.sections.first.chords != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF162032),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Chords (Transposed to $currentKey): ',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...widget.hymn.sections.first.chords!.map((c) {
                      final transposed =
                          SlideFormatter.transposeChordString(c, semitones);
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          transposed,
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],

          // Main Score Canvas
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.5,
              maxScale: 3.5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: scoreAsset != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _invertColors ? Colors.black : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ColorFiltered(
                              colorFilter: _invertColors
                                  ? const ColorFilter.matrix([
                                      -1, 0, 0, 0, 255, //
                                      0, -1, 0, 0, 255, //
                                      0, 0, -1, 0, 255, //
                                      0, 0, 0, 1, 0, //
                                    ])
                                  : const ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.multiply,
                                    ),
                              child: SvgPicture.asset(
                                scoreAsset,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      : _buildFallbackScoreCard(theme, currentKey, defaultKey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackScoreCard(ThemeData theme, String currentKey, String defaultKey) {
    return Container(
      width: 700,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${widget.hymn.hymnalCode} #${widget.hymn.number}',
                style: const TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Key of $currentKey (Default $defaultKey)',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.hymn.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (widget.hymn.music.tuneName != null) ...[
            const SizedBox(height: 4),
            Text(
              'Tune: ${widget.hymn.music.tuneName} • ${widget.hymn.music.meter ?? "Standard Meter"}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
            ),
          ],
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF38BDF8), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Full vector score sheet for this title can be loaded via MusicXML or SVG import. Playback accompaniment is available in the audio panel below.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
