/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; Claude Sonnet 4; notebook cover system
library;

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:saber/components/canvas/invert_widget.dart';
import 'package:saber/components/home/cover_picker_dialog.dart';
import 'package:saber/components/home/notebook_cover_widget.dart';
import 'package:saber/components/home/sync_indicator.dart';
import 'package:saber/data/file_manager/file_manager.dart';
import 'package:saber/data/is_this_a_test.dart';
import 'package:saber/data/notebook_cover.dart';
import 'package:saber/data/prefs.dart';
import 'package:saber/data/routes.dart';
import 'package:saber/pages/editor/editor.dart';
import 'package:yaru/yaru.dart';

class PreviewCard extends StatefulWidget {
  PreviewCard({
    required this.filePath,
    required this.toggleSelection,
    required this.selected,
    required this.isAnythingSelected,
  }) : super(key: ValueKey('PreviewCard$filePath'));

  final String filePath;
  final bool selected;
  final bool isAnythingSelected;
  final void Function(String, bool) toggleSelection;

  @override
  State<PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<PreviewCard> {
  final expanded = ValueNotifier(false);
  final thumbnail = _ThumbnailState();

  NotebookCover _cover = NotebookCover.defaultCover();
  bool _coverLoaded = false;

  @override
  void initState() {
    fileWriteSubscription = FileManager.fileWriteStream.stream.listen(
      fileWriteListener,
    );

    expanded.value = widget.selected;
    _loadCover();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final imageFile = FileManager.getFile(
      '${widget.filePath}${Editor.extension}.p',
    );
    if (isThisATest) {
      // Avoid FileImages in tests
      thumbnail.image = imageFile.existsSync()
          ? MemoryImage(imageFile.readAsBytesSync())
          : null;
    } else {
      thumbnail.image = FileImage(imageFile);
    }
  }

  Future<void> _loadCover() async {
    final cover = await NotebookCoverStore.load(widget.filePath);
    if (!mounted) return;
    setState(() {
      _cover = cover;
      _coverLoaded = true;
    });
  }

  StreamSubscription? fileWriteSubscription;
  void fileWriteListener(FileOperation event) {
    if (event.filePath != widget.filePath) return;
    if (event.type == .delete) {
      thumbnail.image = null;
    } else if (event.type == .write) {
      thumbnail.image?.evict();
      thumbnail.markAsChanged();
    } else {
      throw Exception('Unknown file operation type: ${event.type}');
    }
  }

  void _toggleCardSelection() {
    expanded.value = !expanded.value;
    widget.toggleSelection(widget.filePath, expanded.value);
  }

  Future<void> _openCoverPicker() async {
    final noteName =
        widget.filePath.substring(widget.filePath.lastIndexOf('/') + 1);
    final newCover = await CoverPickerDialog.show(
      context,
      initialCover: _cover,
      noteName: noteName,
    );
    if (newCover == null) return;
    await NotebookCoverStore.save(widget.filePath, newCover);
    if (!mounted) return;
    setState(() => _cover = newCover);
  }

  Timer? _refreshThumbnailTimer;
  void _refreshThumbnailAfterDelay() {
    _refreshThumbnailTimer?.cancel();
    _refreshThumbnailTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      thumbnail.image?.evict();
      thumbnail.markAsChanged();
    });
  }

  String get _noteName =>
      widget.filePath.substring(widget.filePath.lastIndexOf('/') + 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final transitionDuration = Duration(
      milliseconds: disableAnimations ? 0 : 300,
    );
    final invert = theme.brightness == .dark && stows.editorAutoInvert.value;

    final Widget card = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isAnythingSelected ? _toggleCardSelection : null,
        onSecondaryTap: _toggleCardSelection,
        onLongPress: widget.isAnythingSelected
            ? _toggleCardSelection
            : _openCoverPicker,
        child: _NotebookCardLayout(
          noteName: _noteName,
          cover: _coverLoaded ? _cover : NotebookCover.defaultCover(),
          thumbnail: thumbnail,
          invert: invert,
          expanded: expanded,
          colorScheme: colorScheme,
          filePath: widget.filePath,
          simplifiedLayout: stows.simplifiedHomeLayout.value,
        ),
      ),
    );

    return ValueListenableBuilder(
      valueListenable: expanded,
      builder: (context, expanded, _) {
        return OpenContainer(
          clipBehavior: Clip.none,
          closedColor: colorScheme.surface,
          closedShape: RoundedRectangleBorder(
            side: BorderSide(
              color: expanded
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.12),
              width: kYaruFocusBorderWidth,
            ),
            borderRadius: .circular(kYaruContainerRadius),
          ),
          closedElevation: 0,
          closedBuilder: (context, action) => card,
          openColor: colorScheme.surface,
          openBuilder: (context, action) => Editor(path: widget.filePath),
          transitionDuration: transitionDuration,
          routeSettings: RouteSettings(
            name: RoutePaths.editFilePath(widget.filePath),
          ),
          onClosed: (_) => _refreshThumbnailAfterDelay(),
        );
      },
    );
  }

  @override
  void dispose() {
    _refreshThumbnailTimer?.cancel();
    fileWriteSubscription?.cancel();
    super.dispose();
  }
}

