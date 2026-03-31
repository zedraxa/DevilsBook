/// 🤖 Generated wholely or partially with Claude Sonnet 4.5; notebook cover system
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:saber/data/file_manager/file_manager.dart';
import 'package:saber/pages/editor/editor.dart';

/// The file extension appended to a note file path to produce the cover
/// metadata sidecar, e.g. `mynote.sbn2.cover`.
const _coverExtension = '.cover';

/// Predefined cover colour palette, iPad-focused with vibrant choices.
const notebookCoverPalette = <Color>[
  Color(0xFFE53935), // Red
  Color(0xFFD81B60), // Pink
  Color(0xFF8E24AA), // Purple
  Color(0xFF3949AB), // Indigo
  Color(0xFF1E88E5), // Blue
  Color(0xFF00ACC1), // Cyan
  Color(0xFF00897B), // Teal
  Color(0xFF43A047), // Green
  Color(0xFFF4511E), // Deep Orange
  Color(0xFFFFB300), // Amber
  Color(0xFF6D4C41), // Brown
  Color(0xFF546E7A), // Blue Grey
];

/// Visual templates for notebook covers.
enum NotebookCoverTemplate {
  plain,
  linen,
  dots,
  stripes,
  leather,
  grid,
  floral,
}

/// Metadata for the visual appearance of a notebook cover.
///
/// Stored as a JSON sidecar file alongside the note, e.g. `mynote.sbn2.cover`.
class NotebookCover {
  const NotebookCover({
    required this.colorValue,
    required this.template,
  });

  factory NotebookCover.defaultCover() => const NotebookCover(
    colorValue: 0xFF1E88E5,
    template: NotebookCoverTemplate.plain,
  );

  factory NotebookCover.fromJson(Map<String, dynamic> json) => NotebookCover(
    colorValue: (json['colorValue'] as int?) ?? 0xFF1E88E5,
    template: NotebookCoverTemplate.values.firstWhere(
      (t) => t.name == (json['template'] as String?),
      orElse: () => NotebookCoverTemplate.plain,
    ),
  );

  final int colorValue;
  final NotebookCoverTemplate template;

  Color get color => Color(colorValue);

  NotebookCover copyWith({int? colorValue, NotebookCoverTemplate? template}) =>
      NotebookCover(
        colorValue: colorValue ?? this.colorValue,
        template: template ?? this.template,
      );

  Map<String, dynamic> toJson() => {
    'colorValue': colorValue,
    'template': template.name,
  };
}

/// Reads and writes [NotebookCover] metadata for note files.
abstract class NotebookCoverStore {
  static final _log = Logger('NotebookCoverStore');

  /// Sidecar file path for a given note file path (without extension).
  static String _sidecarPath(String notePath) =>
      '${notePath}${Editor.extension}$_coverExtension';

  /// Loads the [NotebookCover] for [notePath] (without `.sbn2` extension).
  /// Returns a default cover when no sidecar exists.
  static Future<NotebookCover> load(String notePath) async {
    final sidecar = _sidecarPath(notePath);
    try {
      final bytes = await FileManager.readFile(sidecar);
      if (bytes == null) return NotebookCover.defaultCover();
      final json =
          jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>? ?? {};
      return NotebookCover.fromJson(json);
    } catch (e, st) {
      _log.warning('Failed to read cover sidecar $sidecar', e, st);
      return NotebookCover.defaultCover();
    }
  }

  /// Persists [cover] for [notePath] (without `.sbn2` extension).
  static Future<void> save(String notePath, NotebookCover cover) async {
    final sidecar = _sidecarPath(notePath);
    final bytes = utf8.encode(jsonEncode(cover.toJson()));
    await FileManager.writeFile(
      sidecar,
      bytes,
      alsoUpload: false,
    );
  }

  /// Deletes the cover sidecar for [notePath] (without `.sbn2` extension).
  static Future<void> delete(String notePath) async {
    final sidecar = _sidecarPath(notePath);
    final file = FileManager.getFile(sidecar);
    if (file.existsSync()) await file.delete();
  }

  /// Whether [filePath] is a cover sidecar file.
  static bool isCoverSidecar(String filePath) =>
      filePath.endsWith(_coverExtension);
}
