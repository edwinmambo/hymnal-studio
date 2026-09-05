import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hymnal_studio/audio/midi_player_controller.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/presentation/slide_formatter.dart';
import 'package:hymnal_studio/screens/presentation_output_screen.dart';
import 'package:hymnal_studio/screens/score_sheet_viewer.dart';
import 'package:hymnal_studio/services/catalog_repository.dart';
import 'package:hymnal_studio/transport/worship_cast_server.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudioHomeScreen extends StatefulWidget {
  final CatalogRepository repository;
  final WorshipCastServer castServer;

  const StudioHomeScreen({
    super.key,
    required this.repository,
    required this.castServer,
  });

  @override
  State<StudioHomeScreen> createState() => _StudioHomeScreenState();
}

class _StudioHomeScreenState extends State<StudioHomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final MidiPlayerController _midiController = MidiPlayerController();

  late TabController _centerTabController;

  String _selectedHymnalFilter = 'ALL';
  Hymn? _selectedHymn;
  List<PresentationSlide> _currentSlides = [];
  int _activeSlideIndex = 0;

  bool _isBlackout = false;
  bool _isCleared = false;
  String _activeTheme = 'midnight';
  bool _autoInsertChorus = true;
  int _linesPerSlide = 4;

  @override
  void initState() {
    super.initState();
    _centerTabController = TabController(length: 3, vsync: this);

    // Global keyboard shortcuts (B for Blackout, C for Clear, Arrows/Space for slide navigation)
    HardwareKeyboard.instance.addHandler(_handleGlobalKeyEvent);

    // Default select first hymn (CIS #433 "Peace, Be Still!" or first available)
    if (widget.repository.songs.isNotEmpty) {
      final initial = widget.repository.songs.firstWhere(
        (h) => h.id == 'cis-433',
        orElse: () => widget.repository.songs.first,
      );
      _selectHymn(initial);
    }

    _midiController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleGlobalKeyEvent);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _centerTabController.dispose();
    _midiController.dispose();
    super.dispose();
  }

  bool _handleGlobalKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // Check if the user is currently typing in an EditableText
    final primaryFocus = FocusManager.instance.primaryFocus;
    final focusedWidget = primaryFocus?.context?.widget;
    final isTypingInField = focusedWidget is EditableText;

    // Focus / Unfocus Search Shortcuts
    if (event.logicalKey == LogicalKeyboardKey.keyK &&
        (HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed)) {
      _searchFocusNode.requestFocus();
      _searchController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _searchController.text.length,
      );
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape && isTypingInField) {
      _searchFocusNode.unfocus();
      return true;
    }

    // Do NOT intercept normal keyboard shortcuts if user is typing in the search box
    if (isTypingInField) {
      return false;
    }

    // Global Blackout shortcut (B)
    if (event.logicalKey == LogicalKeyboardKey.keyB) {
      _toggleBlackout();
      return true;
    }

    // Global Clear shortcut (C)
    if (event.logicalKey == LogicalKeyboardKey.keyC) {
      _toggleCleared();
      return true;
    }

    // Slide Navigation: Space, Right Arrow, Down Arrow, Page Down
    if (event.logicalKey == LogicalKeyboardKey.space ||
        event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.pageDown) {
      _nextSlide();
      return true;
    }

    // Slide Navigation: Left Arrow, Up Arrow, Page Up
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.pageUp) {
      _prevSlide();
      return true;
    }

    // First Slide: Home
    if (event.logicalKey == LogicalKeyboardKey.home) {
      _goToSlide(0);
      return true;
    }

    // Last Slide: End
    if (event.logicalKey == LogicalKeyboardKey.end && _currentSlides.isNotEmpty) {
      _goToSlide(_currentSlides.length - 1);
      return true;
    }

    return false;
  }

  void _selectHymn(Hymn hymn) {
    setState(() {
      _selectedHymn = hymn;
      _activeSlideIndex = 0;
      _currentSlides = SlideFormatter.formatHymn(
        hymn,
        linesPerSlide: _linesPerSlide,
        autoInsertChorus: _autoInsertChorus,
        transposeSemitones: _midiController.transposeSemitones,
      );
      _midiController.setHymn(hymn);
    });
    _broadcastCurrentSlide();
  }

  void _goToSlide(int index) {
    if (index < 0 || index >= _currentSlides.length) return;
    setState(() {
      _activeSlideIndex = index;
    });
    _broadcastCurrentSlide();
  }

  void _nextSlide() {
    if (_activeSlideIndex + 1 < _currentSlides.length) {
      _goToSlide(_activeSlideIndex + 1);
    }
  }

  void _prevSlide() {
    if (_activeSlideIndex > 0) {
      _goToSlide(_activeSlideIndex - 1);
    }
  }

  void _toggleBlackout() {
    setState(() => _isBlackout = !_isBlackout);
    widget.castServer.broadcast({'type': 'BLACKOUT', 'value': _isBlackout});
  }

  void _toggleCleared() {
    setState(() => _isCleared = !_isCleared);
    widget.castServer.broadcast({'type': 'CLEAR', 'value': _isCleared});
  }

  void _setTheme(String theme) {
    setState(() => _activeTheme = theme);
    widget.castServer.broadcast({'type': 'THEME', 'theme': theme});
  }

  void _reformatSlides() {
    if (_selectedHymn == null) return;
    setState(() {
      _currentSlides = SlideFormatter.formatHymn(
        _selectedHymn!,
        linesPerSlide: _linesPerSlide,
        autoInsertChorus: _autoInsertChorus,
        transposeSemitones: _midiController.transposeSemitones,
      );
      if (_activeSlideIndex >= _currentSlides.length) {
        _activeSlideIndex = 0;
      }
    });
    _broadcastCurrentSlide();
  }

  void _broadcastCurrentSlide() {
    if (_currentSlides.isEmpty) return;
    final slide = _currentSlides[_activeSlideIndex];
    widget.castServer.broadcast({
      'type': 'SLIDE',
      'hymnId': slide.hymnId,
      'hymnalCode': slide.hymnalCode,
      'hymnNumber': slide.hymnNumber,
      'title': slide.title,
      'sectionType': slide.sectionType,
      'sectionLabel': slide.sectionLabel,
      'slideIndex': slide.slideIndex,
      'totalSlides': slide.totalSlides,
      'lines': slide.lines,
      'theme': _activeTheme,
    });
  }

  void _showPairingDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141C2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: const Row(
          children: [
            Icon(Icons.cast_connected_rounded, color: Color(0xFF38BDF8)),
            SizedBox(width: 10),
            Text(
              'Audience Casting & Pairing',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Open this URL on your church projector, second monitor, or audience mobile devices to mirror lyrics live in real time.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: SelectableText(
                  widget.castServer.displayUrl,
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: widget.castServer.displayUrl,
                  version: QrVersions.auto,
                  size: 180,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.castServer.clientCount} display screen(s) actively connected',
                    style: const TextStyle(
                      color: Color(0xFF34D399),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Open Projector Window'),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF38BDF8)),
            onPressed: () {
              widget.castServer.openDisplayWindow();
              Navigator.of(ctx).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSongs = widget.repository.search(
      query: _searchController.text,
      hymnalFilter: _selectedHymnalFilter,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF070A11),
      body: Column(
        children: [
          // Top Navigation & Casting Bar
          _buildTopBar(),

          // Main Three-Panel Studio Layout
          Expanded(
            child: Row(
              children: [
                // Left Column: Modern Hymn Library Browser
                SizedBox(
                  width: 320,
                  child: _buildLibraryColumn(filteredSongs),
                ),

                const VerticalDivider(color: Color(0xFF1E293B), width: 1),

                // Center Column: Slides Workspace, Score Sheet, Hymn Intel
                Expanded(flex: 5, child: _buildCenterWorkspace()),

                const VerticalDivider(color: Color(0xFF1E293B), width: 1),

                // Right Column: On-Air Director Console & Live Program Monitor
                SizedBox(width: 370, child: _buildRightControlPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1321),
        border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          // Brand Logo & Status Pill
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HYMNAL STUDIO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'WORSHIP PRO',
                        style: TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(width: 24),

          // Omnibox Search & Direct Number Jump Field
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF141C2E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search title, lyrics, or jump by number (e.g. 433, cis 511, km 12)...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF38BDF8),
                    size: 18,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 16, color: Colors.white54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const Text(
                          'Ctrl+K',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Director Control Deck: Blackout (B), Clear (C), Themes, Cast
          Row(
            children: [
              // Blackout Button (B)
              OutlinedButton.icon(
                icon: Icon(
                  _isBlackout ? Icons.visibility_off : Icons.power_settings_new,
                  size: 15,
                  color: _isBlackout ? Colors.white : const Color(0xFFEF4444),
                ),
                label: Text(
                  _isBlackout ? 'BLACKOUT ON (B)' : 'BLACK (B)',
                  style: TextStyle(
                    color: _isBlackout ? Colors.white : const Color(0xFFEF4444),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _isBlackout
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFEF4444).withValues(alpha: 0.1),
                  side: BorderSide(
                    color: _isBlackout ? const Color(0xFFEF4444) : const Color(0xFFEF4444).withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: _toggleBlackout,
              ),

              const SizedBox(width: 8),

              // Clear Screen Button (C)
              OutlinedButton.icon(
                icon: Icon(
                  Icons.layers_clear_rounded,
                  size: 15,
                  color: _isCleared ? Colors.white : Colors.amber,
                ),
                label: Text(
                  _isCleared ? 'CLEARED (C)' : 'CLEAR (C)',
                  style: TextStyle(
                    color: _isCleared ? Colors.white : Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _isCleared
                      ? Colors.amber.shade700
                      : Colors.amber.withValues(alpha: 0.1),
                  side: BorderSide(
                    color: _isCleared ? Colors.amber : Colors.amber.withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: _toggleCleared,
              ),

              const SizedBox(width: 10),

              // Theme Selector Dropdown
              PopupMenuButton<String>(
                tooltip: 'Select Projector Theme',
                initialValue: _activeTheme,
                color: const Color(0xFF141C2E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF1E293B)),
                ),
                onSelected: _setTheme,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'midnight',
                    child: Row(
                      children: [
                        CircleAvatar(radius: 6, backgroundColor: Color(0xFF1E293B)),
                        SizedBox(width: 8),
                        Text('Midnight Navy', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'warmGold',
                    child: Row(
                      children: [
                        CircleAvatar(radius: 6, backgroundColor: Color(0xFFFEF08A)),
                        SizedBox(width: 8),
                        Text('Warm Amber / Gold', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'sapphire',
                    child: Row(
                      children: [
                        CircleAvatar(radius: 6, backgroundColor: Color(0xFF1E3A8A)),
                        SizedBox(width: 8),
                        Text('Sapphire Blue', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'pureBlack',
                    child: Row(
                      children: [
                        CircleAvatar(radius: 6, backgroundColor: Colors.black),
                        SizedBox(width: 8),
                        Text('OLED Pure Black', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141C2E),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.palette_outlined, size: 15, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text(
                        _activeTheme.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Cast Screen Trigger Button
              InkWell(
                onTap: _showPairingDialog,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF10B981)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cast_rounded, size: 15, color: Color(0xFF34D399)),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.castServer.clientCount} Projector(s)',
                        style: const TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Open Popup Window Button
              IconButton(
                icon: const Icon(Icons.open_in_new_rounded, size: 18, color: Colors.white70),
                tooltip: 'Launch Output Window',
                onPressed: widget.castServer.openDisplayWindow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryColumn(List<Hymn> songs) {
    final hymnalCodes = [
      'ALL',
      'CIS',
      'SDAH',
      'EXT',
      'KM',
      'UE',
      'NZK',
    ];

    return Container(
      color: const Color(0xFF0A0E17),
      child: Column(
        children: [
          // Hymnal Category Tabs with Hymn Counts
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF0D1321),
              border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: hymnalCodes.map((code) {
                  final isSelected = _selectedHymnalFilter == code;
                  final count = code == 'ALL'
                      ? widget.repository.songs.length
                      : widget.repository.songs
                          .where((s) => s.hymnalCode == code)
                          .length;

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text('$code ($count)'),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.white60,
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0284C7),
                      backgroundColor: const Color(0xFF141C2E),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF38BDF8)
                            : Colors.white.withValues(alpha: 0.08),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      onSelected: (val) {
                        if (val) setState(() => _selectedHymnalFilter = code);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Total Results Counter Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            color: const Color(0xFF0B101D),
            child: Row(
              children: [
                Text(
                  '${songs.length} HYMNS FOUND',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Click to Load',
                  style: TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ),
          ),

          // Songs List View
          Expanded(
            child: songs.isEmpty
                ? Center(
                    child: Text(
                      'No hymns match "${_searchController.text}"',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final hymn = songs[index];
                      final isSelected = _selectedHymn?.id == hymn.id;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0284C7).withValues(alpha: 0.15)
                              : const Color(0xFF101726),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF38BDF8)
                                : Colors.white.withValues(alpha: 0.06),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            leading: Container(
                              width: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF0284C7)
                                    : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    hymn.hymnalCode,
                                    style: TextStyle(
                                      fontSize: 9,
                                      height: 1.1,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : const Color(0xFF38BDF8),
                                    ),
                                  ),
                                  Text(
                                    '#${hymn.number}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      height: 1.1,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              hymn.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              '${hymn.music.defaultKey} • ${hymn.music.tuneName ?? hymn.composer ?? hymn.author ?? ""}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.chevron_right, color: Color(0xFF38BDF8), size: 18)
                                : null,
                            onTap: () => _selectHymn(hymn),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterWorkspace() {
    if (_selectedHymn == null) {
      return const Center(
        child: Text(
          'Select a hymn from the library to begin',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    return Column(
      children: [
        // Tab Navigation Bar (Slides, Score, History)
        Container(
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFF0D1321),
            border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
          ),
          child: TabBar(
            controller: _centerTabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: const Color(0xFF38BDF8),
            indicatorWeight: 3,
            labelColor: const Color(0xFF38BDF8),
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(icon: Icon(Icons.slideshow_rounded, size: 16), text: 'Slides & Live Deck'),
              Tab(icon: Icon(Icons.library_music_rounded, size: 16), text: 'Score Sheet (Musician)'),
              Tab(icon: Icon(Icons.info_outline_rounded, size: 16), text: 'Hymn History & Theology'),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _centerTabController,
            children: [
              _buildSlidesDeckView(),
              ScoreSheetViewer(
                hymn: _selectedHymn!,
                midiController: _midiController,
              ),
              _buildHymnInfoView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlidesDeckView() {
    return Column(
      children: [
        // Slide Layout Toolbar (Couplets vs 4 Lines, Chorus Insertion)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF101726),
            border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text(
                  'Chunking:',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('2 Lines (Couplet)'),
                  labelStyle: const TextStyle(fontSize: 11),
                  selected: _linesPerSlide == 2,
                  selectedColor: const Color(0xFF0284C7),
                  backgroundColor: const Color(0xFF1E293B),
                  onSelected: (val) {
                    if (val) {
                      setState(() => _linesPerSlide = 2);
                      _reformatSlides();
                    }
                  },
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('4 Lines (Full Stanza)'),
                  labelStyle: const TextStyle(fontSize: 11),
                  selected: _linesPerSlide == 4,
                  selectedColor: const Color(0xFF0284C7),
                  backgroundColor: const Color(0xFF1E293B),
                  onSelected: (val) {
                    if (val) {
                      setState(() => _linesPerSlide = 4);
                      _reformatSlides();
                    }
                  },
                ),
                const SizedBox(width: 16),
                FilterChip(
                  label: const Text('Auto-Insert Refrain'),
                  labelStyle: const TextStyle(fontSize: 11),
                  selected: _autoInsertChorus,
                  selectedColor: const Color(0xFF0284C7).withValues(alpha: 0.3),
                  checkmarkColor: const Color(0xFF38BDF8),
                  backgroundColor: const Color(0xFF1E293B),
                  onSelected: (val) {
                    setState(() => _autoInsertChorus = val);
                    _reformatSlides();
                  },
                ),
                const SizedBox(width: 16),
                Text(
                  '${_currentSlides.length} Presentation Slides',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        // Slide Cards Grid
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _currentSlides.length,
            itemBuilder: (context, idx) {
              final slide = _currentSlides[idx];
              final isLive = idx == _activeSlideIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isLive ? const Color(0xFF14243D) : const Color(0xFF101726),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isLive ? const Color(0xFF38BDF8) : Colors.white.withValues(alpha: 0.08),
                    width: isLive ? 2 : 1,
                  ),
                  boxShadow: isLive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: InkWell(
                  onTap: () => _goToSlide(idx),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isLive
                                    ? const Color(0xFF38BDF8)
                                    : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                slide.sectionLabel.toUpperCase(),
                                style: TextStyle(
                                  color: isLive ? const Color(0xFF0F172A) : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Slide ${idx + 1} of ${slide.totalSlides}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            if (isLive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.fiber_manual_record, size: 8, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      'LIVE ON PROJECTOR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...slide.lines.map(
                          (line) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              line,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: isLive ? FontWeight.w700 : FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHymnInfoView() {
    final hymn = _selectedHymn!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Hymn Title', hymn.title),
          if (hymn.originalTitle != null)
            _buildInfoRow('Original English Title', hymn.originalTitle!),
          _buildInfoRow('Collection', '${hymn.hymnalName} (#${hymn.number})'),
          if (hymn.scripture != null) _buildInfoRow('Scripture Reference', hymn.scripture!),
          if (hymn.author != null) _buildInfoRow('Lyrics Author', hymn.author!),
          if (hymn.composer != null) _buildInfoRow('Tune Composer', hymn.composer!),
          if (hymn.music.tuneName != null) _buildInfoRow('Tune Name', hymn.music.tuneName!),
          if (hymn.music.meter != null) _buildInfoRow('Meter', hymn.music.meter!),
          _buildInfoRow('Default Key', hymn.music.defaultKey),
          _buildInfoRow('Suggested Tempo', '${hymn.music.defaultBpm} BPM'),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFF1E293B)),
          const SizedBox(height: 16),
          const Text(
            'Historical Context & Theological Background',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hymn.historyNote ??
                'This hymn is part of the cherished Adventist hymnody, preserved across generations for congregational worship.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Rights & Copyright Verification',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF141C2E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${hymn.rights.type.name.toUpperCase()}',
                  style: const TextStyle(
                    color: Color(0xFF34D399),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (hymn.rights.rightsHolder != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Holder: ${hymn.rights.rightsHolder}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
                if (hymn.rights.licenseNotice != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Notice: ${hymn.rights.licenseNotice}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightControlPanel() {
    final currentSlide =
        _currentSlides.isNotEmpty && _activeSlideIndex < _currentSlides.length
            ? _currentSlides[_activeSlideIndex]
            : null;

    return Container(
      color: const Color(0xFF0D1321),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Panel Header
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF101726),
              child: Row(
                children: [
                  const Icon(Icons.live_tv_rounded, size: 16, color: Color(0xFF38BDF8)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Live Audience Monitor',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _isBlackout
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _isBlackout ? 'BLACK' : 'ON AIR',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Exact 1:1 Pixel-Perfect Projector Mirror
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isBlackout
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF0284C7).withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 10),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: PresentationOutputScreen(
                  currentSlide: currentSlide,
                  isBlackout: _isBlackout,
                  isCleared: _isCleared,
                  themeName: _activeTheme,
                ),
              ),
            ),

            // Slide Navigation Triggers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back_rounded, size: 16),
                      label: const Text('Prev (←)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _prevSlide,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('Next (→)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _nextSlide,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: Color(0xFF1E293B), height: 1),

            // MIDI & Audio Accompaniment Deck
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.piano_rounded, color: Color(0xFF38BDF8), size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Organ Accompaniment',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      // Large Play/Pause Button
                      IconButton(
                        icon: Icon(
                          _midiController.isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: const Color(0xFF38BDF8),
                          size: 36,
                        ),
                        onPressed: _midiController.togglePlay,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Pitch Transposer Stepper
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141C2E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Transposition:',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                'Key: ${_midiController.transposedKey} (${_midiController.transposeSemitones >= 0 ? "+${_midiController.transposeSemitones}" : _midiController.transposeSemitones} st)',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white70, size: 18),
                              onPressed: () {
                                _midiController.setTranspose(_midiController.transposeSemitones - 1);
                              },
                            ),
                            TextButton(
                              child: const Text('Reset (0)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                              onPressed: () => _midiController.setTranspose(0),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white70, size: 18),
                              onPressed: () {
                                _midiController.setTranspose(_midiController.transposeSemitones + 1);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // BPM Tempo Slider
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141C2E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Tempo (BPM):', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            const Spacer(),
                            Text(
                              '${_midiController.bpm} BPM',
                              style: const TextStyle(
                                color: Color(0xFF38BDF8),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _midiController.bpm.toDouble(),
                          min: 50,
                          max: 150,
                          divisions: 100,
                          activeColor: const Color(0xFF38BDF8),
                          inactiveColor: const Color(0xFF1E293B),
                          onChanged: (v) => _midiController.setBpm(v.round()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
