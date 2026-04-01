# Ynotes — Full Rebuild Roadmap

> **Branch:** `cUİ-experiment`  
> **Vision:** Saber'ın tüm UI/UX kalıntılarını yık, yerine **Ynotes** — kullanıcı seçimli temalı (Crimson Red, Dark, Light, Holy Islamic Green, Relaxing vb.), GoodNotes esinli, bağımsız bir not uygulaması inşa et.  
> **Kural:** Saber'ın tema sistemi (`SaberTheme`, `DynamicMaterialApp`'taki Saber referansları, Yaru bağımlılığı) tamamen kaldırılıp yerine Ynotes'un kendi bağımsız tema sistemi gelecek.

---

## 0. Kurallar

| Kural | Detay |
|-------|-------|
| **Saber yıkılacak** | `SaberTheme`, Yaru tema bağımlılığı, eski toolbar, eski navigation tamamen kaldırılacak. |
| **iOS build her zaman yeşil** | Her faz sonunda `flutter build ios --no-codesign` geçmeli. |
| **Temalar kullanıcı seçimli** | Light, Dark, Crimson Red, Holy (Islamic Green), Relaxing vb. kullanıcı ayarlardan seçer. |
| **AI credit** | Tüm AI-düzenlenmiş dosyalarda `/// 🤖 Generated wholely or partially with …` header olacak. |
| **Shared log** | Her ajan yaptığını `docs/agent-log.md` dosyasına yazar. Son entegrasyon ajanı bunu okur. |

---

## Agent Log Convention (Tüm Ajanlar İçin)

Her ajan, görevini tamamladığında `docs/agent-log.md` dosyasına şu formatta ekleme yapar:

```markdown
## [TASK-ID] — [Task Adı]
- **Agent:** [Model adı]
- **Tarih:** [ISO timestamp]
- **Durum:** ✅ Tamamlandı / ⚠️ Kısmi / ❌ Başarısız
- **Değişen dosyalar:**
  - `path/to/file1.dart` — ne yapıldı
  - `path/to/file2.dart` — ne yapıldı
- **Notlar:** [varsa ek bilgi, karşılaşılan sorunlar]
- **Build test:** `flutter analyze` ✅ / ❌
```

---

## Model Seçim Rehberi

| İş Tipi | Önerilen Model | Neden |
|---------|---------------|-------|
| **Codebase keşif / audit** | `claude-sonnet-4` veya `gemini-2.5-pro` | Hızlı, geniş context, analiz güçlü |
| **Yeni Dart widget yazma** | `claude-sonnet-4.5` veya `gpt-5.2-codex` | Yaratıcı UI kodu, Flutter bilgisi derin |
| **Büyük refactoring / silme** | `claude-opus-4.5` veya `gpt-5.4` | Karmaşık bağımlılık zincirlerini takip edebilir |
| **Swift / iOS native** | `claude-sonnet-4.5` veya `gpt-5.2-codex` | Swift + UIKit + PencilKit bilgisi |
| **Test yazma** | `claude-sonnet-4` veya `gpt-5-mini` | Tekrarlayan pattern, hızlı |
| **i18n / string değiştirme** | `claude-haiku-4.5` veya `gpt-5-mini` | Basit find-replace, hız yeterli |
| **CI / build config** | `claude-sonnet-4` | YAML + shell bilgisi |
| **Araştırma / plan** | `gemini-2.5-pro` veya `claude-opus-4.5` | Geniş bilgi tabanı, derin analiz |
| **Entegrasyon / birleştirme** | `claude-opus-4.5` | Tüm dosyaları birlikte görmeli, çatışma çözmeli |

---

# PHASE 0 — Audit & Keşif

---

### TASK-0A · Saber Kalıntı Haritası Çıkarma

**Model:** `claude-sonnet-4` (explore agent)  
**Paralel:** ✅ Bağımsız çalışabilir

<details><summary>📋 Agent Prompt (kopyala-yapıştır)</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Saber'ın tüm UI/UX kalıntılarının tam bir haritasını çıkar.

1. `lib/components/theming/` altındaki tüm dosyaları oku:
   - saber_theme.dart (220 satır)
   - dynamic_material_app.dart (254 satır)
   - yaru_builder.dart (142 satır)
   Bu dosyaları hangi dosyalar import ediyor? `grep -rl "saber_theme\|SaberTheme\|YaruBuilder\|dynamic_material_app\|DynamicMaterialApp" lib/` çalıştır.

2. `lib/components/toolbar/toolbar.dart` ve tüm alt dosyalarını oku.
   Kaç widget var? Bunları kim kullanıyor?

3. `lib/pages/home/` altındaki tüm dosyaları oku — mevcut navigation yapısını çıkar.

4. `lib/data/prefs.dart`'ta activeThemeId, accentColor, platform gibi tema ile ilgili tüm preference key'leri bul.

5. Sonuçları `docs/agent-log.md` dosyasına yaz:
   - Hangi dosyalar Saber temasına bağımlı (tam liste)
   - Hangi dosyalar toolbar'a bağımlı
   - Hangi dosyalar navigation'a bağımlı
   - Hangi preference key'ler tema/UI ile ilgili

Format:
## TASK-0A — Saber Kalıntı Haritası
- **Agent:** [model adın]
- **Tarih:** [şu anki tarih]
- **Durum:** ✅
- **Bulgular:** [yukarıdaki 5 madde]
```

</details>

---

### TASK-0B · GoodNotes UI/UX Araştırması

**Model:** `gemini-2.5-pro` veya `claude-opus-4.5` (araştırma)  
**Paralel:** ✅ 0A ile aynı anda çalışabilir

<details><summary>📋 Agent Prompt</summary>

```
GÖREV: GoodNotes 6'nın UI/UX pattern'lerini araştır ve Ynotes'a uyarlanabilecek detaylı bir spec yaz.

Web araştırması yap:
1. GoodNotes 6 toolbar: floating bar, tool switcher layout, favorites strip, color picker
2. GoodNotes 6 navigation: Library view (grid/list), folders, recent notes, search
3. GoodNotes 6 page management: thumbnail strip, infinite scroll vs paginated
4. GoodNotes 6 Apple Pencil Pro: squeeze, barrel roll, hover nib davranışları
5. GoodNotes 6 theming: dark mode, paper styles, template gallery

