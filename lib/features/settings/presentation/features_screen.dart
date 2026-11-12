import 'package:material_ui/material_ui.dart';
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

/// Lists all features of Folio, grouped by category with visual cards.
class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  List<_FeatureCategory> _buildCategories(AppLocalizations l10n) {
    return [
      _FeatureCategory(
        name: l10n.descFeaturesCategoryViewing,
        subtitle: l10n.descFeaturesCategoryViewingSubtitle,
        icon: Icons.auto_stories_outlined,
        features: [
          _AppFeature(
            title: l10n.helpFeatureRenderingTitle,
            description: l10n.helpFeatureRenderingBody,
            icon: Icons.speed_outlined,
            highlights: [
              l10n.helpFeatureRenderingTag1,
              l10n.helpFeatureRenderingTag2,
              l10n.helpFeatureRenderingTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureViewModesTitle,
            description: l10n.helpFeatureViewModesBody,
            icon: Icons.view_carousel_outlined,
            highlights: [
              l10n.helpFeatureViewModesTag1,
              l10n.helpFeatureViewModesTag2,
              l10n.helpFeatureViewModesTag3,
              l10n.helpFeatureViewModesTag4,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureFoldableTitle,
            description: l10n.helpFeatureFoldableBody,
            icon: Icons.devices_outlined,
            highlights: [
              l10n.helpFeatureFoldableTag1,
              l10n.helpFeatureFoldableTag2,
              l10n.helpFeatureFoldableTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureVelocityTitle,
            description: l10n.helpFeatureVelocityBody,
            icon: Icons.timer_outlined,
            highlights: [
              l10n.helpFeatureVelocityTag1,
              l10n.helpFeatureVelocityTag2,
              l10n.helpFeatureVelocityTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureThumbnailsTitle,
            description: l10n.helpFeatureThumbnailsBody,
            icon: Icons.grid_view_outlined,
            highlights: [
              l10n.helpFeatureThumbnailsTag1,
              l10n.helpFeatureThumbnailsTag2,
              l10n.helpFeatureThumbnailsTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureOutlineTitle,
            description: l10n.helpFeatureOutlineBody,
            icon: Icons.format_list_bulleted_outlined,
            highlights: [
              l10n.helpFeatureOutlineTag1,
              l10n.helpFeatureOutlineTag2,
              l10n.helpFeatureOutlineTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureFingerprintTitle,
            description: l10n.helpFeatureFingerprintBody,
            icon: Icons.history_outlined,
            highlights: [
              l10n.helpFeatureFingerprintTag1,
              l10n.helpFeatureFingerprintTag2,
              l10n.helpFeatureFingerprintTag3,
            ],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.descFeaturesCategorySearch,
        subtitle: l10n.descFeaturesCategorySearchSubtitle,
        icon: Icons.search_outlined,
        features: [
          _AppFeature(
            title: l10n.helpFeatureSearchTitle,
            description: l10n.helpFeatureSearchBody,
            icon: Icons.find_in_page_outlined,
            highlights: [
              l10n.helpFeatureSearchTag1,
              l10n.helpFeatureSearchTag2,
              l10n.helpFeatureSearchTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureSandhiTitle,
            description: l10n.helpFeatureSandhiBody,
            icon: Icons.merge_type_outlined,
            highlights: [
              l10n.helpFeatureSandhiTag1,
              l10n.helpFeatureSandhiTag2,
              l10n.helpFeatureSandhiTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeaturePhoneticTitle,
            description: l10n.helpFeaturePhoneticBody,
            icon: Icons.hearing_outlined,
            highlights: [
              l10n.helpFeaturePhoneticTag1,
              l10n.helpFeaturePhoneticTag2,
              l10n.helpFeaturePhoneticTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureMalayalamInputTitle,
            description: l10n.helpFeatureMalayalamInputBody,
            icon: Icons.keyboard_outlined,
            highlights: [
              l10n.helpFeatureMalayalamInputTag1,
              l10n.helpFeatureMalayalamInputTag2,
              l10n.helpFeatureMalayalamInputTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureTtsTitle,
            description: l10n.helpFeatureTtsBody,
            icon: Icons.record_voice_over_outlined,
            highlights: [
              l10n.helpFeatureTtsTag1,
              l10n.helpFeatureTtsTag2,
              l10n.helpFeatureTtsTag3,
            ],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.descFeaturesCategoryAnnotations,
        subtitle: l10n.descFeaturesCategoryAnnotationsSubtitle,
        icon: Icons.edit_note_outlined,
        features: [
          _AppFeature(
            title: l10n.helpFeatureMarkupsTitle,
            description: l10n.helpFeatureMarkupsBody,
            icon: Icons.brush_outlined,
            highlights: [
              l10n.helpFeatureMarkupsTag1,
              l10n.helpFeatureMarkupsTag2,
              l10n.helpFeatureMarkupsTag3,
              l10n.helpFeatureMarkupsTag4,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureInkTitle,
            description: l10n.helpFeatureInkBody,
            icon: Icons.note_alt_outlined,
            highlights: [
              l10n.helpFeatureInkTag1,
              l10n.helpFeatureInkTag2,
              l10n.helpFeatureInkTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureFlattenTitle,
            description: l10n.helpFeatureFlattenBody,
            icon: Icons.picture_as_pdf_outlined,
            highlights: [
              l10n.helpFeatureFlattenTag1,
              l10n.helpFeatureFlattenTag2,
              l10n.helpFeatureFlattenTag3,
            ],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.descFeaturesCategoryPageOps,
        subtitle: l10n.descFeaturesCategoryPageOpsSubtitle,
        icon: Icons.dashboard_customize_outlined,
        features: [
          _AppFeature(
            title: l10n.helpFeatureOrganizeTitle,
            description: l10n.helpFeatureOrganizeBody,
            icon: Icons.grid_goldenratio_outlined,
            highlights: [
              l10n.helpFeatureOrganizeTag1,
              l10n.helpFeatureOrganizeTag2,
              l10n.helpFeatureOrganizeTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureWatermarkTitle,
            description: l10n.helpFeatureWatermarkBody,
            icon: Icons.branding_watermark_outlined,
            highlights: [
              l10n.helpFeatureWatermarkTag1,
              l10n.helpFeatureWatermarkTag2,
              l10n.helpFeatureWatermarkTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureNUpTitle,
            description: l10n.helpFeatureNUpBody,
            icon: Icons.space_dashboard_outlined,
            highlights: [
              l10n.helpFeatureNUpTag1,
              l10n.helpFeatureNUpTag2,
              l10n.helpFeatureNUpTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureBookletTitle,
            description: l10n.helpFeatureBookletBody,
            icon: Icons.menu_book_outlined,
            highlights: [
              l10n.helpFeatureBookletTag1,
              l10n.helpFeatureBookletTag2,
              l10n.helpFeatureBookletTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureMergeSplitTitle,
            description: l10n.helpFeatureMergeSplitBody,
            icon: Icons.call_split_outlined,
            highlights: [
              l10n.helpFeatureMergeSplitTag1,
              l10n.helpFeatureMergeSplitTag2,
              l10n.helpFeatureMergeSplitTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureEncryptionTitle,
            description: l10n.helpFeatureEncryptionBody,
            icon: Icons.lock_outline,
            highlights: [
              l10n.helpFeatureEncryptionTag1,
              l10n.helpFeatureEncryptionTag2,
              l10n.helpFeatureEncryptionTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureBatchTitle,
            description: l10n.helpFeatureBatchBody,
            icon: Icons.dynamic_feed_outlined,
            highlights: [
              l10n.helpFeatureBatchTag1,
              l10n.helpFeatureBatchTag2,
              l10n.helpFeatureBatchTag3,
            ],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.descFeaturesCategoryExtraction,
        subtitle: l10n.descFeaturesCategoryExtractionSubtitle,
        icon: Icons.file_download_outlined,
        features: [
          _AppFeature(
            title: l10n.helpFeatureExtractionTitle,
            description: l10n.helpFeatureExtractionBody,
            icon: Icons.text_snippet_outlined,
            highlights: [
              l10n.helpFeatureExtractionTag1,
              l10n.helpFeatureExtractionTag2,
              l10n.helpFeatureExtractionTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureFormFieldsTitle,
            description: l10n.helpFeatureFormFieldsBody,
            icon: Icons.assignment_outlined,
            highlights: [
              l10n.helpFeatureFormFieldsTag1,
              l10n.helpFeatureFormFieldsTag2,
              l10n.helpFeatureFormFieldsTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureRenderImagesTitle,
            description: l10n.helpFeatureRenderImagesBody,
            icon: Icons.image_outlined,
            highlights: [
              l10n.helpFeatureRenderImagesTag1,
              l10n.helpFeatureRenderImagesTag2,
              l10n.helpFeatureRenderImagesTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureMetadataTitle,
            description: l10n.helpFeatureMetadataBody,
            icon: Icons.info_outline,
            highlights: [
              l10n.helpFeatureMetadataTag1,
              l10n.helpFeatureMetadataTag2,
              l10n.helpFeatureMetadataTag3,
            ],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.descFeaturesCategoryPrinter,
        subtitle: l10n.descFeaturesCategoryPrinterSubtitle,
        icon: Icons.print_outlined,
        features: [
          _AppFeature(
            title: l10n.helpFeatureVirtualPrinterTitle,
            description: l10n.helpFeatureVirtualPrinterBody,
            icon: Icons.print_outlined,
            highlights: [
              l10n.helpFeatureVirtualPrinterTag1,
              l10n.helpFeatureVirtualPrinterTag2,
              l10n.helpFeatureVirtualPrinterTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureWebCleanerTitle,
            description: l10n.helpFeatureWebCleanerBody,
            icon: Icons.cleaning_services_outlined,
            highlights: [
              l10n.helpFeatureWebCleanerTag1,
              l10n.helpFeatureWebCleanerTag2,
              l10n.helpFeatureWebCleanerTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureImagesToPdfTitle,
            description: l10n.helpFeatureImagesToPdfBody,
            icon: Icons.collections_outlined,
            highlights: [
              l10n.helpFeatureImagesToPdfTag1,
              l10n.helpFeatureImagesToPdfTag2,
              l10n.helpFeatureImagesToPdfTag3,
            ],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.descFeaturesCategorySignatures,
        subtitle: l10n.descFeaturesCategorySignaturesSubtitle,
        icon: Icons.verified_user_outlined,
        features: [
          _AppFeature(
            title: l10n.helpFeatureSignatureCheckTitle,
            description: l10n.helpFeatureSignatureCheckBody,
            icon: Icons.security_outlined,
            highlights: [
              l10n.helpFeatureSignatureCheckTag1,
              l10n.helpFeatureSignatureCheckTag2,
              l10n.helpFeatureSignatureCheckTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureTrustStoreTitle,
            description: l10n.helpFeatureTrustStoreBody,
            icon: Icons.vpn_key_outlined,
            highlights: [
              l10n.helpFeatureTrustStoreTag1,
              l10n.helpFeatureTrustStoreTag2,
              l10n.helpFeatureTrustStoreTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureSignatureStampsTitle,
            description: l10n.helpFeatureSignatureStampsBody,
            icon: Icons.badge_outlined,
            highlights: [
              l10n.helpFeatureSignatureStampsTag1,
              l10n.helpFeatureSignatureStampsTag2,
              l10n.helpFeatureSignatureStampsTag3,
            ],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.descFeaturesCategoryThemes,
        subtitle: l10n.descFeaturesCategoryThemesSubtitle,
        icon: Icons.palette_outlined,
        features: [
          _AppFeature(
            title: l10n.helpFeatureThemesTitle,
            description: l10n.helpFeatureThemesBody,
            icon: Icons.brightness_6_outlined,
            highlights: [
              l10n.helpFeatureThemesTag1,
              l10n.helpFeatureThemesTag2,
              l10n.helpFeatureThemesTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureTypographyTitle,
            description: l10n.helpFeatureTypographyBody,
            icon: Icons.text_fields_outlined,
            highlights: [
              l10n.helpFeatureTypographyTag1,
              l10n.helpFeatureTypographyTag2,
              l10n.helpFeatureTypographyTag3,
            ],
          ),
          _AppFeature(
            title: l10n.helpFeatureAccentTitle,
            description: l10n.helpFeatureAccentBody,
            icon: Icons.color_lens_outlined,
            highlights: [
              l10n.helpFeatureAccentTag1,
              l10n.helpFeatureAccentTag2,
              l10n.helpFeatureAccentTag3,
            ],
          ),
        ],
      ),
      _FeatureCategory(
        name: l10n.labelFeaturesCategoryGuides,
        subtitle: l10n.descFeaturesCategoryGuidesSubtitle,
        icon: Icons.help_outline,
        features: [
          _AppFeature(
            title: l10n.helpFeatureGuidesTitle,
            description: l10n.helpFeatureGuidesBody,
            icon: Icons.menu_book_outlined,
            highlights: [
              l10n.helpFeatureGuidesTag1,
              l10n.helpFeatureGuidesTag2,
              l10n.helpFeatureGuidesTag3,
            ],
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
      appBar: AppBar(title: Text(l10n.titleFeatures)),
      body: SafeArea(
        top: false,
        // Built lazily: the screen lists many features (engineering standard
        // §10.3). Item 0 is the header card; each category is one item.
        child: ListView.builder(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 48),
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildHeaderCard(context, l10n, colors),
              );
            }
            final category = categories[index - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCategoryHeader(context, category, colors),
                  const SizedBox(height: 10),
                  _buildCategoryCard(context, category, colors),
                ],
              ),
            );
          },
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
    final gradient =
        colors?.brandGradient ??
        LinearGradient(
          colors: [primary, secondary],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
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
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
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
                    l10n.titleFeaturesHeader,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.descFeaturesHeaderSubtitle,
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
              Icon(category.icon, size: 18, color: primary),
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
                  style: TextStyle(color: muted, fontSize: 13, height: 1.35),
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
