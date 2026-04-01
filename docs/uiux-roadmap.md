# Ynotes — UI/UX Overhaul Roadmap

> **Branch:** `cUİ-experiment`  
> **Goal:** Rebrand DevilsBook → **Ynotes**, migrate editor UI/UX toward a GoodNotes-like experience while preserving every existing feature and keeping iOS builds green.

---

## 0. Guiding Principles

| Principle | Detail |
|-----------|--------|
| **Feature-safe** | Every existing feature must still work after each phase. |
| **iOS-first** | Verify `flutter build ios --no-codesign` passes at end of every phase. |
| **Incremental** | Changes are small, atomic, and individually reversible. |
| **GoodNotes-inspired, not copied** | No proprietary assets; interaction patterns only. |
| **Credit AI work** | All AI-modified files carry `/// 🤖 Generated wholely or partially with …` header. |

---

## Phase 1 — Foundation (Rebrand + Design System)

These tasks are mostly independent and can run **in parallel across multiple agents**.

### 1-A · Rebrand to "Ynotes" *(Agent A)*
- [x] Update `ios/Runner/Info.plist`: `CFBundleDisplayName` and `CFBundleName` → `Ynotes`
- [x] Update `lib/main.dart`: `DynamicMaterialApp(title: 'Ynotes', …)`
- [x] Update English i18n (`lib/i18n/strings_en.g.dart`): replace "Devils Book" → "Ynotes" in user-visible strings
- [ ] Update German i18n (`lib/i18n/strings_de.g.dart`) similarly
- [ ] Update Turkish i18n (`lib/i18n/strings_tr.g.dart`) similarly
- [ ] Update remaining i18n locale files
- [ ] Update `android/app/src/main/AndroidManifest.xml` `android:label`
- [ ] Update `macos/Runner/Info.plist` display name
- [ ] Update `linux/` and `windows/` runner titles
- [ ] Update `README.md` title/badges (keep repo URL intact)
- [ ] Update `pubspec.yaml` description field

### 1-B · Design System Tokens *(Agent B)*
- [x] Create `lib/ynotes/design_system/ynotes_colors.dart` — brand palette, semantic colors, dark/light variants
- [x] Create `lib/ynotes/design_system/ynotes_typography.dart` — type scale (SF Pro compatible)
- [x] Create `lib/ynotes/design_system/ynotes_spacing.dart` — spacing / radius constants
- [x] Create `lib/ynotes/design_system/ynotes_shadows.dart` — elevation shadows
- [ ] Audit existing `SaberTheme` and wire new tokens as overrides
- [ ] Create barrel export `lib/ynotes/design_system/design_system.dart`

### 1-C · Ynotes Theme Integration *(Agent C, depends on 1-B)*
- [x] Create `lib/ynotes/theme/ynotes_theme.dart` — wraps `SaberTheme.createTheme` with Ynotes tokens
- [ ] Register `YnotesTheme` in `DynamicMaterialApp` as the default light/dark theme
- [ ] Add theme preview tile to the settings theme gallery

### 1-D · Navigation Shell Skeleton *(Agent D)*
- [ ] Create `lib/ynotes/navigation/ynotes_shell.dart` — persistent sidebar/tab-bar shell (iPad: side rail, iPhone: bottom tabs) mirroring GoodNotes navigation
- [ ] Create `lib/ynotes/navigation/ynotes_destination.dart` — destination enum (Library, Recent, Search, Settings)
- [ ] Integrate shell into `lib/pages/home/home.dart` behind a feature flag (`kYnotesShell`) so existing navigation still works
- [ ] Add widget test for shell rendering on narrow/wide viewports

---

## Phase 2 — Editor Toolbar Overhaul

### 2-A · Toolbar Architecture *(Agent E)*
- [x] Create `lib/ynotes/toolbar/ynotes_toolbar.dart` — scaffold for GoodNotes-style floating toolbar strip
- [ ] Create `lib/ynotes/toolbar/tool_switcher.dart` — horizontal icon row: Pen, Highlighter, Eraser, Lasso, Text, Hand
- [ ] Create `lib/ynotes/toolbar/favorites_strip.dart` — up to 5 favorite pen presets with color dot indicators
- [ ] Create `lib/ynotes/toolbar/color_palette_popover.dart` — 24-slot hex grid + custom color picker
- [ ] Create `lib/ynotes/toolbar/stroke_size_slider.dart` — continuous slider with live preview stroke
- [ ] Create `lib/ynotes/toolbar/undo_redo_bar.dart` — compact undo/redo buttons matching GoodNotes placement
- [ ] Inject `YnotesToolbar` into `editor.dart` as a draggable floating bar behind feature flag `kYnotesToolbar`
- [ ] Deprecate injection of the old `Toolbar` widget (keep as fallback)

