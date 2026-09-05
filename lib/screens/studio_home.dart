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
  final int _linesPerSlide = 4;

  @override
  void initState() {
    super.initState();
    _centerTabController = TabController(length: 3, vsync: this);

    // Default select first hymn (Peace, Be Still! or first in list)
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
    _searchController.dispose();
    _searchFocusNode.dispose();
    _centerTabController.dispose();
    _midiController.dispose();
    super.dispose();
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
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.cast_connected, color: Color(0xFF38BDF8)),
            SizedBox(width: 10),
            Text(
              'Display Casting & Pairing',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Open this URL on any Smart TV browser, projector computer, or tablet on your local Wi-Fi:',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                  ),
                ),
                child: SelectableText(
                  widget.castServer.displayUrl,
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
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
                    '${widget.castServer.clientCount} screen(s) actively connected',
                    style: const TextStyle(
                      color: Color(0xFF34D399),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close', style: TextStyle(color: Colors.white70)),
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
      backgroundColor: const Color(0xFF090D16),
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowRight): _nextSlide,
          const SingleActivator(LogicalKeyboardKey.space): _nextSlide,
          const SingleActivator(LogicalKeyboardKey.arrowLeft): _prevSlide,
          const SingleActivator(LogicalKeyboardKey.keyB): _toggleBlackout,
          const SingleActivator(LogicalKeyboardKey.keyC): _toggleCleared,
          const SingleActivator(LogicalKeyboardKey.keyK, control: true): () {
            _searchFocusNode.requestFocus();
          },
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              // Top Navigation & Casting Bar
              _buildTopBar(),

              // Main Three-Panel Studio Layout
              Expanded(
                child: Row(
                  children: [
                    // Left Column: Library
                    SizedBox(
                      width: 320,
                      child: _buildLibraryColumn(filteredSongs),
                    ),

                    const VerticalDivider(color: Colors.white12, width: 1),

                    // Center Column: Slide Workspace, Score Sheet, Info
                    Expanded(flex: 5, child: _buildCenterWorkspace()),

                    const VerticalDivider(color: Colors.white12, width: 1),

                    // Right Column: Live Audience Monitor & Controller
                    SizedBox(width: 360, child: _buildRightControlPanel()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF101726),
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          // Logo & Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Color(0xFF38BDF8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Hymnal Studio',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(width: 24),

          // Search & Jump Field
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText:
                      'Jump to number (e.g. 433, cis 511) or search title/lyrics...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white54,
                    size: 18,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white54,
                            size: 16,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (val) {
                  final matches = widget.repository.search(
                    query: val,
                    hymnalFilter: _selectedHymnalFilter,
                  );
                  if (matches.isNotEmpty) {
                    _selectHymn(matches.first);
                  }
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Actions Toolbar (scrollable horizontally if window is narrow)
          Expanded(
            flex: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Blackout Toggle
                  ElevatedButton.icon(
                    icon: Icon(
                      _isBlackout ? Icons.visibility : Icons.visibility_off,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(_isBlackout ? 'BLACKOUT' : 'Blackout (B)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isBlackout
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _toggleBlackout,
                  ),

                  const SizedBox(width: 8),

                  // Clear Screen Toggle
                  OutlinedButton.icon(
                    icon: Icon(
                      _isCleared ? Icons.format_color_reset : Icons.text_fields,
                      size: 16,
                      color: _isCleared
                          ? const Color(0xFFF59E0B)
                          : Colors.white70,
                    ),
                    label: Text(
                      _isCleared ? 'CLEARED' : 'Clear (C)',
                      style: TextStyle(
                        color: _isCleared
                            ? const Color(0xFFF59E0B)
                            : Colors.white70,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _isCleared
                            ? const Color(0xFFF59E0B)
                            : Colors.white24,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _toggleCleared,
                  ),

                  const SizedBox(width: 12),

                  // Theme Menu
                  PopupMenuButton<String>(
                    tooltip: 'Select Audience Theme',
                    initialValue: _activeTheme,
                    color: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onSelected: _setTheme,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'midnight',
                        child: Text(
                          'Midnight Navy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'warmGold',
                        child: Text(
                          'Warm Amber / Gold',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'sapphire',
                        child: Text(
                          'Sapphire Blue',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'pureBlack',
                        child: Text(
                          'OLED Pure Black',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.palette_outlined,
                            size: 16,
                            color: Colors.white70,
                          ),
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

                  const SizedBox(width: 10),

                  // Casting Status Pill
                  InkWell(
                    onTap: _showPairingDialog,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.castServer.isRunning
                            ? const Color(0xFF10B981).withValues(alpha: 0.15)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.castServer.isRunning
                              ? const Color(0xFF10B981)
                              : Colors.white24,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cast,
                            size: 16,
                            color: widget.castServer.isRunning
                                ? const Color(0xFF34D399)
                                : Colors.white54,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.castServer.isRunning
                                ? '${widget.castServer.clientCount} Display(s)'
                                : 'Cast Off',
                            style: TextStyle(
                              color: widget.castServer.isRunning
                                  ? const Color(0xFF34D399)
                                  : Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryColumn(List<Hymn> songs) {
    return Column(
      children: [
        // Hymnal Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _buildFilterChip('ALL', 'All Books'),
              _buildFilterChip('CIS', 'Christ in Song'),
              _buildFilterChip('SDAH', 'SDAH (1985)'),
              _buildFilterChip('EXT', 'Extended'),
              _buildFilterChip('KM', 'Shona (KM)'),
              _buildFilterChip('UE', 'Ndebele (UE)'),
              _buildFilterChip('NZK', 'Swahili (NZK)'),
            ],
          ),
        ),

        const Divider(color: Colors.white12, height: 1),

        // Songs list
        Expanded(
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, idx) {
              final hymn = songs[idx];
              final isSelected = _selectedHymn?.id == hymn.id;

              return ListTile(
                selected: isSelected,
                selectedTileColor: const Color(
                  0xFF0284C7,
                ).withValues(alpha: 0.15),
                leading: Container(
                  width: 54,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0284C7)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${hymn.hymnalCode}\n#${hymn.number}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  hymn.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.9),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  hymn.author ?? hymn.scripture ?? hymn.hymnalName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
                trailing: hymn.rights.type == RightsType.licensed
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CCLI',
                          style: TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                onTap: () => _selectHymn(hymn),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String code, String label) {
    final isSelected = _selectedHymnalFilter == code;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        selectedColor: const Color(0xFF0284C7),
        backgroundColor: const Color(0xFF1E293B),
        onSelected: (_) {
          setState(() => _selectedHymnalFilter = code);
        },
      ),
    );
  }

  Widget _buildCenterWorkspace() {
    if (_selectedHymn == null) {
      return const Center(
        child: Text(
          'Select a hymn to present',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return Column(
      children: [
        // Hymn Summary Banner
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF131B2E),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF0284C7,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_selectedHymn!.hymnalCode} #${_selectedHymn!.number}',
                            style: const TextStyle(
                              color: Color(0xFF38BDF8),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_selectedHymn!.scripture != null)
                          Text(
                            _selectedHymn!.scripture!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedHymn!.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Format controls: Auto-Chorus
              Row(
                children: [
                  const Text(
                    'Auto Refrain',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Switch(
                    value: _autoInsertChorus,
                    activeThumbColor: const Color(0xFF38BDF8),
                    onChanged: (val) {
                      setState(() {
                        _autoInsertChorus = val;
                        _currentSlides = SlideFormatter.formatHymn(
                          _selectedHymn!,
                          linesPerSlide: _linesPerSlide,
                          autoInsertChorus: _autoInsertChorus,
                          transposeSemitones:
                              _midiController.transposeSemitones,
                        );
                      });
                      _broadcastCurrentSlide();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Tabs: Slides Deck | Sheet Music | History & Info
        Container(
          color: const Color(0xFF101726),
          child: TabBar(
            controller: _centerTabController,
            indicatorColor: const Color(0xFF38BDF8),
            labelColor: const Color(0xFF38BDF8),
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(
                icon: Icon(Icons.slideshow, size: 18),
                text: 'Presentation Slides',
              ),
              Tab(
                icon: Icon(Icons.menu_book, size: 18),
                text: 'Musician Score Sheet',
              ),
              Tab(
                icon: Icon(Icons.info_outline, size: 18),
                text: 'Hymn Story & Information',
              ),
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _currentSlides.length,
      itemBuilder: (context, idx) {
        final slide = _currentSlides[idx];
        final isLive = idx == _activeSlideIndex;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isLive ? const Color(0xFF1E3A8A) : const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isLive
                  ? const Color(0xFF38BDF8)
                  : Colors.white.withValues(alpha: 0.08),
              width: isLive ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _goToSlide(idx),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isLive
                                  ? const Color(0xFF38BDF8)
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              slide.sectionLabel.toUpperCase(),
                              style: TextStyle(
                                color: isLive
                                    ? const Color(0xFF0F172A)
                                    : Colors.white70,
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
                        ],
                      ),
                      if (isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.fiber_manual_record,
                                size: 8,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'ON PROJECTOR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...slide.lines.map(
                    (line) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        line,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: isLive
                              ? FontWeight.w600
                              : FontWeight.normal,
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
    );
  }

  Widget _buildHymnInfoView() {
    final hymn = _selectedHymn!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Title', hymn.title),
          if (hymn.originalTitle != null)
            _buildInfoRow('Original Title', hymn.originalTitle!),
          _buildInfoRow('Hymnal', '${hymn.hymnalName} (#${hymn.number})'),
          if (hymn.scripture != null)
            _buildInfoRow('Scripture', hymn.scripture!),
          if (hymn.author != null) _buildInfoRow('Author', hymn.author!),
          if (hymn.composer != null) _buildInfoRow('Composer', hymn.composer!),
          if (hymn.music.tuneName != null)
            _buildInfoRow('Tune Name', hymn.music.tuneName!),
          if (hymn.music.meter != null)
            _buildInfoRow('Meter', hymn.music.meter!),
          _buildInfoRow('Default Key', hymn.music.defaultKey),
          _buildInfoRow('Default Tempo', '${hymn.music.defaultBpm} BPM'),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),
          const Text(
            'Historical Context & Background',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hymn.historyNote ??
                'This hymn is part of the beloved Seventh-day Adventist hymnody, preserved across generations for congregational worship.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Rights & Licensing Metadata',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${hymn.rights.type.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hymn.rights.rightsHolder != null)
                  Text(
                    'Rights Holder: ${hymn.rights.rightsHolder}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                if (hymn.rights.licenseNotice != null)
                  Text(
                    'Notice: ${hymn.rights.licenseNotice}',
                    style: const TextStyle(color: Colors.white70),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
      color: const Color(0xFF0C1322),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF101726),
              child: const Row(
                children: [
                  Icon(Icons.live_tv, size: 16, color: Color(0xFF38BDF8)),
                  SizedBox(width: 8),
                  Text(
                    'Audience Display Monitor',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Scaled 16:9 Live Audience Mirror
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 8),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: PresentationOutputScreen(
                  currentSlide: currentSlide,
                  isBlackout: _isBlackout,
                  isCleared: _isCleared,
                  themeName: _activeTheme,
                  fontScale: 0.55, // scaled for preview
                ),
              ),
            ),

            // Slide Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Prev (←)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _prevSlide,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Next (→)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _nextSlide,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: Colors.white12, height: 1),

            // MIDI / Audio Accompaniment Control Deck
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.piano,
                        color: Color(0xFF38BDF8),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'MIDI Accompaniment Engine',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          _midiController.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: const Color(0xFF38BDF8),
                          size: 32,
                        ),
                        onPressed: _midiController.togglePlay,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Pitch Transposer Stepper
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Pitch Transposition:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Key: ${_midiController.transposedKey} (${_midiController.transposeSemitones >= 0 ? "+${_midiController.transposeSemitones}" : _midiController.transposeSemitones} st)',
                              style: const TextStyle(
                                color: Color(0xFF38BDF8),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white70,
                                size: 18,
                              ),
                              onPressed: () {
                                _midiController.setTranspose(
                                  _midiController.transposeSemitones - 1,
                                );
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Reset Key (0)',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                              onPressed: () => _midiController.setTranspose(0),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white70,
                                size: 18,
                              ),
                              onPressed: () {
                                _midiController.setTranspose(
                                  _midiController.transposeSemitones + 1,
                                );
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Tempo (BPM):',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
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
                          max: 160,
                          divisions: 22,
                          activeColor: const Color(0xFF38BDF8),
                          onChanged: (val) =>
                              _midiController.setBpm(val.round()),
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
