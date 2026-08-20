import 'package:flutter/material.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// One feature item displayed on the Features screen.
class _AppFeature {
  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;

  const _AppFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.highlights,
  });
}

/// A category grouping related features.
class _FeatureCategory {
  final String name;
  final String subtitle;
  final IconData icon;
  final List<_AppFeature> features;

  const _FeatureCategory({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.features,
  });
}

/// Lists all features of SreerajP PDF App, grouped by category with visual cards.
class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  List<_FeatureCategory> _buildCategories(AppLocalizations l10n) {
    return [
      _FeatureCategory(
        name: l10n.featuresCategoryViewing,
        subtitle: l10n.featuresCategoryViewingSubtitle,
        icon: Icons.auto_stories_outlined,
        features: const [
          _AppFeature(
            title: 'High-Performance Rendering',
            description:
                'Fast, crisp PDF page rendering powered by native pdfium engine with zero network overhead.',
            icon: Icons.speed_outlined,
            highlights: ['pdfium Engine', 'Crisp Scaling', 'Offline Fast'],
          ),
          _AppFeature(
            title: 'Flexible Viewing & Fit Modes',
            description:
                'Switch between Single Page, Continuous Vertical Scrolling, and Two-Page Book view with Fit to Width or Fit to Page options.',
            icon: Icons.view_carousel_outlined,
            highlights: ['Single Page', 'Continuous Scroll', 'Book View', 'Fit Modes'],
          ),
          _AppFeature(
            title: 'Foldable & Dual-Screen Support',
            description:
                'Adaptive dual-page layout on foldable devices and tablets with display hinge gap spacing.',
            icon: Icons.devices_outlined,
            highlights: ['Foldable Aware', 'Hinge Gap', 'Tablet Optimized'],
          ),
          _AppFeature(
            title: 'Reading Velocity & Time Estimates',
            description:
                'Tracks reading speed in real time to calculate remaining reading time for chapters and the entire document.',
            icon: Icons.timer_outlined,
            highlights: ['WPM Tracking', 'Chapter Estimates', 'Total Time'],
          ),
          _AppFeature(
            title: 'Thumbnail Grid & Direct Jump',
            description:
                'Quickly preview all document pages in an interactive grid or jump directly to any page number.',
            icon: Icons.grid_view_outlined,
            highlights: ['Thumbnail Grid', 'Page Slider', 'Quick Jump'],
          ),
          _AppFeature(
            title: 'Document Outline & Bookmarks',
            description:
                'Browse document table of contents hierarchies with one-tap section jumping and page bookmarking.',
            icon: Icons.format_list_bulleted_outlined,
            highlights: ['TOC Hierarchy', '1-Tap Jump', 'Page Bookmarks'],
          ),
          _AppFeature(
            title: 'Content Fingerprinting & Recents',
            description:
                'SHA-256 fingerprinting preserves reading positions, zoom, and annotations even if files are renamed or moved.',
            icon: Icons.history_outlined,
            highlights: ['SHA-256 Fingerprint', 'Last Read State', 'Recent Files'],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.featuresCategorySearch,
        subtitle: l10n.featuresCategorySearchSubtitle,
        icon: Icons.search_outlined,
        features: const [
          _AppFeature(
            title: 'On-Page Full-Text Search',
            description:
                'Instant keyword search with match counting, bright highlight overlays, and grapheme-aligned navigation.',
            icon: Icons.find_in_page_outlined,
            highlights: ['Instant Search', 'Match Counter', 'Grapheme Alignment'],
          ),
          _AppFeature(
            title: 'Sandhi-Aware Indic Search',
            description:
                'Rule-based Sandhi compound splitting and joining supporting Malayalam, Sanskrit, and Devanagari rules.',
            icon: Icons.merge_type_outlined,
            highlights: ['Sandhi Splitting', 'Compound Joining', 'Sanskrit & Malayalam'],
          ),
          _AppFeature(
            title: 'Indic Phonetic Sound-Alike Engine',
            description:
                'Unifies Anusvara nasal conjuncts, chillu and virama forms, NTA ligatures, and Samvruthokaram endings.',
            icon: Icons.hearing_outlined,
            highlights: ['Sound-Alike Matching', 'Chillu Unification', 'NFC Normalization'],
          ),
          _AppFeature(
            title: 'Malayalam Input Helper & Virtual Keypad',
            description:
                'Live Manglish transliteration suggestions and a 3-tab virtual keypad for vowels, consonants, and signs.',
            icon: Icons.keyboard_outlined,
            highlights: ['Manglish Suggestions', 'Virtual Keypad', 'Zero Extra Setup'],
          ),
          _AppFeature(
            title: 'Offline Text-to-Speech (TTS)',
            description:
                'Read PDF text aloud in English and Malayalam with speech rate, pitch, sentence pause sliders, and media notifications.',
            icon: Icons.record_voice_over_outlined,
            highlights: ['English & Malayalam', 'Speed & Pitch Controls', 'Background Playback'],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.featuresCategoryAnnotations,
        subtitle: l10n.featuresCategoryAnnotationsSubtitle,
        icon: Icons.edit_note_outlined,
        features: const [
          _AppFeature(
            title: 'Text Markups & Color Presets',
            description:
                'Highlight, underline, and strikethrough text with 7 vibrant color presets and customizable opacity.',
            icon: Icons.brush_outlined,
            highlights: ['Highlight', 'Underline', 'Strikethrough', '7 Colors'],
          ),
          _AppFeature(
            title: 'Freehand Ink Drawing & Sticky Notes',
            description:
                'Draw smooth sketches with the pen tool and anchor movable sticky notes anywhere on pages.',
            icon: Icons.note_alt_outlined,
            highlights: ['Freehand Ink', 'Anchored Notes', 'Eraser Tool'],
          ),
          _AppFeature(
            title: 'Flatten & Export Annotations',
            description:
                'Export annotations permanently into standard PDF annotation objects in a new copy of your document.',
            icon: Icons.picture_as_pdf_outlined,
            highlights: ['Copy-on-Write', 'Standard PDF Annotations', 'Non-Destructive'],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.featuresCategoryPageOps,
        subtitle: l10n.featuresCategoryPageOpsSubtitle,
        icon: Icons.dashboard_customize_outlined,
        features: const [
          _AppFeature(
            title: 'Visual Organize Pages Grid',
            description:
                'Drag-and-drop page reordering, 90-degree rotations, and page deletion with multi-selection support.',
            icon: Icons.grid_goldenratio_outlined,
            highlights: ['Drag & Drop', 'Rotate & Delete', 'Multi-Select Mode'],
          ),
          _AppFeature(
            title: 'Custom Text Watermarks',
            description:
                'Add customizable diagonal or horizontal text watermarks with opacity, color, and repeating grid tiling.',
            icon: Icons.branding_watermark_outlined,
            highlights: ['Custom Text', 'Opacity & Angle', 'Grid Tiling'],
          ),
          _AppFeature(
            title: 'N-Up Multi-Page Imposition',
            description:
                'Place 2, 4, 6, or 9 pages per sheet on A4 or Letter paper with customizable borders and margins.',
            icon: Icons.space_dashboard_outlined,
            highlights: ['2/4/6/9 Up', 'Page Borders', 'Sheet Orientation'],
          ),
          _AppFeature(
            title: 'Printable Booklet Creator',
            description:
                'Imposes pages into foldable saddle-stitch booklet order with automatic 4-page padding.',
            icon: Icons.menu_book_outlined,
            highlights: ['Saddle-Stitch', 'Fold Guidelines', 'Auto-Padding'],
          ),
          _AppFeature(
            title: 'Merge, Split & Compress',
            description:
                'Combine multiple PDFs, split pages into individual files, and compress PDFs to reduce file size.',
            icon: Icons.call_split_outlined,
            highlights: ['Merge Multiple', 'Page Splitter', 'Smart Compression'],
          ),
          _AppFeature(
            title: 'PDF Encryption & Decryption',
            description:
                'Protect documents with AES-256 passwords or unlock encrypted files into unencrypted copies.',
            icon: Icons.lock_outline,
            highlights: ['AES-256 Protection', 'Owner Passwords', 'Unlock Decryption'],
          ),
          _AppFeature(
            title: 'Batch Operations Engine',
            description:
                'Execute watermarking, compression, encryption, decryption, and extraction across multiple files at once.',
            icon: Icons.dynamic_feed_outlined,
            highlights: ['Multi-File Batch', 'Step Progress', 'SAF Output'],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.featuresCategoryExtraction,
        subtitle: l10n.featuresCategoryExtractionSubtitle,
        icon: Icons.file_download_outlined,
        features: const [
          _AppFeature(
            title: 'Text & Image Extraction',
            description:
                'Extract plain text and save embedded PNG/JPEG images from any page range without quality loss.',
            icon: Icons.text_snippet_outlined,
            highlights: ['Plain Text Export', 'Embedded Images', 'Page Ranges'],
          ),
          _AppFeature(
            title: 'Interactive Form Fields Inspector',
            description:
                'Detect and inspect interactive form field values, checkboxes, radio groups, and export as JSON.',
            icon: Icons.assignment_outlined,
            highlights: ['Form Parser', 'JSON Export', 'Field Inspector'],
          ),
          _AppFeature(
            title: 'Render Pages to High-DPI Images',
            description:
                'Export PDF pages as crisp PNG or JPEG images with customizable DPI resolution up to 300 DPI.',
            icon: Icons.image_outlined,
            highlights: ['High-DPI PNG/JPEG', '100-300 DPI', 'Batch Rendering'],
          ),
          _AppFeature(
            title: 'Document Metadata Inspector',
            description:
                'View detailed document metadata including title, author, producer, creation date, and encryption state.',
            icon: Icons.info_outline,
            highlights: ['PDF Metadata', 'Creation Dates', 'Security State'],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.featuresCategoryPrinter,
        subtitle: l10n.featuresCategoryPrinterSubtitle,
        icon: Icons.print_outlined,
        features: const [
          _AppFeature(
            title: 'Android System Virtual Printer',
            description:
                'Receives print jobs from any Android app to generate crisp PDFs with full Indic font shaping.',
            icon: Icons.print_outlined,
            highlights: ['System Spooler', 'Font Embedding', 'Indic Shaping'],
          ),
          _AppFeature(
            title: 'Web Content Cleaner (Reader Mode)',
            description:
                'Strips ads, tracking, banners, sidebars, and scripts from shared web pages before converting to PDF.',
            icon: Icons.cleaning_services_outlined,
            highlights: ['Ad & Clutter Stripping', 'Reader View', 'Clean PDFs'],
          ),
          _AppFeature(
            title: 'Images & Text to PDF Converter',
            description:
                'Convert up to 100 gallery images or shared plain text into formatted multi-page PDF documents.',
            icon: Icons.collections_outlined,
            highlights: ['Up to 100 Images', 'Plain Text Importer', 'Custom Margins'],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.featuresCategorySignatures,
        subtitle: l10n.featuresCategorySignaturesSubtitle,
        icon: Icons.verified_user_outlined,
        features: const [
          _AppFeature(
            title: 'Cryptographic Signature Verification',
            description:
                'Validates document integrity, byte coverage, and certificate validity offline using Bouncy Castle.',
            icon: Icons.security_outlined,
            highlights: ['Byte Integrity', 'Byte Coverage Scope', 'Offline Validation'],
          ),
          _AppFeature(
            title: 'Custom Trust Store & EU Lists',
            description:
                'Bundled EU Trusted Lists root certificates with support for importing custom CA/root certificates.',
            icon: Icons.vpn_key_outlined,
            highlights: ['EU Trusted Lists', 'Import X.509 PEM', 'PEM Export'],
          ),
          _AppFeature(
            title: 'Visual Signature Stamp Overlay',
            description:
                'Interactive signature stamp badges on PDF pages with one-tap access to certificate chain details.',
            icon: Icons.badge_outlined,
            highlights: ['On-Page Badges', 'Certificate Chains', 'Signer Details'],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.featuresCategoryThemes,
        subtitle: l10n.featuresCategoryThemesSubtitle,
        icon: Icons.palette_outlined,
        features: const [
          _AppFeature(
            title: 'Light, Dark & OLED Pitch-Black',
            description:
                'Support for Light, Dark, Sepia, and OLED Pitch-Black (#000000) for maximum battery savings.',
            icon: Icons.brightness_6_outlined,
            highlights: ['OLED Pitch-Black', 'Sepia Reading', 'System Adaptive'],
          ),
          _AppFeature(
            title: 'Custom Typography & Scale',
            description:
                'Switch between Manjari, Anek Malayalam, Noto Sans Malayalam, and System font with text scaling.',
            icon: Icons.text_fields_outlined,
            highlights: ['Malayalam Fonts', 'Font Scaling', 'Dynamic Switch'],
          ),
          _AppFeature(
            title: 'Interactive Accent Color Picker',
            description:
                'Custom color presets and full HSV color wheel with real-time app theme preview.',
            icon: Icons.color_lens_outlined,
            highlights: ['HSV Color Wheel', '8 Presets', 'Live Preview'],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.featuresCategoryGuides,
        subtitle: l10n.featuresCategoryGuidesSubtitle,
        icon: Icons.help_outline,
        features: const [
          _AppFeature(
            title: '6 Dedicated Step-by-Step Guides',
            description:
                'In-depth guides covering PDF printer setup, Unicode printing, TTS voice configuration, page operations, signatures, and privacy.',
            icon: Icons.menu_book_outlined,
            highlights: ['100% Offline Guides', 'Troubleshooting', 'Step-by-Step'],
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final categories = _buildCategories(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featuresTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
          children: [
            _buildHeaderCard(context, l10n, colors),
            const SizedBox(height: 20),
            for (final category in categories) ...[
              _buildCategoryHeader(context, category, colors),
              const SizedBox(height: 10),
              _buildCategoryCard(context, category, colors),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    AppLocalizations l10n,
    AppColors? colors,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final gradient = colors?.brandGradient ??
        LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    final gradientStart = colors?.gradientStart ?? primary;
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.12),
              secondary.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: gradientStart.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.stars_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.featuresHeaderTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.featuresHeaderSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    _FeatureCategory category,
    AppColors? colors,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                category.icon,
                size: 18,
                color: primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.name.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            category.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    _FeatureCategory category,
    AppColors? colors,
  ) {
    final theme = Theme.of(context);
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < category.features.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: muted.withValues(alpha: 0.18),
              ),
            _buildFeatureTile(context, category.features[i], colors),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context,
    _AppFeature feature,
    AppColors? colors,
  ) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(feature.icon, color: accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    color: muted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                if (feature.highlights.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: feature.highlights.map((h) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          h,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accent,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