### 2-B · Favorites System *(Agent F, depends on 2-A)*
- [ ] Create `lib/ynotes/toolbar/favorites_model.dart` — `FavoritePen` value object (tool + color + size)
- [ ] Persist favorites via `Prefs` shared-preferences key `ynotes_favorite_pens`
- [ ] Add reorder gesture to favorites strip (long-press drag)
- [ ] Write unit tests for `FavoritesModel` CRUD operations

### 2-C · Color Palette System *(Agent G)*
- [ ] Create `lib/ynotes/toolbar/palette_preset.dart` — named palette with 24 `Color` entries
- [ ] Bundle three built-in palettes (Classic, Pastel, Dark)
- [ ] Persist custom color additions to `Prefs`
- [ ] Widget test: palette renders correctly and fires `onColorSelected`

### 2-D · Hand/Scroll Tool *(Agent H)*
- [ ] Add `HandTool` class in `lib/data/tools/hand_tool.dart` — suppresses drawing on canvas touch
- [ ] Register in tool switcher
- [ ] Integrate into editor gesture dispatcher (when `HandTool` active, route touches to pan/zoom only)

---

## Phase 3 — Apple Pencil Pro Features

### 3-A · Squeeze Gesture Refinement *(Agent I)*
- [ ] Audit current `SqueezePaletteController` and `DevilsPencilPlugin.swift` squeeze handling
- [ ] Map double-squeeze → activate last used eraser (GoodNotes behavior)
- [ ] Map long-squeeze → open favorites strip popover
- [ ] Add configurable mapping in Settings > Pencil

### 3-B · Barrel Roll Calligraphic Mode *(Agent J)*
- [ ] Verify `SaberBarrelRollGestureRecognizer` and `Pen.onDragUpdate(orientation)` pipeline
- [ ] Expose "Barrel Roll sensitivity" slider in Settings > Pencil
- [ ] Add visual indicator in toolbar when barrel-roll-calligraphy is active

### 3-C · Hover Ghost Nib *(Agent K)*
- [ ] Review `GhostNib` component integration in `editor.dart`
- [ ] Make ghost nib respect active tool color and size
- [ ] Animate opacity on hover enter/exit (fade 150 ms)

### 3-D · Roll Angle Visual Feedback *(Agent L)*
- [ ] Show tilt/roll angle overlay in developer mode (useful for testing)
- [ ] Gate on `kDebugMode` only

---

## Phase 4 — Canvas & Page Experience

### 4-A · GoodNotes-style Page Manager *(Agent M)*
- [ ] Redesign `EditorPageManager` strip: thumbnails with page numbers, drag-to-reorder
- [ ] Add "Add page" / "Duplicate page" / "Delete page" context menu per thumbnail
- [ ] Animate page insertion/deletion

### 4-B · Infinite Scroll Canvas *(Agent N)*
- [ ] Audit current paged-scroll implementation in `editor.dart`
- [ ] Add optional "continuous scroll" mode with virtualization (render only ±2 pages)
- [ ] Expose toggle in Settings > Editor

### 4-C · Paper Templates *(Agent O)*
- [ ] Expose richer template gallery in `PaperSelectorSheet` with visual previews
- [ ] Bundle templates: Blank, Lined, Grid, Dot-grid, Cornell, Music staff, Calendar
- [ ] Per-template dark-mode paper color

---

## Phase 5 — Data Persistence & Save

> **Known issue:** There are suspected save/persistence bugs inherited from the Saber base.

### 5-A · Save Pipeline Audit *(Agent P)*
- [ ] Trace `_saveToFile` call graph in `editor.dart` end-to-end
- [ ] Identify all `setState` + debounce patterns that could drop saves
- [ ] Write regression test: create note → simulate app backgrounding → re-open → strokes present
- [ ] Fix any identified race conditions in `FileManager`

### 5-B · Autosave Hardening *(Agent Q)*
- [ ] Add `WillPopScope` / `PopScope` save flush before navigation (if not already present)
- [ ] Add app-lifecycle listener (`AppLifecycleState.paused`) to force-flush pending saves
- [ ] Log save events to `Logger` at INFO level with timing
- [ ] Write unit test for autosave flush on lifecycle change

