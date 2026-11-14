/// The longest piece handed to the speech engine at once, in UTF-16 units.
///
/// A new speed, Pause and Stop all act between pieces, so short pieces keep
/// the controls quick. About 200 characters is a few seconds of speech.
const int maxSpeechPieceLength = 200;

/// The limit for Malayalam text. A Malayalam syllable takes several UTF-16
/// units (consonant, virama, vowel signs), so 200 units was about 15 s of
/// speech at 0.75× and a new speed took that long to be heard.
const int maxMalayalamSpeechPieceLength = 100;

/// Cuts page text into short pieces for reading aloud.
///
/// Line breaks become spaces first, so a line wrap in the middle of a sentence
/// does not add a pause. Then the text is cut after a sentence mark (`.` `!`
/// `?` `।` `॥` `|`) that is followed by a space. Any piece still longer than
/// [maxLength] — verse text often has no marks at all — is cut at the last
/// space before the limit, or hard-cut when there is no space.
List<String> splitForSpeech(
  String text, {
  int maxLength = maxSpeechPieceLength,
}) {
  final flat = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (flat.isEmpty) return <String>[];

  final pieces = <String>[];
  for (final sentence in flat.split(RegExp(r'(?<=[.!?।॥|]) '))) {
    var rest = sentence.trim();
    while (rest.length > maxLength) {
      var cut = rest.lastIndexOf(' ', maxLength);
      if (cut <= 0) {
        cut = maxLength;
        // Never split a surrogate pair.
        if (_isLowSurrogate(rest.codeUnitAt(cut))) cut--;
      }
      pieces.add(rest.substring(0, cut).trim());
      rest = rest.substring(cut).trim();
    }
    if (rest.isNotEmpty) pieces.add(rest);
  }
  return pieces;
}

bool _isLowSurrogate(int unit) => unit >= 0xDC00 && unit <= 0xDFFF;