/// The visual layout of a notebook card in the library grid.
///
/// Renders the note as a physical notebook: a coloured spine on the left,
/// the cover page thumbnail in the main area, and the title at the bottom.
class _NotebookCardLayout extends StatelessWidget {
  const _NotebookCardLayout({
    required this.noteName,
    required this.cover,
    required this.thumbnail,
    required this.invert,
    required this.expanded,
    required this.colorScheme,
    required this.filePath,
    required this.simplifiedLayout,
  });

  final String noteName;
  final NotebookCover cover;
  final _ThumbnailState thumbnail;
  final bool invert;
  final ValueNotifier<bool> expanded;
  final ColorScheme colorScheme;
  final String filePath;
  final bool simplifiedLayout;

  static const _spineWidth = 14.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Spine ──────────────────────────────────────────────────────────
        _NotebookSpine(color: cover.color, width: _spineWidth),
        // ── Cover + title ──────────────────────────────────────────────────
        Expanded(
          child: Column(
            mainAxisSize: simplifiedLayout ? .max : .min,
            children: [
              Flexible(
                fit: simplifiedLayout ? .tight : .loose,
                child: Stack(
                  children: [
                    // Cover design background
                    Positioned.fill(
                      child: NotebookCoverWidget(
                        cover: cover,
                        spineWidth: 0,
                        borderRadius: 0,
                        elevation: 0,
                      ),
                    ),
                    // Page thumbnail overlaid on top (shows written content)
                    ListenableBuilder(
                      listenable: thumbnail,
                      builder: (context, _) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: ConstrainedBox(
                          key: ValueKey(thumbnail.updateCount),
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                            minHeight: 80,
                          ),
                          child: thumbnail.doesImageExist
                              ? InvertWidget(
                                  invert: invert,
                                  child: Image(
                                    image: thumbnail.image!,
                                    alignment: .topCenter,
                                    fit: .cover,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    // Selection overlay
                    Positioned.fill(
                      left: -1,
                      top: -1,
                      right: -1,
                      bottom: -1,
                      child: ValueListenableBuilder(
                        valueListenable: expanded,
                        builder: (context, isExpanded, child) =>
                            AnimatedOpacity(
                              opacity: isExpanded ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: IgnorePointer(
                                ignoring: !isExpanded,
                                child: child!,
                              ),
                            ),
                        child: GestureDetector(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: .topCenter,
                                end: .bottomCenter,
                                colors: [
                                  colorScheme.surface.withValues(alpha: 0.2),
                                  colorScheme.surface.withValues(alpha: 0.8),
                                  colorScheme.surface.withValues(alpha: 1),
                                ],
                              ),
                            ),
                            child: ColoredBox(
                              color: colorScheme.primary.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SyncIndicator(filePath: filePath),
                  ],
                ),
              ),
              Padding(
                padding: const .all(8),
                child: Text(
                  noteName,
                  maxLines: 2,
                  overflow: .ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A thin coloured spine strip for the left edge of the notebook card.
class _NotebookSpine extends StatelessWidget {
  const _NotebookSpine({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    final spineColor = _darken(color, 0.15);
    return Container(
      width: width,
      color: spineColor,
      child: Center(
        child: Container(
          width: 1.5,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

class _ThumbnailState extends ChangeNotifier {
  var updateCount = 0;
  ImageProvider? _image;

  void markAsChanged() {
    ++updateCount;
    notifyListeners();
  }

  ImageProvider? get image => _image;
  set image(ImageProvider? image) {
    _image = image;
    markAsChanged();
  }

  bool get doesImageExist => switch (image) {
    (final FileImage fileImage) => fileImage.file.existsSync(),
    null => false,
    _ => true,
  };
}