### 5-C · SQLite Metadata Store *(Agent R)*
- [ ] Evaluate `sqflite` vs `drift` for metadata persistence
- [ ] Create `lib/data/db/metadata_db.dart` schema: `notes(path, title, modified_at, page_count, cover_color)`
- [ ] Migrate `ArchiveManager` to read/write from DB
- [ ] Ensure DB migrates cleanly on schema change (migration version table)

---

## Phase 6 — Google Drive Integration

### 6-A · Research & Design *(Agent S)*
- [ ] Evaluate `google_sign_in` + `googleapis` (Drive v3) vs `gsheets` package feasibility
- [ ] Design sync model: conflict resolution (last-write-wins vs manual merge)
- [ ] Define Drive folder structure: `/Ynotes/<notebook>/<page>.sbn2`
- [ ] Draft `lib/data/sync/google_drive/google_drive_syncer.dart` interface matching existing `SaberSyncer`

### 6-B · Auth Flow *(Agent T, depends on 6-A)*
- [ ] Add Google Sign-In button to `lib/pages/user/login.dart`
- [ ] Store OAuth tokens securely via `flutter_secure_storage`
- [ ] Handle token refresh and revocation

### 6-C · Sync Engine *(Agent U, depends on 6-A, 6-B)*
- [ ] Implement chunked upload of `.sbn2` files to Drive
- [ ] Implement delta-download on app foreground
- [ ] Show sync progress in home screen header

### 6-D · Conflict Resolution UI *(Agent V)*
- [ ] Build `lib/ynotes/sync/conflict_resolution_sheet.dart`
- [ ] Present "Keep local / Keep remote / Keep both" options
- [ ] Write widget test for conflict sheet

---

## Phase 7 — Polish & CI

### 7-A · Widget Tests for New Components *(Agent W)*
- [ ] Tests for `YnotesToolbar` tool switching
- [ ] Tests for `ColorPalettePopover`
- [ ] Tests for `FavoritesStrip` reorder
- [ ] Tests for `YnotesNavigationShell` responsive breakpoints

### 7-B · CI: iOS Build Check *(Agent X)*
- [ ] Add/verify `.github/workflows/ios.yml` runs `flutter build ios --no-codesign`
- [ ] Ensure build passes after every phase's changes
- [ ] Add Codemagic step `flutter analyze --no-pub` before build
- [ ] Document CI environment requirements in `CONTRIBUTING.md`

### 7-C · Accessibility Audit *(Agent Y)*
- [ ] Run `flutter analyze` semantics audit on new toolbar
- [ ] Ensure all interactive elements have `Semantics` labels
- [ ] Verify VoiceOver traversal order on iPad

### 7-D · Performance Profiling *(Agent Z)*
- [ ] Profile canvas re-render rate during fast stylus strokes
- [ ] Identify `setState` hotspots in `editor.dart`
- [ ] Replace with `RepaintBoundary` / `ValueListenableBuilder` where appropriate

---

## Dependency Graph (simplified)

```
1-A ─────────────────────────────────────────────────────── 7-B
1-B ──► 1-C ──► 7-A
1-D ─────────────────────────────────────────────────────── 7-A
2-A ──► 2-B, 2-C, 2-D ──────────────────────────────────── 7-A
3-A, 3-B, 3-C, 3-D  (independent of toolbar)
4-A, 4-B, 4-C (independent)
5-A ──► 5-B ──► 5-C
6-A ──► 6-B ──► 6-C ──► 6-D
```

---

## Implementation Status

| Phase | Status |
|-------|--------|
| 1-A Rebrand | 🟡 In progress |
| 1-B Design tokens | 🟡 In progress |
| 1-C Theme integration | 🟡 In progress |
| 1-D Navigation shell | ⬜ Pending |
| 2-A Toolbar skeleton | 🟡 In progress |
| 2-B–D Toolbar features | ⬜ Pending |
| 3-A–D Pencil Pro | ⬜ Pending |
| 4-A–C Canvas | ⬜ Pending |
| 5-A–C Persistence | ⬜ Pending |
| 6-A–D Google Drive | ⬜ Pending |
| 7-A–D Polish & CI | ⬜ Pending |

---

*Last updated: 2026-04-01 — Initial roadmap commit*
