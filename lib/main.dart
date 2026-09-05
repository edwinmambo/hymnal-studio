import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/screens/presentation_output_screen.dart';
import 'package:hymnal_studio/screens/studio_home.dart';
import 'package:hymnal_studio/services/catalog_repository.dart';
import 'package:hymnal_studio/transport/worship_cast_server.dart';
import 'package:web/web.dart' as web;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = CatalogRepository();
  final castServer = createWorshipCastServer();

  // Start embedded casting server (or web broadcast channel on web)
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
      _handleMessage(msg);
    });

    if (kIsWeb) {
      final channel = web.BroadcastChannel('hymnal_studio_cast');
      channel.onmessage = ((web.Event event) {
        final data = (event as web.MessageEvent).data;
        if (data == null) return;
        try {
          final decoded = jsonDecode((data as JSString).toDart);
          if (decoded is Map<String, dynamic>) {
            _handleMessage(decoded);
          }
        } catch (_) {}
      }).toJS;
    }
  }

  void _handleMessage(Map<String, dynamic> msg) {
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
