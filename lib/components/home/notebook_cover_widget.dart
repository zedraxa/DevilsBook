/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; notebook cover painters
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:saber/data/notebook_cover.dart';

/// Renders a notebook cover with the given [cover] metadata.
///
/// Used both in the home-screen library grid and (optionally) as an
/// overlaid hint on the cover page inside the editor.
class NotebookCoverWidget extends StatelessWidget {
  const NotebookCoverWidget({
    super.key,
    required this.cover,
    this.title,
    this.spineWidth = 14.0,
    this.borderRadius = 8.0,
    this.elevation = 3.0,
  });

  final NotebookCover cover;

  /// Displayed in the centre of the cover. Typically the note file name.
  final String? title;

  /// Width of the spine strip on the left edge.
  final double spineWidth;

  /// Corner radius of the cover.
  final double borderRadius;

  /// Shadow elevation under the cover.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final baseColor = cover.color;
    final spineColor = _darken(baseColor, 0.18);
    final foregroundColor = _foregroundFor(baseColor);

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Spine ──────────────────────────────────────────
          _CoverSpine(
            color: spineColor,
            width: spineWidth,
            foregroundColor: foregroundColor,
          ),
          // ── Main cover surface ─────────────────────────────
          Expanded(
            child: _CoverSurface(
              cover: cover,
              baseColor: baseColor,
              foregroundColor: foregroundColor,
              title: title,
            ),
          ),
        ],
      ),
    );
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color _foregroundFor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Spine
// ────────────────────────────────────────────────────────────────────────────

class _CoverSpine extends StatelessWidget {
  const _CoverSpine({
    required this.color,
    required this.width,
    required this.foregroundColor,
  });

  final Color color;
  final double width;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: color,
      child: Center(
        child: Container(
          width: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: foregroundColor.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Surface
// ────────────────────────────────────────────────────────────────────────────

class _CoverSurface extends StatelessWidget {
  const _CoverSurface({
    required this.cover,
    required this.baseColor,
    required this.foregroundColor,
    required this.title,
  });

  final NotebookCover cover;
  final Color baseColor;
  final Color foregroundColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base fill
        ColoredBox(color: baseColor),
        // Template pattern
        CustomPaint(
          painter: _templatePainter(cover.template, baseColor, foregroundColor),
        ),
        // Title
        if (title != null && title!.isNotEmpty)
          Positioned(
            left: 8,
            right: 8,
            bottom: 16,
            child: Text(
              title!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                shadows: [
                  Shadow(
                    color: foregroundColor == Colors.white
                        ? Colors.black26
                        : Colors.white38,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  static CustomPainter _templatePainter(
    NotebookCoverTemplate template,
    Color base,
    Color fg,
  ) {
    return switch (template) {
      NotebookCoverTemplate.plain => _PlainPainter(),
      NotebookCoverTemplate.linen => _LinenPainter(base: base, fg: fg),
      NotebookCoverTemplate.dots => _DotsPainter(fg: fg),
      NotebookCoverTemplate.stripes => _StripesPainter(fg: fg),
      NotebookCoverTemplate.leather => _LeatherPainter(base: base),
      NotebookCoverTemplate.grid => _GridPainter(fg: fg),
      NotebookCoverTemplate.floral => _FloralPainter(fg: fg),
    };
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Template painters
// ────────────────────────────────────────────────────────────────────────────

class _PlainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(_PlainPainter old) => false;
}

class _LinenPainter extends CustomPainter {
  _LinenPainter({required this.base, required this.fg});
  final Color base;
  final Color fg;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fg.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    const step = 5.0;
    for (double y = 0; y < size.height + size.width; y += step) {
      canvas.drawLine(Offset(0, y), Offset(y, 0), paint);
    }
    paint.color = fg.withValues(alpha: 0.04);
    for (double y = step / 2; y < size.height + size.width; y += step) {
      canvas.drawLine(Offset(0, y), Offset(y, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_LinenPainter old) => false;
}

class _DotsPainter extends CustomPainter {
  _DotsPainter({required this.fg});
  final Color fg;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = fg.withValues(alpha: 0.18);
    const spacing = 14.0;
    for (double x = spacing; x < size.width - 2; x += spacing) {
      for (double y = spacing; y < size.height - 2; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) => false;
}

class _StripesPainter extends CustomPainter {
  _StripesPainter({required this.fg});
  final Color fg;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fg.withValues(alpha: 0.08)
      ..strokeWidth = 3;
    const step = 10.0;
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_StripesPainter old) => false;
}

class _LeatherPainter extends CustomPainter {
  _LeatherPainter({required this.base});
  final Color base;

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle cross-hatch with random-looking but deterministic offsets
    final paintDark = Paint()
      ..color = Colors.black.withValues(alpha: 0.07)
      ..strokeWidth = 0.8;
    final paintLight = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 0.8;

    const step = 8.0;
    for (double i = 0; i < size.width + size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(i, 0), paintDark);
      canvas.drawLine(
        Offset(size.width, i - size.width),
        Offset(i - size.height, size.height),
        paintLight,
      );
    }

    // Highlight gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.08),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_LeatherPainter old) => false;
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.fg});
  final Color fg;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fg.withValues(alpha: 0.12)
      ..strokeWidth = 0.8;
    const step = 14.0;
    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class _FloralPainter extends CustomPainter {
  _FloralPainter({required this.fg});
  final Color fg;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fg.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    _drawCornerFloral(canvas, size, paint);
  }

  void _drawCornerFloral(Canvas canvas, Size size, Paint paint) {
    // Draw small floral motif in top-right corner
    final cx = size.width - 22.0;
    final cy = 22.0;
    final r = 10.0;

    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final px = cx + r * math.cos(angle);
      final py = cy + r * math.sin(angle);
      canvas.drawCircle(Offset(px, py), 5.5, paint);
    }
    canvas.drawCircle(Offset(cx, cy), 4, paint);

    // And in bottom-left
    final bx = 22.0;
    final by = size.height - 22.0;
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final px = bx + r * math.cos(angle);
      final py = by + r * math.sin(angle);
      canvas.drawCircle(Offset(px, py), 5.5, paint);
    }
    canvas.drawCircle(Offset(bx, by), 4, paint);
  }

  @override
  bool shouldRepaint(_FloralPainter old) => false;
}