Her pattern için:
- Davranış açıklaması
- Etkileşim detayı (tap, long-press, drag, gesture)
- Layout metrikleri (yaklaşık boyutlar, spacing)

Sonuçları `docs/goodnotes-research.md` dosyasına yaz.
Ayrıca `docs/agent-log.md`'ye TASK-0B girişi ekle.
```

</details>

---

### TASK-0C · Mevcut Kaydetme/Persistence Sorunları Audit

**Model:** `claude-sonnet-4.5` (code analysis)  
**Paralel:** ✅ 0A ve 0B ile aynı anda çalışabilir

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Bilinen kaydetme/persistence sorunlarını tespit et.

1. `lib/pages/editor/editor.dart` (1347 satır) dosyasını oku. _saveToFile, autosave, debounce pattern'lerini bul.
2. `lib/data/file_manager/file_manager.dart` dosyasını oku. Race condition riski olan yerleri işaretle.
3. `lib/devils_book/sessions/session_controller.dart` — session lifecycle ve save etkileşimini incele.
4. `lib/devils_book/archive/archive_manager.dart` — metadata persistence'ı incele.
5. Editor'da `PopScope` / `WillPopScope` var mı? App lifecycle listener (`AppLifecycleState.paused`) ile save flush yapılıyor mu?

Sonuçları `docs/save-audit.md`'ye yaz:
- Tespit edilen sorunlar (severity: critical/medium/low)
- Her sorun için önerilen fix
- Risk değerlendirmesi

Ayrıca `docs/agent-log.md`'ye TASK-0C girişi ekle.
```

</details>

---

# PHASE 1 — Saber Yıkım + Ynotes Tema Sistemi

> **Bağımlılık:** TASK-0A tamamlandıktan sonra başlayabilir.

---

### TASK-1A · SaberTheme Kaldırma + YnotesTheme Bağımsızlaştırma

**Model:** `claude-opus-4.5` veya `claude-sonnet-4.5` (büyük refactoring)  
**Paralel:** ❌ Bu tek başına çalışmalı, temel dosyaları değiştiriyor

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: SaberTheme'i tamamen kaldır, YnotesTheme'i bağımsız hale getir.

MEVCUT DURUM:
- lib/ynotes/theme/ynotes_theme.dart SaberTheme.createThemeFromSeed'i wrap ediyor — YANLIŞ
- lib/components/theming/saber_theme.dart var (220 satır) — KALDIRILACAK
- lib/components/theming/dynamic_material_app.dart SaberTheme kullanıyor — DEĞİŞECEK
- lib/components/theming/yaru_builder.dart Linux-only Yaru tema — DEĞERLENDİR

ADIMLAR:
1. `lib/ynotes/theme/ynotes_theme.dart` dosyasını tamamen yeniden yaz:
   - SaberTheme import'unu kaldır
   - Material 3 `ColorScheme.fromSeed` kullanarak tamamen bağımsız tema oluştur
   - `YnotesTheme.light()` ve `YnotesTheme.dark()` SaberTheme'e bağımlı OLMAYACAK
   - `YnotesTheme.fromPreset(YnotesAppTheme preset)` metodu ekle (aşağıdaki temalara göre)

2. `lib/ynotes/theme/ynotes_app_themes.dart` oluştur — kullanıcı seçimli temalar:
   ```dart
   enum YnotesAppTheme {
     light,       // Clean white, minimal
     dark,        // True dark mode
     crimsonRed,  // Deep crimson, passionate
     holyGreen,   // Islamic calligraphy green, serene
     relaxing,    // Soft lavender/sage, calming
     midnight,    // Deep navy blue
     warmSand,    // Warm beige/cream
   }
   ```
   Her tema için tam ColorScheme tanımla (surface, onSurface, primary, secondary, tertiary, canvas paper color, toolbar tint).

