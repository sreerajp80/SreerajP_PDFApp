import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// What the user chose in the "My signatures" sheet.
sealed class SignFlowChoice {
  const SignFlowChoice();
}

/// Use a saved signature.
final class UseSavedSignature extends SignFlowChoice {
  const UseSavedSignature(this.signature);

  final LoadedSignature signature;
}

/// Draw a new signature on the pad.
final class DrawNewSignature extends SignFlowChoice {
  const DrawNewSignature();
}

/// Import a picture of a signature.
final class ImportSignatureImage extends SignFlowChoice {
  const ImportSignatureImage();
}

/// The "My signatures" bottom sheet: saved signatures to pick from, plus
/// **Draw new** and **Import image**. Pops with a [SignFlowChoice], or null.
class MySignaturesSheet extends ConsumerWidget {
  const MySignaturesSheet({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    LoadedSignature item,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.titleDeleteSignature),
        content: Text(l10n.bodyDeleteSignature),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(mySignaturesProvider.notifier).remove(item.signature);
    } catch (e, st) {
      AppLogger.error('my_signatures: delete failed', error: e, stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.errorOpFailed)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final saved = ref.watch(mySignaturesProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.titleMySignatures, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.descSignNotDigital,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () =>
                      Navigator.of(context).pop(const DrawNewSignature()),
                  icon: const Icon(Icons.draw_outlined),
                  label: Text(l10n.actionDrawSignature),
                ),
                FilledButton.tonalIcon(
                  onPressed: () =>
                      Navigator.of(context).pop(const ImportSignatureImage()),
                  icon: const Icon(Icons.image_outlined),
                  label: Text(l10n.actionImportSignature),
                ),
              ],
            ),
            const SizedBox(height: 16),
            saved.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => Text(l10n.errorOpFailed),
              data: (items) => items.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        l10n.emptyMySignatures,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final item in items)
                          _SignatureTile(
                            item: item,
                            onUse: () =>
                                Navigator.of(context)
                                    .pop(UseSavedSignature(item)),
                            onDelete: () => _confirmDelete(context, ref, item),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignatureTile extends StatelessWidget {
  const _SignatureTile({
    required this.item,
    required this.onUse,
    required this.onDelete,
  });

  final LoadedSignature item;
  final VoidCallback onUse;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 150,
      height: 84,
      child: Stack(
        children: [
          Positioned.fill(
            child: Material(
              // White paper: the inks are dark, in light and dark mode alike.
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: scheme.outlineVariant),
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onUse,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 30, 8),
                  child: Image.memory(
                    item.png,
                    fit: BoxFit.contain,
                    semanticLabel: l10n.descSavedSignature,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black54),
              iconSize: 20,
              tooltip: l10n.tooltipDeleteSignature,
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
