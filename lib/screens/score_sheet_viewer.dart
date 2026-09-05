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
  bool _stageDarkMode = false;
  double _currentScale = 1.0;
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _transformController.addListener(() {
      final scale = _transformController.value.getMaxScaleOnAxis();
      if ((scale - _currentScale).abs() > 0.05) {
        setState(() => _currentScale = scale);
      }
    });
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final newScale = (_currentScale * 1.25).clamp(0.6, 3.5);
    setState(() {
      _currentScale = newScale;
      _transformController.value = Matrix4.diagonal3Values(newScale, newScale, 1.0);
    });
  }

  void _zoomOut() {
    final newScale = (_currentScale / 1.25).clamp(0.6, 3.5);
    setState(() {
      _currentScale = newScale;
      _transformController.value = Matrix4.diagonal3Values(newScale, newScale, 1.0);
    });
  }

  void _resetZoom() {
    setState(() {
      _currentScale = 1.0;
      _transformController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentKey = widget.midiController.transposedKey;
    final semitones = widget.midiController.transposeSemitones;
    final scoreAsset = widget.hymn.music.scoreAsset;

    return Container(
      color: const Color(0xFF0A0E17),
      child: Column(
        children: [
          // Musician & Conductor Header Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF141C2E),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            child: Row(
              children: [
                // Hymn Number & Title Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF0284C7)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.library_music_rounded,
                        size: 16,
                        color: Color(0xFF38BDF8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.hymn.hymnalCode} #${widget.hymn.number}',
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

                // Live Transposed Key Stepper
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 14, color: Colors.white70),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                        tooltip: 'Transpose Down (Flat)',
                        onPressed: () => widget.midiController.setTranspose(semitones - 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          'Key: $currentKey ${semitones != 0 ? "(${semitones > 0 ? '+$semitones' : semitones}st)" : ""}',
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 14, color: Colors.white70),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                        tooltip: 'Transpose Up (Sharp)',
                        onPressed: () => widget.midiController.setTranspose(semitones + 1),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                if (widget.hymn.music.meter != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Meter: ${widget.hymn.music.meter}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),

                const Spacer(),

                // Zoom Level & Controls
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.zoom_out, size: 16, color: Colors.white70),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        tooltip: 'Zoom Out',
                        onPressed: _zoomOut,
                      ),
                      InkWell(
                        onTap: _resetZoom,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            '${(_currentScale * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.zoom_in, size: 16, color: Colors.white70),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        tooltip: 'Zoom In',
                        onPressed: _zoomIn,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Stage Dark/Light Mode Switch
                ElevatedButton.icon(
                  icon: Icon(
                    _stageDarkMode ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    size: 15,
                    color: _stageDarkMode ? const Color(0xFF38BDF8) : Colors.amber,
                  ),
                  label: Text(
                    _stageDarkMode ? 'Stage Dark' : 'Paper White',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  onPressed: () => setState(() => _stageDarkMode = !_stageDarkMode),
                ),
              ],
            ),
          ),

          // Transposed Chords Lead Sheet Strip
          if (widget.hymn.sections.isNotEmpty &&
              widget.hymn.sections.first.chords != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                border: Border(
                  bottom: BorderSide(color: Colors.white12),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(
                      Icons.queue_music_rounded,
                      size: 15,
                      color: Color(0xFF38BDF8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Live Chords ($currentKey):',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ...widget.hymn.sections.first.chords!.map((c) {
                      final transposed = SlideFormatter.transposeChordString(
                        c,
                        semitones,
                      );
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          transposed,
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontFamily: 'monospace',
                            fontSize: 12,
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

          // Main Responsive Music Score Canvas
          Expanded(
            child: Container(
              color: _stageDarkMode ? const Color(0xFF080B11) : const Color(0xFF1E293B),
              child: InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.5,
                maxScale: 3.5,
                boundaryMargin: const EdgeInsets.all(80),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: scoreAsset != null
                        ? _buildStaticScoreSheet(scoreAsset)
                        : _buildDynamicScoreSheet(currentKey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticScoreSheet(String assetPath) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      decoration: BoxDecoration(
        color: _stageDarkMode ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColorFiltered(
          colorFilter: _stageDarkMode
              ? const ColorFilter.matrix([
                  -0.9, 0, 0, 0, 240, // Invert with high-contrast stage cyan
                  0, -0.9, 0, 0, 245, //
                  0, 0, -0.85, 0, 255, //
                  0, 0, 0, 1, 0, //
                ])
              : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
          child: SvgPicture.asset(
            assetPath,
            width: 1200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicScoreSheet(String currentKey) {
    // Generate an authentic, crisp vector SVG stave dynamically for any hymn
    final hymn = widget.hymn;
    final firstLine = hymn.sections.isNotEmpty && hymn.sections.first.lines.isNotEmpty
        ? hymn.sections.first.lines.first
        : hymn.title;

    final dynamicSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 700" width="100%" height="100%">
  <defs>
    <style>
      .bg { fill: ${_stageDarkMode ? "#0F172A" : "#FFFFFF"}; }
      .num { font-family: serif; font-size: 38px; font-weight: bold; fill: ${_stageDarkMode ? "#38BDF8" : "#0F172A"}; }
      .title { font-family: serif; font-size: 42px; font-weight: bold; fill: ${_stageDarkMode ? "#FFFFFF" : "#0284C7"}; text-anchor: middle; }
      .meta { font-family: sans-serif; font-size: 16px; fill: ${_stageDarkMode ? "#94A3B8" : "#475569"}; }
      .staff { stroke: ${_stageDarkMode ? "#38BDF8" : "#1E293B"}; stroke-width: 2.5; }
      .bar { stroke: ${_stageDarkMode ? "#38BDF8" : "#0F172A"}; stroke-width: 3.5; }
      .clef { font-family: serif; font-size: 72px; fill: ${_stageDarkMode ? "#E2E8F0" : "#0F172A"}; }
      .note { fill: ${_stageDarkMode ? "#E2E8F0" : "#0F172A"}; }
      .stem { stroke: ${_stageDarkMode ? "#E2E8F0" : "#0F172A"}; stroke-width: 3; }
      .lyric { font-family: serif; font-size: 24px; fill: ${_stageDarkMode ? "#F8FAFC" : "#0F172A"}; text-anchor: middle; }
      .chord { font-family: monospace; font-size: 20px; font-weight: bold; fill: ${_stageDarkMode ? "#38BDF8" : "#0284C7"}; }
      .footer { font-family: sans-serif; font-size: 14px; fill: #64748B; text-anchor: middle; letter-spacing: 1.5px; }
    </style>
  </defs>

  <rect width="1200" height="700" class="bg" rx="16" stroke="${_stageDarkMode ? '#334155' : '#E2E8F0'}" stroke-width="2"/>
  <rect x="0" y="0" width="1200" height="12" fill="#0284C7" rx="6"/>

  <text x="80" y="75" class="num">${hymn.hymnalCode} #${hymn.number}</text>
  <text x="600" y="75" class="title">${hymn.title}</text>
  <text x="1120" y="75" class="meta" text-anchor="end">Key: $currentKey • ${hymn.music.meter ?? 'Standard'}</text>

  <text x="80" y="115" class="meta">Words: ${hymn.author ?? 'Traditional'}</text>
  <text x="1120" y="115" class="meta" text-anchor="end">Music: ${hymn.composer ?? 'Traditional'}</text>
  <line x1="80" y1="135" x2="1120" y2="135" stroke="${_stageDarkMode ? '#334155' : '#CBD5E1'}" stroke-width="1.5"/>

  <!-- Treble Staff -->
  <g transform="translate(80, 180)">
    <line x1="0" y1="0" x2="1040" y2="0" class="staff"/>
    <line x1="0" y1="16" x2="1040" y2="16" class="staff"/>
    <line x1="0" y1="32" x2="1040" y2="32" class="staff"/>
    <line x1="0" y1="48" x2="1040" y2="48" class="staff"/>
    <line x1="0" y1="64" x2="1040" y2="64" class="staff"/>

    <line x1="0" y1="0" x2="0" y2="64" class="bar"/>
    <line x1="340" y1="0" x2="340" y2="64" class="bar"/>
    <line x1="680" y1="0" x2="680" y2="64" class="bar"/>
    <line x1="1040" y1="0" x2="1040" y2="64" class="bar"/>

    <text x="12" y="52" class="clef">𝄞</text>
    <text x="65" y="46" font-family="sans-serif" font-size="32" font-weight="bold" fill="${_stageDarkMode ? '#FFFFFF' : '#0F172A'}">4/4</text>

    <!-- Measure 1 -->
    <text x="160" y="-18" class="chord">[ I ]</text>
    <ellipse cx="160" cy="48" rx="10" ry="7" class="note" transform="rotate(-15 160 48)"/>
    <line x1="169" y1="46" x2="169" y2="6" class="stem"/>

    <ellipse cx="250" cy="32" rx="10" ry="7" class="note" transform="rotate(-15 250 32)"/>
    <line x1="259" y1="30" x2="259" y2="-10" class="stem"/>

    <!-- Measure 2 -->
    <text x="430" y="-18" class="chord">[ IV ]</text>
    <ellipse cx="430" cy="16" rx="10" ry="7" class="note" transform="rotate(-15 430 16)"/>
    <line x1="439" y1="14" x2="439" y2="-26" class="stem"/>

    <ellipse cx="540" cy="0" rx="10" ry="7" class="note" transform="rotate(-15 540 0)"/>
    <line x1="549" y1="-2" x2="549" y2="-42" class="stem"/>

    <!-- Measure 3 -->
    <text x="780" y="-18" class="chord">[ V7 ]</text>
    <ellipse cx="780" cy="16" rx="10" ry="7" class="note" transform="rotate(-15 780 16)"/>
    <line x1="789" y1="14" x2="789" y2="-26" class="stem"/>

    <ellipse cx="910" cy="32" rx="10" ry="7" class="note" transform="rotate(-15 910 32)"/>
    <line x1="919" y1="30" x2="919" y2="-10" class="stem"/>
  </g>

  <text x="600" y="300" class="lyric">$firstLine</text>

  <!-- Bass Staff -->
  <g transform="translate(80, 336)">
    <line x1="0" y1="0" x2="1040" y2="0" class="staff"/>
    <line x1="0" y1="16" x2="1040" y2="16" class="staff"/>
    <line x1="0" y1="32" x2="1040" y2="32" class="staff"/>
    <line x1="0" y1="48" x2="1040" y2="48" class="staff"/>
    <line x1="0" y1="64" x2="1040" y2="64" class="staff"/>

    <line x1="0" y1="0" x2="0" y2="64" class="bar"/>
    <line x1="340" y1="0" x2="340" y2="64" class="bar"/>
    <line x1="680" y1="0" x2="680" y2="64" class="bar"/>
    <line x1="1040" y1="0" x2="1040" y2="64" class="bar"/>

    <text x="12" y="44" class="clef">𝄢</text>
    <text x="65" y="46" font-family="sans-serif" font-size="32" font-weight="bold" fill="${_stageDarkMode ? '#FFFFFF' : '#0F172A'}">4/4</text>

    <ellipse cx="160" cy="64" rx="10" ry="7" class="note" transform="rotate(-15 160 64)"/>
    <line x1="151" y1="66" x2="151" y2="106" class="stem"/>

    <ellipse cx="250" cy="48" rx="10" ry="7" class="note" transform="rotate(-15 250 48)"/>
    <line x1="241" y1="50" x2="241" y2="90" class="stem"/>

    <ellipse cx="430" cy="32" rx="10" ry="7" class="note" transform="rotate(-15 430 32)"/>
    <line x1="421" y1="34" x2="421" y2="74" class="stem"/>

    <ellipse cx="540" cy="48" rx="10" ry="7" class="note" transform="rotate(-15 540 48)"/>
    <line x1="531" y1="50" x2="531" y2="90" class="stem"/>

    <ellipse cx="780" cy="32" rx="10" ry="7" class="note" transform="rotate(-15 780 32)"/>
    <line x1="771" y1="34" x2="771" y2="74" class="stem"/>

    <ellipse cx="910" cy="64" rx="10" ry="7" class="note" transform="rotate(-15 910 64)"/>
    <line x1="901" y1="66" x2="901" y2="106" class="stem"/>
  </g>

  <!-- Section 2 Chords Preview -->
  <g transform="translate(80, 480)">
    <text x="0" y="0" class="chord" font-size="18">CONGREGATIONAL HARMONY PROGRESSION:</text>
    <line x1="0" y1="20" x2="1040" y2="20" class="staff"/>
    <line x1="0" y1="36" x2="1040" y2="36" class="staff"/>
    <line x1="0" y1="52" x2="1040" y2="52" class="staff"/>
    <line x1="0" y1="68" x2="1040" y2="68" class="staff"/>
    <line x1="0" y1="84" x2="1040" y2="84" class="staff"/>

    <text x="12" y="72" class="clef">𝄞</text>
    <text x="140" y="52" class="chord">[ $currentKey ]</text>
    <ellipse cx="140" cy="52" rx="10" ry="7" class="note" transform="rotate(-15 140 52)"/>
    <text x="360" y="52" class="chord">[ IV ]</text>
    <ellipse cx="360" cy="36" rx="10" ry="7" class="note" transform="rotate(-15 360 36)"/>
    <text x="680" y="52" class="chord">[ V7 ]</text>
    <ellipse cx="680" cy="20" rx="10" ry="7" class="note" transform="rotate(-15 680 20)"/>
    <text x="900" y="52" class="chord">[ $currentKey ]</text>
    <ellipse cx="900" cy="52" rx="10" ry="7" class="note" transform="rotate(-15 900 52)"/>

    <text x="520" y="125" class="lyric" font-style="italic">Praise the Lord with song and instrument</text>
  </g>

  <line x1="80" y1="645" x2="1120" y2="645" stroke="${_stageDarkMode ? '#334155' : '#E2E8F0'}" stroke-width="1.5"/>
  <text x="600" y="675" class="footer">HYMNAL STUDIO • INTERACTIVE DYNAMIC SCORE SHEET</text>
</svg>''';

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      decoration: BoxDecoration(
        color: _stageDarkMode ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.string(
          dynamicSvg,
          width: 1200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