3. `lib/components/theming/dynamic_material_app.dart` değiştir:
   - SaberTheme import'unu kaldır
   - YaruBuilder referanslarını kaldır (Linux'ta da Ynotes teması kullanılacak)
   - DevilsCatalog.themes[activeThemeId] yerine YnotesAppTheme enum kullan
   - stows.activeThemeId'yi oku → YnotesAppTheme'e map et
   - YnotesTheme.fromPreset() kullan

4. `lib/components/theming/saber_theme.dart` dosyasını sil VEYA içini boşalt ve tüm metotları YnotesTheme'e yönlendir.

5. SaberTheme'i import eden diğer dosyaları düzelt:
   - lib/components/canvas/canvas_image_dialog.dart
   - lib/components/home/new_note_button.dart
   - lib/components/navbar/horizontal_navbar.dart
   - lib/components/theming/adaptive_*.dart dosyaları
   - lib/components/toolbar/editor_page_manager.dart
   - lib/pages/home/browse.dart, recent_notes.dart, settings.dart

6. `flutter analyze --no-pub` çalıştır, hata yoksa başarılı.

KURAL: `/// 🤖 Generated wholely or partially with [MODEL ADI] ✨` header'ı ekle.
Sonuçları `docs/agent-log.md`'ye TASK-1A olarak yaz.
```

</details>

---

### TASK-1B · Ynotes Kullanıcı Tema Seçim Sayfası

**Model:** `claude-sonnet-4.5` veya `gpt-5.2-codex` (UI widget)  
**Paralel:** ❌ TASK-1A tamamlandıktan sonra

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Kullanıcının tema seçebildiği bir ayar sayfası oluştur.

ÖN KOŞUL: TASK-1A tamamlanmış, YnotesAppTheme enum'u ve YnotesTheme.fromPreset() mevcut.

ADIMLAR:
1. `lib/ynotes/theme/theme_picker_sheet.dart` oluştur:
   - Her YnotesAppTheme için görsel önizleme kartı (renkli daire + isim + mini paper preview)
   - Grid layout (2 sütun)
   - Seçilen tema vurgulanmış border ile gösterilir
   - Seçim yapılınca `stows.activeThemeId.value = theme.name` kaydedilir
   - Animasyonlu geçiş (300ms)

2. `lib/pages/home/settings.dart` dosyasına tema picker'ı entegre et:
   - Mevcut ThemeGallery widget'ını kaldır veya YnotesThemePicker ile değiştir
   - "Tema" başlığı altında yeni picker göster

3. Her tema kartı şunu göstermeli:
   - Tema adı (Light, Dark, Crimson Red, Holy Green, Relaxing, Midnight, Warm Sand)
   - Ana renk dairesi
   - Küçük paper background preview
   - Seçili olanın checkmark'ı

4. Widget test yaz: `test/ynotes/theme_picker_test.dart`
   - 7 temanın hepsinin render olduğunu doğrula
   - Tema seçimi callback'ini doğrula

`docs/agent-log.md`'ye TASK-1B girişi ekle.
```

</details>

---

### TASK-1C · Rebrand Tamamlama (Tüm Platformlar)

**Model:** `claude-haiku-4.5` veya `gpt-5-mini` (basit string replace)  
**Paralel:** ✅ TASK-1A ile aynı anda çalışabilir (farklı dosyalar)

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: "Devils Book" → "Ynotes" rebrand'ını TÜM platformlarda tamamla.

ZATEN YAPILDI:
- ✅ ios/Runner/Info.plist (CFBundleDisplayName, CFBundleName)
- ✅ lib/main.dart (DynamicMaterialApp title)
- ✅ lib/i18n/strings_en.g.dart (İngilizce)

YAPILACAK:
1. `lib/i18n/strings_de.g.dart` — "Devils Book" → "Ynotes" (Almanca)
2. `lib/i18n/strings_tr.g.dart` — "Devils Book" → "Ynotes" (Türkçe)
3. Diğer tüm i18n dosyaları: strings_ar, strings_cs, strings_eo, strings_es, strings_fa, strings_fr, strings_he, strings_hu, strings_it, strings_ja, strings_pt_BR, strings_ru, strings_sl, strings_th, strings_vi, strings_zh_Hans_CN, strings_zh_Hant_TW
   Her birinde `grep -n "Devils Book" lib/i18n/strings_XX.g.dart` ile bul ve değiştir.
4. `android/app/src/main/AndroidManifest.xml` — android:label → "Ynotes"
5. `macos/Runner/Info.plist` — CFBundleDisplayName → "Ynotes"
6. `linux/` runner title
7. `windows/` runner title
8. `pubspec.yaml` description → "Ynotes - A modern note-taking app"
9. `README.md` — başlık ve ilk paragraf

KURAL: Package identifier'ları (bundle ID, package name) DEĞİŞTİRME. Sadece kullanıcıya görünen isimler.
`docs/agent-log.md`'ye TASK-1C girişi ekle.
```

</details>

---

### TASK-1D · DevilsCatalog Temalarını Ynotes'a Migrasyon

**Model:** `claude-sonnet-4.5` (refactoring)  
**Paralel:** ❌ TASK-1A tamamlandıktan sonra

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: DevilsCatalog'daki eski Saber/DevilsBook temalarını Ynotes tema sistemine taşı.

MEVCUT DURUM:
- lib/devils_book/registry/devils_catalog.dart (875 satır) içinde 21 ThemePreset var
- Bunlar DevilsCatalog.themes map'inde tutuluyor
- dynamic_material_app.dart'ta DevilsCatalog.themes[activeThemeId] ile seçiliyor

ADIMLAR:
1. Mevcut 21 temadan değerlileri Ynotes temasına dönüştür:
   - themeCrimsonRed → YnotesAppTheme.crimsonRed'e renk değerlerini aktar
   - themeHolyWhite → YnotesAppTheme.holyGreen'e temel yap (beyaz + altın → yeşil + altın)
   - themeAntiqueSoul → YnotesAppTheme.warmSand'e ilham
   - themeDarkPremium → YnotesAppTheme.dark'a ilham
   - themeObsidianDeep → YnotesAppTheme.midnight'a ilham

2. Yeni temalar ekle (mevcut olmayanlar):
   - YnotesAppTheme.holyGreen: Islamic calligraphy green (#006400 → #004D25 range), gold accent (#D4AF37), cream paper
   - YnotesAppTheme.relaxing: Soft sage green (#B2D8B0) + lavender (#E6E6FA), muted tones

3. `lib/ynotes/theme/ynotes_app_themes.dart` dosyasındaki her tema için tam renk seti:
   - surface, onSurface, primary, secondary, tertiary
   - toolbarBackground, toolbarForeground
   - canvasPaperColor, canvasLineColor
   - cardBackground, sheetBackground

4. DevilsCatalog.themes map'ini GÜNCELLEme — TASK-1A'da zaten dynamic_material_app YnotesTheme kullanacak.

`docs/agent-log.md`'ye TASK-1D girişi ekle.
```

</details>

---

# PHASE 2 — Toolbar Yeniden İnşa

> **Bağımlılık:** TASK-0B (GoodNotes araştırması) + TASK-1A tamamlandıktan sonra

---

### TASK-2A · Eski Toolbar Kaldırma + Yeni Toolbar Mimarisi

**Model:** `claude-opus-4.5` (karmaşık refactoring)  
**Paralel:** ❌ Tek başına

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Eski Saber toolbar'ını kaldır, yeni Ynotes toolbar mimarisini inşa et.

MEVCUT DURUM:
- lib/components/toolbar/toolbar.dart — eski Saber toolbar (flutter_quill bağımlılığı var)
- lib/components/toolbar/color_bar.dart, color_option.dart, size_picker.dart, toolbar_button.dart vb.
- lib/ynotes/toolbar/ynotes_toolbar.dart — scaffold mevcut ama editor.dart'a bağlı değil
- lib/pages/editor/editor.dart (1347 satır) — eski Toolbar widget'ını kullanıyor

ADIMLAR:
1. `lib/pages/editor/editor.dart`'ta eski `Toolbar(...)` widget kullanımını bul.
2. Onu `YnotesToolbar(...)` ile değiştir. YnotesToolbar'ın API'sını editor'ın ihtiyaçlarına göre genişlet:
   - currentTool → editor'ın mevcut Tool'unu map et
   - onToolSelected → editor'ın setTool metodunu çağır
   - currentColor → editor'ın currentColor'ını geç
   - onColorSelected → editor'ın setColor metodunu çağır
   - canUndo/canRedo → editor state'inden
   - onUndo/onRedo → editor metodlarından

3. `lib/ynotes/toolbar/ynotes_toolbar.dart` güncelle:
   - Floating, draggable olabilir (Positioned + GestureDetector.onPanUpdate)
   - YnotesToolbar'ı Stack içinde Positioned olarak yerleştir
   - SafeArea ve keyboard avoidance ekle

4. Eski toolbar dosyalarını KALDIRMA — sadece editor.dart'taki bağlantıyı kes.
   Eski toolbar dosyaları ileride tamamen silinecek (TASK-7C).

5. `flutter analyze --no-pub` çalıştır.

`docs/agent-log.md`'ye TASK-2A girişi ekle.
```

</details>

---

### TASK-2B · Tool Switcher Widget

**Model:** `claude-sonnet-4.5` veya `gpt-5.2-codex` (UI widget)  
**Paralel:** ✅ TASK-2C ve 2D ile aynı anda (farklı dosyalar)

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: GoodNotes tarzı tool switcher widget'ı oluştur.

1. `lib/ynotes/toolbar/tool_switcher.dart` oluştur:
   - Horizontal icon row: Pen, Highlighter, Eraser, Lasso, Text, Hand
   - Her tool bir IconButton + tooltip
   - Aktif tool vurgulanmış (mavi dot altında veya mavi border)
   - Double-tap bir tool'a → o tool'un ayarlar popover'ını aç (boyut, opaklık)
   - GoodNotes'taki gibi tool ikonu altında küçük renk dot'u (aktif renk göstergesi)

2. Mevcut tool sistemiyle entegrasyon:
   - `lib/data/tools/_tool.dart`'taki Tool abstract class'ını incele
   - YnotesTool enum → lib/data/tools/ class'larına mapping yaz
   - Pen, Highlighter, Eraser, Select (Lasso) zaten var: pen.dart, highlighter.dart, eraser.dart, select.dart

3. Hand tool mevcut değil — `lib/data/tools/hand_tool.dart` oluştur:
   - Tool'u extend et
   - onDragStart/onDragUpdate/onDragEnd → canvas pan/zoom'a delegate et
   - Çizim yapmaz, sadece navigate

4. Widget test: `test/ynotes/tool_switcher_test.dart`
   - 6 tool'un render olduğunu doğrula
   - Tool seçimi callback'ini doğrula
   - Aktif tool'un highlight olduğunu doğrula

`docs/agent-log.md`'ye TASK-2B girişi ekle.
```

</details>

---

### TASK-2C · Favorites Strip

**Model:** `claude-sonnet-4.5` (UI + data)  
**Paralel:** ✅ TASK-2B ve 2D ile aynı anda

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Favorite pen presets strip'i oluştur (GoodNotes'taki gibi).

