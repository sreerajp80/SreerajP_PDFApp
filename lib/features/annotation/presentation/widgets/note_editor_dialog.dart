import 'package:flutter/material.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Result of the note editor: the new text, and whether the note was deleted.
class NoteEditorResult {
  const NoteEditorResult({required this.text, this.deleted = false});

  final String text;
  final bool deleted;
}

/// A small dialog to write or edit a sticky note's text.
///
/// Returns a [NoteEditorResult], or null if the user cancelled. An empty text
/// on a brand-new note is treated as a cancel by the caller.
Future<NoteEditorResult?> showNoteEditor(
  BuildContext context, {
  String initialText = '',
  bool isExisting = false,
}) {
  final controller = TextEditingController(text: initialText);
  final l10n = AppLocalizations.of(context);
  return showDialog<NoteEditorResult>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.noteTitle),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 5,
        minLines: 3,
        decoration: InputDecoration(
          hintText: l10n.noteHint,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        if (isExisting)
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(const NoteEditorResult(text: '', deleted: true)),
            child: Text(l10n.deleteAction),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(NoteEditorResult(text: controller.text.trim())),
          child: Text(l10n.saveAction),
        ),
      ],
    ),
  );
}
