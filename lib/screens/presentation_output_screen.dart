import 'package:flutter/material.dart';
import 'package:hymnal_studio/models/hymn.dart';

class PresentationOutputScreen extends StatelessWidget {
  final PresentationSlide? currentSlide;
  final bool isBlackout;
  final bool isCleared;
  final String themeName;
  final bool isLowerThird;

  const PresentationOutputScreen({
    super.key,
    required this.currentSlide,
    this.isBlackout = false,
    this.isCleared = false,
    this.themeName = 'midnight',
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

    // Render inside a fixed 1920x1080 reference canvas
    // FittedBox in parents scales this seamlessly without line-wrap mismatches
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: 1920,
            height: 1080,
            decoration: decoration,
            child: isCleared || currentSlide == null
                ? const SizedBox.expand()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 60,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Top Section Header Badge
                        if (!isLowerThird) ...[
                          AnimatedOpacity(
                            opacity: isCleared ? 0 : 0.9,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                '${currentSlide!.hymnalCode} #${currentSlide!.hymnNumber} • ${currentSlide!.sectionLabel}'
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],

                        // Main Fluid Widescreen Lyrics Area (Spans 85% of 1920px canvas)
                        Expanded(
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.0, 0.04),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: ConstrainedBox(
                                key: ValueKey(
                                  '${currentSlide!.hymnId}_${currentSlide!.slideIndex}',
                                ),
                                constraints: const BoxConstraints(maxWidth: 1680),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: currentSlide!.lines.map((line) {
                                    final fontSize = _calculateFontSize(
                                      currentSlide!.lines.length,
                                    );
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: currentSlide!.lines.length <= 2
                                            ? 14.0
                                            : 8.0,
                                      ),
                                      child: Text(
                                        line,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                          color: primaryTextColor,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w700,
                                          height: 1.30,
                                          letterSpacing: 0.5,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 24,
                                              offset: Offset(0, 6),
                                            ),
                                            Shadow(
                                              color: Colors.black87,
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
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
                        ),

                        // Bottom Footer (Hymn Title & Slide Count)
                        if (!isLowerThird) ...[
                          AnimatedOpacity(
                            opacity: isCleared ? 0 : 0.5,
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              '${currentSlide!.title} • ${currentSlide!.slideIndex + 1} of ${currentSlide!.totalSlides}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  double _calculateFontSize(int lineCount) {
    if (lineCount <= 2) return 66.0;
    if (lineCount <= 4) return 52.0;
    return 40.0;
  }

  BoxDecoration _getThemeDecoration(String theme) {
    switch (theme) {
      case 'warmGold':
        return const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.1,
            colors: [Color(0xFF292524), Color(0xFF0C0A09)],
          ),
        );
      case 'sapphire':
        return const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.1,
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
            radius: 1.1,
            colors: [Color(0xFF1E293B), Color(0xFF090D16)],
          ),
        );
    }
  }

  Color _getThemeTextColor(String theme) {
    switch (theme) {
      case 'warmGold':
        return const Color(0xFFFEF08A);
      case 'sapphire':
      case 'pureBlack':
      case 'midnight':
      default:
        return Colors.white;
    }
  }
}
