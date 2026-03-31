/// 🤖 Generated wholely or partially with Claude Sonnet 4; Claude Sonnet 4.6 ✨
library;

import 'package:flutter/material.dart';
import 'package:saber/devils_book/models/paper_type.dart';
import 'package:sbn/canvas_background_pattern.dart';

/// Bottom sheet that lets the user pick a paper type for the current page.
///
/// Designed to feel like GoodNotes' template picker: grouped families
/// shown in horizontal carousels inside a scrollable sheet.
class PaperSelectorSheet extends StatelessWidget {
  final PaperType? currentPaper;
  final CanvasBackgroundPattern? currentPattern;
  final ValueChanged<PaperType> onSelect;
  final ValueChanged<CanvasBackgroundPattern>? onPatternSelect;

  const PaperSelectorSheet({
    super.key,
    this.currentPaper,
    this.currentPattern,
    required this.onSelect,
    this.onPatternSelect,
  });

  static const _families = <String, List<PaperType>>{
    'Classic': PaperCatalog.classics,
    'Colours': PaperCatalog.colours,
    'Dark': PaperCatalog.darks,
    'Specialty': PaperCatalog.specialty,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.all(20),
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'PAPER TYPE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFFD4AF37),
              letterSpacing: 3.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose the surface and colour for this page',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                if (onPatternSelect != null) ...[
                  _buildPatternSection(context),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),
                ],
                ..._families.entries.map((entry) {
                  return _buildFamily(context, entry.key, entry.value);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _patternLabels = <CanvasBackgroundPattern, (String, IconData)>{
    CanvasBackgroundPattern.none: ('None', Icons.crop_square),
    CanvasBackgroundPattern.lined: ('Lined', Icons.horizontal_rule),
    CanvasBackgroundPattern.grid: ('Grid', Icons.grid_on),
    CanvasBackgroundPattern.dots: ('Dots', Icons.more_horiz),
    CanvasBackgroundPattern.collegeLtr: ('College', Icons.view_headline),
    CanvasBackgroundPattern.collegeRtl: ('College RTL', Icons.view_headline),
    CanvasBackgroundPattern.staffs: ('Music', Icons.music_note),
    CanvasBackgroundPattern.cornell: ('Cornell', Icons.view_quilt),
  };

  Widget _buildPatternSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Text(
            'BACKGROUND PATTERN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _patternLabels.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final entry = _patternLabels.entries.elementAt(index);
              final pattern = entry.key;
              final (label, icon) = entry.value;
              final isSelected = currentPattern == pattern;
              return GestureDetector(
                onTap: () => onPatternSelect?.call(pattern),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.15)
                        : const Color(0xFF1A1A1A),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFD4AF37)
                          : Colors.white.withValues(alpha: 0.1),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isSelected
                            ? const Color(0xFFD4AF37)
                            : Colors.white54,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFFD4AF37)
                              : Colors.white54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFamily(
    BuildContext context,
    String familyName,
    List<PaperType> papers,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Text(
            familyName.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: papers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final paper = papers[index];
              final isSelected = currentPaper?.id == paper.id;
              return _PaperCard(
                paper: paper,
                isSelected: isSelected,
                onTap: () {
                  onSelect(paper);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PaperCard extends StatelessWidget {
  final PaperType paper;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaperCard({
    required this.paper,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        ThemeData.estimateBrightnessForColor(paper.tint) == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : Colors.black87;
    final borderColor = isSelected
        ? const Color(0xFFD4AF37)
        : Colors.white.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Paper preview swatch
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: paper.tint,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(11),
                  ),
                ),
                child: Center(
                  child: Icon(
                    paper.icon ?? Icons.article,
                    size: 24,
                    color: labelColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            // Surface badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 2),
              color: Colors.black.withValues(alpha: 0.15),
              child: Center(
                child: Text(
                  paper.surface.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: labelColor.withValues(alpha: 0.4),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            // Label
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(11),
                ),
              ),
              child: Text(
                paper.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
