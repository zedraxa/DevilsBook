/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; Ynotes Toolbar ✨
library;

import 'package:flutter/material.dart';
import 'package:saber/ynotes/design_system/design_system.dart';

/// Possible tool modes in the Ynotes toolbar.
enum YnotesTool {
  pen,
  highlighter,
  eraser,
  lasso,
  text,
  hand,
}

/// GoodNotes-style floating toolbar strip.
///
/// This is the scaffolded skeleton for the Ynotes toolbar. Tool switching,
/// colour palette, and favourites will be implemented in subsequent phases
/// (see `docs/uiux-roadmap.md` Phase 2).
///
/// The toolbar renders as a compact horizontal strip and can be positioned
/// anywhere on screen via the [alignment] parameter (default: bottom-center).
///
/// Usage:
/// ```dart
/// YnotesToolbar(
///   currentTool: YnotesTool.pen,
///   onToolSelected: (tool) => setState(() => _tool = tool),
///   currentColor: Colors.black,
///   onColorSelected: (color) => setState(() => _color = color),
/// )
/// ```
class YnotesToolbar extends StatelessWidget {
  const YnotesToolbar({
    super.key,
    required this.currentTool,
    required this.onToolSelected,
    required this.currentColor,
    required this.onColorSelected,
    this.onUndo,
    this.canUndo = false,
    this.onRedo,
    this.canRedo = false,
  });

  final YnotesTool currentTool;
  final ValueChanged<YnotesTool> onToolSelected;

  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  final VoidCallback? onUndo;
  final bool canUndo;
  final VoidCallback? onRedo;
  final bool canRedo;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return _ToolbarContainer(
      brightness: brightness,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UndoRedoGroup(
            onUndo: onUndo,
            canUndo: canUndo,
            onRedo: onRedo,
            canRedo: canRedo,
          ),
          _Divider(brightness: brightness),
          _ToolSwitcher(
            currentTool: currentTool,
            onToolSelected: onToolSelected,
          ),
          _Divider(brightness: brightness),
          _ColorDot(
            color: currentColor,
            onTap: () => _showColorPicker(context),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    // TODO(phase-2C): replace stub with YnotesColorPalettePopover
    showModalBottomSheet<Color>(
      context: context,
      builder: (_) => _ColorPickerSheet(
        currentColor: currentColor,
        onColorSelected: onColorSelected,
      ),
    );
  }
}

// ── Container ────────────────────────────────────────────────────────────────

class _ToolbarContainer extends StatelessWidget {
  const _ToolbarContainer({required this.brightness, required this.child});

  final Brightness brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: YnotesSpacing.toolbarHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: YnotesSpacing.toolbarPadding,
      ),
      decoration: BoxDecoration(
        color: YnotesColors.surfaceTertiary(brightness),
        borderRadius: BorderRadius.circular(YnotesRadius.toolbar),
        boxShadow: YnotesShadows.toolbar(brightness),
      ),
      child: child,
    );
  }
}

// ── Divider ───────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: YnotesSpacing.xs),
      color: YnotesColors.onSurfaceMuted(brightness).withValues(alpha: 0.2),
    );
  }
}

// ── Undo / Redo ───────────────────────────────────────────────────────────────

class _UndoRedoGroup extends StatelessWidget {
  const _UndoRedoGroup({
    this.onUndo,
    required this.canUndo,
    this.onRedo,
    required this.canRedo,
  });

  final VoidCallback? onUndo;
  final bool canUndo;
  final VoidCallback? onRedo;
  final bool canRedo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ToolButton(
          icon: Icons.undo_rounded,
          tooltip: 'Undo',
          onTap: canUndo ? onUndo : null,
          isEnabled: canUndo,
        ),
        _ToolButton(
          icon: Icons.redo_rounded,
          tooltip: 'Redo',
          onTap: canRedo ? onRedo : null,
          isEnabled: canRedo,
        ),
      ],
    );
  }
}

// ── Tool Switcher ─────────────────────────────────────────────────────────────

class _ToolSwitcher extends StatelessWidget {
  const _ToolSwitcher({
    required this.currentTool,
    required this.onToolSelected,
  });

  final YnotesTool currentTool;
  final ValueChanged<YnotesTool> onToolSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: YnotesTool.values.map((tool) {
        return _ToolButton(
          icon: _iconFor(tool),
          tooltip: _labelFor(tool),
          onTap: () => onToolSelected(tool),
          isActive: tool == currentTool,
        );
      }).toList(),
    );
  }

  static IconData _iconFor(YnotesTool tool) => switch (tool) {
    YnotesTool.pen => Icons.edit_rounded,
    YnotesTool.highlighter => Icons.highlight_rounded,
    YnotesTool.eraser => Icons.auto_fix_high_rounded,
    YnotesTool.lasso => Icons.gesture_rounded,
    YnotesTool.text => Icons.text_fields_rounded,
    YnotesTool.hand => Icons.pan_tool_rounded,
  };

  static String _labelFor(YnotesTool tool) => switch (tool) {
    YnotesTool.pen => 'Pen',
    YnotesTool.highlighter => 'Highlighter',
    YnotesTool.eraser => 'Eraser',
    YnotesTool.lasso => 'Lasso',
    YnotesTool.text => 'Text',
    YnotesTool.hand => 'Hand',
  };
}

// ── Tool Button ───────────────────────────────────────────────────────────────

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.isActive = false,
    this.isEnabled = true,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool isActive;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = isActive
        ? YnotesColors.brandIndigo
        : isEnabled
        ? YnotesColors.onSurface(brightness)
        : YnotesColors.onSurfaceMuted(brightness);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(YnotesRadius.sm),
        child: SizedBox(
          width: YnotesSpacing.toolButtonWidth,
          height: YnotesSpacing.toolbarHeight,
          child: Icon(icon, size: 22, color: color),
        ),
      ),
    );
  }
}

// ── Colour Dot ────────────────────────────────────────────────────────────────

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: YnotesSpacing.sm),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stub colour picker sheet ───────────────────────────────────────────────────

/// Temporary colour picker stub — replaced in Phase 2-C by YnotesColorPalettePopover.
class _ColorPickerSheet extends StatelessWidget {
  const _ColorPickerSheet({
    required this.currentColor,
    required this.onColorSelected,
  });

  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(YnotesSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Colour', style: YnotesTypography.headlineMedium),
          const SizedBox(height: YnotesSpacing.md),
          Wrap(
            spacing: YnotesSpacing.sm,
            runSpacing: YnotesSpacing.sm,
            children: YnotesColors.defaultPalette.map((c) {
              return GestureDetector(
                onTap: () {
                  onColorSelected(c);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: c == currentColor
                        ? Border.all(color: YnotesColors.brandIndigo, width: 3)
                        : Border.all(color: Colors.transparent, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: YnotesSpacing.lg),
        ],
      ),
    );
  }
}
