import 'package:flutter/material.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/screens/presentation_output_screen.dart';
import 'package:hymnal_studio/screens/studio_home.dart';
import 'package:hymnal_studio/services/catalog_repository.dart';
import 'package:hymnal_studio/transport/worship_cast_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = CatalogRepository();
  final castServer = WorshipCastServer();

  // Start embedded casting server (listens on port 8080 or fallback)
  await castServer.start();

  // Load hymn catalog
  await repository.loadCatalog();

  runApp(HymnalStudioApp(
    repository: repository,
    castServer: castServer,
  ));
}

class HymnalStudioApp extends StatefulWidget {
  final CatalogRepository repository;
  final WorshipCastServer castServer;

  const HymnalStudioApp({
    super.key,
    required this.repository,
    required this.castServer,
  });

  @override
  State<HymnalStudioApp> createState() => _HymnalStudioAppState();
}

class _HymnalStudioAppState extends State<HymnalStudioApp> {
  PresentationSlide? _liveSlide;
  bool _isBlackout = false;
  bool _isCleared = false;
  String _activeTheme = 'midnight';

  @override
  void initState() {
    super.initState();
    // Listen to local stream from cast server for sync
    widget.castServer.localStream.listen((msg) {
      if (!mounted) return;
      setState(() {
        if (msg['type'] == 'SLIDE') {
          _liveSlide = PresentationSlide(
            hymnId: msg['hymnId'] as String? ?? '',
            hymnalCode: msg['hymnalCode'] as String? ?? '',
            hymnNumber: msg['hymnNumber'] as int? ?? 0,
            title: msg['title'] as String? ?? '',
            sectionType: msg['sectionType'] as String? ?? '',
            sectionLabel: msg['sectionLabel'] as String? ?? '',
            slideIndex: msg['slideIndex'] as int? ?? 0,
            totalSlides: msg['totalSlides'] as int? ?? 1,
            lines: (msg['lines'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          );
          _isBlackout = false;
          _isCleared = false;
        } else if (msg['type'] == 'BLACKOUT') {
          _isBlackout = msg['value'] as bool? ?? false;
        } else if (msg['type'] == 'CLEAR') {
          _isCleared = msg['value'] as bool? ?? false;
        } else if (msg['type'] == 'THEME') {
          _activeTheme = msg['theme'] as String? ?? 'midnight';
        }
      });
    });
  }

  @override
  void dispose() {
    widget.castServer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if launched with display query parameter (for web / multi-window)
    final uri = Uri.base;
    final isDisplayMode = uri.queryParameters['display'] == '1';

    return MaterialApp(
      title: 'Hymnal Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0284C7),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: isDisplayMode
          ? PresentationOutputScreen(
              currentSlide: _liveSlide,
              isBlackout: _isBlackout,
              isCleared: _isCleared,
              themeName: _activeTheme,
            )
          : StudioHomeScreen(
              repository: widget.repository,
              castServer: widget.castServer,
            ),
    );
  }
}
