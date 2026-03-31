/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; notebook cover picker dialog
library;

import 'package:flutter/material.dart';
import 'package:saber/components/home/notebook_cover_widget.dart';
import 'package:saber/data/notebook_cover.dart';
import 'package:saber/i18n/strings.g.dart';

/// A dialog that lets the user pick a cover colour and template for a notebook.
class CoverPickerDialog extends StatefulWidget {
  const CoverPickerDialog({
    super.key,
    required this.initialCover,
    required this.noteName,
  });

  final NotebookCover initialCover;
  final String noteName;

  /// Shows the dialog and returns the chosen [NotebookCover], or `null` if the
  /// user cancelled.
  static Future<NotebookCover?> show(
    BuildContext context, {
    required NotebookCover initialCover,
    required String noteName,
  }) {
    return showDialog<NotebookCover>(
      context: context,
      builder: (_) => CoverPickerDialog(
        initialCover: initialCover,
        noteName: noteName,
      ),
    );
  }

  @override
  State<CoverPickerDialog> createState() => _CoverPickerDialogState();
}

class _CoverPickerDialogState extends State<CoverPickerDialog> {
  late NotebookCover _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialCover;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final t = Translations.of(context);

    return AlertDialog(
      title: Text(t.home.cover.chooseCover),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Preview ──────────────────────────────────────
              Center(
                child: SizedBox(
                  width: 140,
                  height: 190,
                  child: NotebookCoverWidget(
                    cover: _current,
                    title: widget.noteName,
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Colour picker ─────────────────────────────────
              Text(
                t.home.cover.colour,
                style: TextTheme.of(context).labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final color in notebookCoverPalette)
                    _ColorSwatch(
                      color: color,
                      selected: _current.colorValue == color.toARGB32(),
                      onTap: () => setState(() {
                        _current = _current.copyWith(
                          colorValue: color.toARGB32(),
                        );
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Template picker ───────────────────────────────
              Text(
                t.home.cover.template,
                style: TextTheme.of(context).labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final template in NotebookCoverTemplate.values)
                    _TemplateTile(
                      template: template,
                      color: _current.color,
                      selected: _current.template == template,
                      onTap: () => setState(
                        () => _current = _current.copyWith(template: template),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(t.common.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_current),
          child: Text(t.common.done),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Helper widgets
// ────────────────────────────────────────────────────────────────────────────

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: ColorScheme.of(context).onSurface,
                  width: 3,
                )
              : Border.all(color: Colors.transparent, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: selected
            ? Icon(
                Icons.check,
                size: 18,
                color: ThemeData.estimateBrightnessForColor(color) ==
                        Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )
            : null,
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({
    required this.template,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final NotebookCoverTemplate template;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 64,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: selected
                    ? ColorScheme.of(context).primary
                    : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: NotebookCoverWidget(
                cover: NotebookCover(
                  colorValue: color.toARGB32(),
                  template: template,
                ),
                spineWidth: 8,
                borderRadius: 4,
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _templateName(t, template),
            style: TextTheme.of(context).labelSmall,
          ),
        ],
      ),
    );
  }

  String _templateName(Translations t, NotebookCoverTemplate tpl) =>
      switch (tpl) {
        NotebookCoverTemplate.plain => t.home.cover.templates.plain,
        NotebookCoverTemplate.linen => t.home.cover.templates.linen,
        NotebookCoverTemplate.dots => t.home.cover.templates.dots,
        NotebookCoverTemplate.stripes => t.home.cover.templates.stripes,
        NotebookCoverTemplate.leather => t.home.cover.templates.leather,
        NotebookCoverTemplate.grid => t.home.cover.templates.grid,
        NotebookCoverTemplate.floral => t.home.cover.templates.floral,
      };
}
