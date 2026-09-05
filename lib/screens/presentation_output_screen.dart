import 'package:flutter/material.dart';
import 'package:hymnal_studio/models/hymn.dart';

class PresentationOutputScreen extends StatelessWidget {
  final PresentationSlide? currentSlide;
  final bool isBlackout;
  final bool isCleared;
  final String themeName;
  final double fontScale;
  final bool isLowerThird;

  const PresentationOutputScreen({
    super.key,
    required this.currentSlide,
    this.isBlackout = false,
    this.isCleared = false,
    this.themeName = 'midnight',
    this.fontScale = 1.0,
    this.isLowerThird = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isBlackout) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(),
      );
    }

    final decoration = _getThemeDecoration(themeName);
    final primaryTextColor = _getThemeTextColor(themeName);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: decoration,
        child: isCleared || currentSlide == null
            ? const SizedBox.expand()
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (48 * fontScale).clamp(8.0, 48.0),
                    vertical: (32 * fontScale).clamp(6.0, 32.0),
                  ),
                  child: Column(
                    children: [
                      // Header Badge
                      if (!isLowerThird) ...[
                        AnimatedOpacity(
                          opacity: isCleared ? 0 : 0.85,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            '${currentSlide!.hymnalCode} #${currentSlide!.hymnNumber} • ${currentSlide!.sectionLabel}'
                                .toUpperCase(),
                            style: TextStyle(
                              color: const Color(0xFF38BDF8),
                              fontSize: (14 * fontScale).clamp(9.0, 16.0),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5 * fontScale,
                            ),
                          ),
                        ),
                        SizedBox(height: (20 * fontScale).clamp(4.0, 24.0)),
                      ],

                      // Main Lyrics Area
                      Expanded(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.05),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              key: ValueKey('${currentSlide!.hymnId}_${currentSlide!.slideIndex}'),
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: currentSlide!.lines.map((line) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: (currentSlide!.lines.length <= 2 ? 6.0 : 3.0) *
                                        fontScale,
                                  ),
                                  child: Text(
                                    line,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: _calculateFontSize(currentSlide!.lines.length) *
                                          fontScale,
                                      fontWeight: FontWeight.w600,
                                      height: 1.25,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black87,
                                          blurRadius: 16,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

                      // Footer Title & Progress
                      if (!isLowerThird) ...[
                        AnimatedOpacity(
                          opacity: isCleared ? 0 : 0.4,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            '${currentSlide!.title} (${currentSlide!.slideIndex + 1}/${currentSlide!.totalSlides})',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14 * fontScale,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  double _calculateFontSize(int lineCount) {
    if (lineCount <= 2) return 46.0;
    if (lineCount <= 4) return 36.0;
    return 28.0;
  }

  BoxDecoration _getThemeDecoration(String theme) {
    switch (theme) {
      case 'warmGold':
        return const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF292524), Color(0xFF0C0A09)],
          ),
        );
      case 'sapphire':
        return const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF1E3A8A), Color(0xFF030712)],
          ),
        );
      case 'pureBlack':
        return const BoxDecoration(color: Colors.black);
      case 'midnight':
      default:
        return const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF1E293B), Color(0xFF090D16)],
          ),
        );
    }
  }

  Color _getThemeTextColor(String theme) {
    switch (theme) {
      case 'warmGold':
        return const Color(0xFFFEF08A);
      default:
        return Colors.white;
    }
  }
}