1. `lib/ynotes/toolbar/favorites_model.dart`:
   - FavoritePen class: {toolType, color, strokeSize, label}
   - FavoritesModel: max 5 favorite, CRUD, reorder
   - Persist: stows'a 'ynotes_favorite_pens' key ile JSON olarak kaydet
   - Default 3 favorite: Black Pen (size 2), Blue Highlighter (size 8), Red Pen (size 1.5)

2. `lib/ynotes/toolbar/favorites_strip.dart`:
   - Horizontal strip, her favorite = yuvarlak renk dot (24px)
   - Aktif favorite → border + scale animasyonu
   - Long-press → drag to reorder (ReorderableListView.horizontal veya custom)
   - Tap → activate that preset (tool + color + size)
   - Double-tap → edit popover (renk ve boyut değiştir)

3. Toolbar'a entegrasyon:
   - `ynotes_toolbar.dart`'a FavoritesStrip'i ekle (tool switcher'ın sağına)

4. Unit test: `test/ynotes/favorites_model_test.dart`
   - Add, remove, reorder, persist, max 5 limit
5. Widget test: `test/ynotes/favorites_strip_test.dart`

`docs/agent-log.md`'ye TASK-2C girişi ekle.
```

</details>

---

### TASK-2D · Color Palette Popover

**Model:** `gpt-5.2-codex` veya `claude-sonnet-4.5` (UI widget)  
**Paralel:** ✅ TASK-2B ve 2C ile aynı anda

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: GoodNotes tarzı renk paleti popover'ı oluştur.

1. `lib/ynotes/toolbar/color_palette_popover.dart`:
   - Toolbar'daki renk dot'una tap → popover açılır (OverlayEntry veya showModalBottomSheet)
   - 24-slot grid (lib/ynotes/design_system/ynotes_colors.dart'taki defaultPalette)
   - Her slot 32x32 yuvarlak + seçili olanın check mark'ı
   - Alt kısımda "Custom" butonu → HSV/RGB color picker
   - Son kullanılan 6 renk (recent colors strip)

2. `lib/ynotes/toolbar/palette_preset.dart`:
   - Named palette class: {name, colors: List<Color>}
   - 3 built-in palette: Classic (varsayılan), Pastel, High Contrast
   - Palette switcher tabs

3. Mevcut toolbar'daki color_bar.dart ve color_option.dart'ın işlevselliğini incele ama KOPYALAMA — sıfırdan yaz.

4. Recent colors persistence: stows'a 'ynotes_recent_colors' key

5. Widget test: `test/ynotes/color_palette_test.dart`
   - 24 rengin render olduğunu doğrula
   - Renk seçimi callback'ini doğrula
   - Recent colors güncellenmesini doğrula

`docs/agent-log.md`'ye TASK-2D girişi ekle.
```

</details>

---

### TASK-2E · Stroke Size Slider

**Model:** `claude-sonnet-4` (basit widget)  
**Paralel:** ✅ TASK-2B/2C/2D ile aynı anda

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: GoodNotes tarzı stroke size slider oluştur.

1. `lib/ynotes/toolbar/stroke_size_slider.dart`:
   - Continuous slider (0.5 → 20.0 range)
   - Slider'ın üstünde canlı preview: seçili kalınlıkta ve renkte bir çizgi
   - Slider thumb'ı aktif renkle dolu daire
   - Compact — popover içinde gösterilecek (tool'a double-tap → size popover)

2. `lib/ynotes/toolbar/tool_options_popover.dart`:
   - Tool'un üstüne double-tap → küçük popover açılır
   - İçinde: StrokeSizeSlider + opacity slider (highlighter için)
   - GoodNotes'taki gibi triangular pointer ile toolbar'a bağlı popover

3. Widget test: `test/ynotes/stroke_size_slider_test.dart`

`docs/agent-log.md`'ye TASK-2E girişi ekle.
```

</details>

---

# PHASE 3 — Apple Pencil Pro

> **Paralel:** PHASE 2 ile aynı anda başlayabilir (farklı dosyalar)

---

### TASK-3A · Squeeze Gesture Refinement

**Model:** `claude-sonnet-4.5` (Swift + Dart bridge)  
**Paralel:** ✅ TASK-3B/3C ile aynı anda

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Apple Pencil Pro squeeze gesture'ını GoodNotes davranışına getir.

MEVCUT:
- ios/Runner/DevilsPencilPlugin.swift — native squeeze handling
- lib/devils_book/stylus/squeeze_palette_controller.dart — mevcut Dart tarafı
- lib/devils_book/stylus/stylus_bridge.dart — EventChannel bridge

ADIMLAR:
1. DevilsPencilPlugin.swift'i oku — squeeze event'lerini incele.
2. Yeni davranışlar ekle:
   - Tek squeeze → son kullanılan tool'a geç (pen ↔ eraser toggle)
   - Çift squeeze → favorites strip'i göster
   - Long squeeze → renk paleti aç
3. squeeze_palette_controller.dart'ı güncelle — yeni gesture mapping
4. Settings'e ekle: "Pencil Squeeze Behavior" dropdown
   - Seçenekler: "Toggle Eraser", "Show Favorites", "Show Color Picker", "Custom"
5. Test: double-squeeze ve single-squeeze davranışlarını unit test et

`docs/agent-log.md`'ye TASK-3A girişi ekle.
```

</details>

---

### TASK-3B · Barrel Roll Hassasiyet Ayarı

**Model:** `claude-sonnet-4.5` (Swift + Dart)  
**Paralel:** ✅ TASK-3A/3C ile aynı anda

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Barrel roll hassasiyet slider'ı ekle.

MEVCUT PIPELINE:
- ios/Runner/DevilsPencilPlugin.swift → rollAngle (iOS 17.5+ guard)
- lib/devils_book/stylus/stylus_bridge.dart → parseEvent
- lib/devils_book/stylus/stylus_state.dart → latestBarrelRoll
- lib/data/tools/pen.dart → onDragUpdate(orientation)
- lib/components/canvas/_stroke.dart → _getCalligraphicPolygon

ADIMLAR:
1. `lib/data/prefs.dart`'a yeni stow ekle: barrelRollSensitivity (default 1.0, range 0.0–2.0)
2. Settings > Pencil sayfasına "Barrel Roll Sensitivity" slider ekle
3. pen.dart'ta orientation değerini sensitivity ile çarp
4. Toolbar'a küçük indicator ekle: barrel roll aktifken (orientation != 0) ikon göster
5. Test: sensitivity 0 → calligraphy effect yok, sensitivity 2 → exaggerated

`docs/agent-log.md`'ye TASK-3B girişi ekle.
```

</details>

---

### TASK-3C · Hover Ghost Nib İyileştirme

**Model:** `claude-sonnet-4` (basit widget)  
**Paralel:** ✅ TASK-3A/3B ile aynı anda

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Ghost nib'i aktif tool'a responsive yap.

MEVCUT:
- lib/devils_book/components/ghost_nib.dart — hover overlay widget
- editor.dart'ta integrate edilmiş

ADIMLAR:
1. ghost_nib.dart'ı oku ve anla.
2. Ghost nib'in rengi ve boyutu aktif tool'a göre değişsin:
   - Pen: aktif renk, aktif boyut, daire
   - Highlighter: aktif renk (yarı saydam), daha büyük daire
   - Eraser: gri daire, eraser boyutu
   - Hand: el ikonu (panning cursor)
3. Hover enter → 150ms fade-in animasyonu
4. Hover exit → 150ms fade-out animasyonu
5. AnimatedOpacity veya AnimatedContainer kullan

`docs/agent-log.md`'ye TASK-3C girişi ekle.
```

</details>

---

# PHASE 4 — Navigation Yeniden İnşa

> **Bağımlılık:** TASK-1A (tema) tamamlandıktan sonra

---

### TASK-4A · Ynotes Navigation Shell

**Model:** `claude-sonnet-4.5` (responsive UI)  
**Paralel:** ❌ Tek başına (home.dart değiştiriyor)

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: GoodNotes tarzı navigation shell oluştur — eski Saber navigation'ı değiştir.

MEVCUT:
- lib/pages/home/home.dart (106 satır) — mevcut navigation
- lib/components/navbar/ — eski responsive navbar

ADIMLAR:
1. `lib/ynotes/navigation/ynotes_shell.dart`:
   - iPad/wide (>768px): Sol sidebar rail (genişlik: 260px)
     * Üstte "Ynotes" logo/text
     * Library, Recent, Favorites, Search, Settings destination'ları
     * Her destination icon + label
   - iPhone/narrow (<768px): Bottom tab bar (56px)
     * Aynı destination'lar, sadece icon + label

2. `lib/ynotes/navigation/ynotes_destination.dart`:
   ```dart
   enum YnotesDestination { library, recent, favorites, search, settings }
   ```

3. `lib/pages/home/home.dart` değiştir:
   - Eski ResponsiveNavbar'ı kaldır
   - YnotesShell ile replace et
   - Mevcut browse.dart, recent_notes.dart, settings.dart content'lerini destination'lara bağla

4. LayoutBuilder veya MediaQuery ile responsive breakpoint

5. Widget test: `test/ynotes/navigation_shell_test.dart`
   - Narrow viewport → bottom bar render
   - Wide viewport → sidebar render

`docs/agent-log.md`'ye TASK-4A girişi ekle.
```

</details>

---

### TASK-4B · Library View (GoodNotes Grid)

**Model:** `claude-sonnet-4.5` (UI)  
**Paralel:** ❌ TASK-4A sonrası

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: GoodNotes tarzı library grid view oluştur.

1. `lib/ynotes/navigation/library_view.dart`:
   - Grid layout: notebook cover thumbnails
   - Her notebook kartı: cover rengi/resmi + başlık + son düzenleme tarihi
   - Grid/List toggle butonu
   - Sort seçenekleri: Date modified, Name, Date created
   - Folder navigation (breadcrumb bar)

2. Mevcut `lib/pages/home/browse.dart`'ı (344 satır) incele — mevcut file listing mantığını yeniden kullan ama UI'ı tamamen değiştir.

3. Long-press → context menu: Rename, Move, Duplicate, Delete, Share
4. Pull-to-refresh
5. Empty state: "Henüz not yok. + butonuyla yeni bir not oluştur"

`docs/agent-log.md`'ye TASK-4B girişi ekle.
```

</details>

---

### TASK-4C · Page Manager Redesign

**Model:** `claude-sonnet-4.5` (UI)  
**Paralel:** ✅ TASK-4B ile aynı anda (farklı dosya)

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Editor içindeki page manager'ı GoodNotes tarzına getir.

MEVCUT:
- lib/components/toolbar/editor_page_manager.dart — mevcut page strip

1. `lib/ynotes/editor/page_thumbnail_strip.dart`:
   - Sol kenar veya alt kenar: page thumbnail strip
   - Her page = mini canvas preview + page number
   - Drag-to-reorder
   - Tap → o sayfaya scroll
   - Long-press → context menu: Duplicate, Delete, Insert Before/After
   - "+" butonu → yeni sayfa ekle

2. editor.dart'a entegre et (mevcut EditorPageManager'ın yerine)

3. Animasyonlu page insertion/deletion

`docs/agent-log.md`'ye TASK-4C girişi ekle.
```

</details>

---

# PHASE 5 — Kaydetme / Persistence Fix

> **Paralel:** PHASE 2-4 ile aynı anda başlayabilir

---

### TASK-5A · Save Pipeline Fix

**Model:** `claude-opus-4.5` (karmaşık debugging)  
**Paralel:** ✅ Bağımsız

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Kaydetme sorunlarını tespit et ve düzelt.

ÖN KOŞUL: TASK-0C audit raporu (docs/save-audit.md) mevcut olmalı.

1. `lib/pages/editor/editor.dart`'ta save pipeline'ı trace et:
   - _saveToFile çağrı noktalarını bul
   - Debounce pattern'i — save'lerin drop olma riski var mı?
   - setState içinde save tetikleniyor mu? (anti-pattern)

2. `lib/data/file_manager/file_manager.dart`:
   - Concurrent write riski — aynı dosyaya aynı anda iki write olabilir mi?
   - Mutex veya queue ekle (varsa kontrol et)

3. Lifecycle save:
   - editor.dart'ta `AppLifecycleState.paused` listener var mı?
   - Yoksa ekle: `WidgetsBindingObserver` implement et, `didChangeAppLifecycleState`'te force-flush
   - `PopScope` ile geri giderken save flush

4. Regression test yaz: `test/save_pipeline_test.dart`
   - Note oluştur → stroke ekle → save tetikle → dosyayı oku → stroke mevcut

5. Save event logging: her save'de `Logger('SavePipeline').info('Saved $path in ${ms}ms')` ekle

`docs/agent-log.md`'ye TASK-5A girişi ekle.
```

</details>

---

### TASK-5B · Autosave Hardening

**Model:** `claude-sonnet-4.5` (lifecycle)  
**Paralel:** ❌ TASK-5A sonrası

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Autosave'i güçlendir.

1. editor.dart'a WidgetsBindingObserver ekle (yoksa):
   - `didChangeAppLifecycleState(AppLifecycleState.paused)` → _saveToFile() force
   - `didChangeAppLifecycleState(AppLifecycleState.inactive)` → _saveToFile() force

2. Periodic autosave timer:
   - Her 30 saniyede bir, değişiklik varsa kaydet
   - Timer'ı dispose'da cancel et

3. Save indicator:
   - Toolbar'da veya status bar'da save durumu göster: "Saving...", "Saved ✓", "Unsaved changes"
   - `lib/components/canvas/save_indicator.dart` zaten var — bunu YnotesToolbar'a entegre et

4. Error handling:
   - Save failure durumunda retry (3 kez)
   - Başarısızsa kullanıcıya snackbar göster: "Kaydetme başarısız. Tekrar deneyin."

`docs/agent-log.md`'ye TASK-5B girişi ekle.
```

</details>

---

# PHASE 6 — Google Drive Integration

> **Bağımlılık:** PHASE 5 (save pipeline temiz olmalı)

---

### TASK-6A · Google Drive Araştırma & Interface Design

**Model:** `gemini-2.5-pro` veya `claude-opus-4.5` (araştırma + API design)  
**Paralel:** ✅ Bağımsız

<details><summary>📋 Agent Prompt</summary>

```
GÖREV: Google Drive entegrasyonu için teknik plan yaz.

ARAŞTIR:
1. `google_sign_in` + `googleapis` (Drive v3 API) Flutter package'larını incele
2. Mevcut sync yapısını oku: `lib/data/nextcloud/saber_syncer.dart`
   - SaberSyncInterface abstract class yapısını anla
   - Bu interface'i Google Drive için implement edecek adapter tasarla

TASARLA:
3. `docs/google-drive-spec.md`:
   - Auth flow: Google Sign-In → OAuth2 → Drive scope
   - Folder structure: `My Drive/Ynotes/<notebook-folder>/<page>.sbn2`
   - Sync model: 
     * Upload: local change → detect → upload to Drive
     * Download: app foreground → check Drive for changes → download deltas
     * Conflict: last-write-wins (Phase 1), manual merge (Phase 2)
   - Offline support: local-first, sync when online
   - Token storage: flutter_secure_storage

4. Interface draft:
   ```dart
   class GoogleDriveSyncer extends AbstractSyncInterface<...> { ... }
   ```

`docs/agent-log.md`'ye TASK-6A girişi ekle.
```

</details>

---

### TASK-6B · Google Drive Auth Flow

**Model:** `claude-sonnet-4.5` (integration code)  
**Paralel:** ❌ TASK-6A sonrası

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Google Drive auth flow'unu implement et.

ÖN KOŞUL: TASK-6A spec'i hazır.

1. pubspec.yaml'a ekle: google_sign_in, googleapis, flutter_secure_storage (versiyonları kontrol et)
2. `lib/data/sync/google_drive/google_auth_service.dart`:
   - signIn(): Google Sign-In flow
   - signOut(): token temizleme
   - getAuthenticatedClient(): Drive API istemcisi döndür
   - isSignedIn: ValueNotifier<bool>

3. `lib/pages/user/login.dart`'a "Google ile giriş yap" butonu ekle
   - Google branding guidelines'a uygun buton
   - Mevcut Nextcloud login'in yanına

4. iOS config: ios/Runner/Info.plist'e Google Sign-In URL scheme ekle
5. Android config: google-services.json placeholder ve build.gradle ayarları

6. Token refresh: googleapis_auth auto-refresh

`docs/agent-log.md`'ye TASK-6B girişi ekle.
```

</details>

---

### TASK-6C · Google Drive Sync Engine

**Model:** `claude-opus-4.5` (karmaşık async logic)  
**Paralel:** ❌ TASK-6B sonrası

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Google Drive sync engine'i implement et.

1. `lib/data/sync/google_drive/google_drive_syncer.dart`:
   - SaberSyncInterface pattern'ini takip et (lib/data/nextcloud/saber_syncer.dart referans)
   - findLocalChanges(): modified_at karşılaştırması
   - findRemoteChanges(): Drive API list + compare
   - upload(): .sbn2 dosyasını Drive'a yükle
   - download(): Drive'dan dosyayı indir ve local'e yaz
   - Chunked upload for large files

2. `lib/data/sync/google_drive/drive_folder_manager.dart`:
   - Ynotes root folder oluştur/bul
   - Notebook sub-folder oluştur/bul
   - Folder ID cache

3. Sync status UI:
   - Home screen header'da sync progress bar
   - "Last synced: 2 min ago" text

4. Error handling: network failure → queue for retry

`docs/agent-log.md`'ye TASK-6C girişi ekle.
```

</details>

---

# PHASE 7 — Temizlik & CI

---

### TASK-7A · Widget Testleri

**Model:** `claude-sonnet-4` veya `gpt-5-mini` (test yazma)  
**Paralel:** ✅ Tüm PHASE 2-4 tamamlandıktan sonra, birden çok test aynı anda yazılabilir

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Tüm yeni Ynotes widget'ları için widget test yaz.

NOT: Mevcut testlerde 99 test pumpAndSettle timeout nedeniyle fail oluyor — bunlar pre-existing, senin sorunun değil.

TESTLER:
1. test/ynotes/theme_test.dart — 7 temanın hepsinin valid ThemeData ürettiğini doğrula
2. test/ynotes/toolbar_test.dart — YnotesToolbar render, tool switching, color dot
3. test/ynotes/tool_switcher_test.dart — 6 tool render, selection callback
4. test/ynotes/favorites_test.dart — FavoritesModel CRUD, FavoritesStrip render
5. test/ynotes/color_palette_test.dart — 24 renk render, selection callback
6. test/ynotes/navigation_test.dart — responsive shell breakpoints

HER TEST İÇİN:
- pumpAndSettle yerine pump() + belirli frame ilerleme kullan (animation timeout engelle)
- Mock'la: stows (tema seçimi için), FileManager (save test için)

Çalıştır: `flutter test test/ynotes/ --no-pub`

`docs/agent-log.md`'ye TASK-7A girişi ekle.
```

</details>

---

### TASK-7B · CI iOS Build Check

**Model:** `claude-sonnet-4` (CI/CD)  
**Paralel:** ✅ Bağımsız

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: CI'da iOS build check'i doğrula ve güncelle.

1. `.github/workflows/ios.yml` dosyasını oku — mevcut iOS build step'lerini incele
2. Step'lerin güncel olduğunu doğrula:
   - flutter build ios --no-codesign
   - flutter analyze --no-pub (build öncesi)
3. `.github/workflows/tests.yml` oku — test CI'ı
4. Yeni bir workflow step ekle veya mevcut olanı güncelle:
   - dart format lib test --output none --set-exit-if-changed
   - flutter test test/ynotes/ --no-pub (sadece yeni testler)
5. codemagic.yaml'ı da kontrol et — Ynotes rebrand sonrası display name vs. doğru mu?

`docs/agent-log.md`'ye TASK-7B girişi ekle.
```

</details>

---

### TASK-7C · Saber Artıkları Son Temizlik

**Model:** `claude-opus-4.5` (kapsamlı silme)  
**Paralel:** ❌ TÜM diğer tasklar tamamlandıktan sonra

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

GÖREV: Saber'ın artık kullanılmayan tüm dosyalarını/kodlarını sil.

ÖN KOŞUL: Tüm PHASE 1-6 taskları tamamlanmış olmalı.

ÖNCELİKLE `docs/agent-log.md`'yi oku — her ajanın ne yaptığını gör.

SİLİNECEK (eğer artık hiçbir yerde import edilmiyorsa):
1. `lib/components/theming/saber_theme.dart` — YnotesTheme ile replace edildi
2. `lib/components/theming/yaru_builder.dart` — Yaru bağımlılığı kaldırıldı
3. `lib/components/toolbar/toolbar.dart` — YnotesToolbar ile replace edildi
4. `lib/components/toolbar/color_bar.dart` — ColorPalettePopover ile replace edildi
5. `lib/components/toolbar/color_option.dart`
6. `lib/components/toolbar/size_picker.dart`
7. `lib/components/toolbar/toolbar_button.dart`
8. `lib/components/toolbar/selection_bar.dart` (eğer lasso tool kendi UI'ını getirdiyse)

HER SİLMEDEN ÖNCE:
- `grep -rl "import.*dosya_adı" lib/` çalıştır
- Hiçbir yerde import edilmiyorsa sil
- Bir yerde varsa, o import'u Ynotes karşılığıyla değiştir

SON:
- `flutter analyze --no-pub` çalıştır — 0 hata
- `dart format lib test --output none --set-exit-if-changed` — 0 fark
- pubspec.yaml'dan artık kullanılmayan dependency'leri kaldır (yaru?)

`docs/agent-log.md`'ye TASK-7C girişi ekle.
```

</details>

---

# PHASE 8 — Final Entegrasyon

---

### TASK-8A · Entegrasyon Ajanı — Build Hazırlama

**Model:** `claude-opus-4.5` (büyük context, çatışma çözme)  
**Paralel:** ❌ HER ŞEY bittikten sonra, TEK AJAN

<details><summary>📋 Agent Prompt</summary>

```
Sen DevilsBook reposunda çalışıyorsun: /home/runner/work/DevilsBook/DevilsBook

SEN ENTEGRASYoN AJANISIN. Diğer ajanlar görevlerini tamamladı. Senin görevin:
her şeyi bir araya getirmek ve build'i yeşil yapmak.

1. ÖNCELİKLE `docs/agent-log.md`'yi oku — tam olarak ne yapıldığını, hangi dosyaların değiştiğini gör.

2. ÇATIŞMA KONTROLÜ:
   - `git status` — merge conflict var mı?
   - Aynı dosyayı birden fazla ajan değiştirmiş mi? (özellikle editor.dart, dynamic_material_app.dart, settings.dart)
   - Conflict varsa çöz.

3. IMPORT KONTROLÜ:
   - `flutter analyze --no-pub` çalıştır
   - Her hatayı tek tek düzelt (unused import, missing import, type error)
   - `dart format lib scripts test --output none --set-exit-if-changed` çalıştır

4. BUILD TEST:
   - `flutter build ios --no-codesign` (veya mümkünse analyze yeterli)
   - Başarısızsa hata log'unu oku ve düzelt

5. RUNTIME CHECK:
   - App açılıyor mu?
   - Tema seçimi çalışıyor mu?
   - Yeni toolbar render oluyor mu?
   - Note oluştur → çiz → kaydet → kapat → aç → çizim mevcut mi?

6. SON RAPOR:
   `docs/agent-log.md`'ye TASK-8A girişi:
   - Build status: ✅ / ❌
   - Çözülen çatışmalar
   - Kalan bilinen sorunlar
   - Versiyon: pubspec.yaml version + build number

7. Commit: "feat: Ynotes v2 — complete UI/UX rebuild 🎉✨"
```

</details>

---

## Bağımlılık Grafiği

```
PHASE 0 (Paralel):
  TASK-0A ─────┐
  TASK-0B ─────┼──► PHASE 1, PHASE 2
  TASK-0C ─────┘

PHASE 1 (Sıralı + Paralel):
  TASK-1A ──► TASK-1B ──► TASK-1D
  TASK-1C (paralel, bağımsız dosyalar)

PHASE 2 (TASK-1A sonrası, kendi içinde paralel):
  TASK-2A ──► TASK-2B ┐
              TASK-2C ├──► (hepsi toolbar'a eklenir)
              TASK-2D │
              TASK-2E ┘

PHASE 3 (Paralel, bağımsız):
  TASK-3A, TASK-3B, TASK-3C (hepsi paralel)

PHASE 4 (TASK-1A sonrası):
  TASK-4A ──► TASK-4B
  TASK-4C (paralel)

PHASE 5 (Bağımsız):
  TASK-5A ──► TASK-5B

PHASE 6 (TASK-5A sonrası):
  TASK-6A ──► TASK-6B ──► TASK-6C

PHASE 7 (Tüm PHASE 2-6 sonrası):
  TASK-7A, TASK-7B (paralel)
  TASK-7C (TASK-7A/7B sonrası)

PHASE 8 (HER ŞEY sonrası):
  TASK-8A — Final entegrasyon
```

---

## Task × Model Özeti

| Task | Model | Süre Tahmini | Paralel? |
|------|-------|-------------|----------|
| 0A Saber Audit | claude-sonnet-4 | 15 dk | ✅ |
| 0B GoodNotes Research | gemini-2.5-pro | 20 dk | ✅ |
| 0C Save Audit | claude-sonnet-4.5 | 15 dk | ✅ |
| 1A SaberTheme Kaldır | claude-opus-4.5 | 45 dk | ❌ |
| 1B Tema Picker UI | claude-sonnet-4.5 | 30 dk | ❌ |
| 1C Rebrand Tamamla | claude-haiku-4.5 | 15 dk | ✅ |
| 1D Tema Migrasyon | claude-sonnet-4.5 | 30 dk | ❌ |
| 2A Toolbar Replace | claude-opus-4.5 | 45 dk | ❌ |
| 2B Tool Switcher | claude-sonnet-4.5 | 25 dk | ✅ |
| 2C Favorites Strip | claude-sonnet-4.5 | 25 dk | ✅ |
| 2D Color Palette | gpt-5.2-codex | 25 dk | ✅ |
| 2E Stroke Slider | claude-sonnet-4 | 15 dk | ✅ |
| 3A Squeeze | claude-sonnet-4.5 | 30 dk | ✅ |
| 3B Barrel Roll | claude-sonnet-4.5 | 20 dk | ✅ |
| 3C Ghost Nib | claude-sonnet-4 | 15 dk | ✅ |
| 4A Navigation Shell | claude-sonnet-4.5 | 35 dk | ❌ |
| 4B Library View | claude-sonnet-4.5 | 30 dk | ❌ |
| 4C Page Manager | claude-sonnet-4.5 | 25 dk | ✅ |
| 5A Save Fix | claude-opus-4.5 | 40 dk | ✅ |
| 5B Autosave | claude-sonnet-4.5 | 20 dk | ❌ |
| 6A GDrive Research | gemini-2.5-pro | 20 dk | ✅ |
| 6B GDrive Auth | claude-sonnet-4.5 | 30 dk | ❌ |
| 6C GDrive Sync | claude-opus-4.5 | 45 dk | ❌ |
| 7A Widget Tests | claude-sonnet-4 | 30 dk | ✅ |
| 7B CI Check | claude-sonnet-4 | 15 dk | ✅ |
| 7C Saber Cleanup | claude-opus-4.5 | 30 dk | ❌ |
| 8A Entegrasyon | claude-opus-4.5 | 60 dk | ❌ |

**Toplam: 27 task** — Optimal paralel çalıştırma ile ~6-8 saat  
**Maks paralel ajan sayısı:** Aynı anda 5 ajan (Phase 0: 3 + Phase 3: 3 + Phase 2: 4)

---

*Son güncelleme: 2026-04-01 — Saber yıkım + Ynotes rebuild planı*
