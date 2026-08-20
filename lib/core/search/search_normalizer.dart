import 'package:characters/characters.dart';
import 'package:pdfapp/core/search/indic_phonetic_engine.dart';
import 'package:pdfapp/core/search/sandhi_engine.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

/// How search compares text.
class SearchOptions {
  const SearchOptions({
    this.strict = false,
    this.ignoreAccents = false,
    this.sandhi = true,
    this.phonetic = true,
  });

  /// Keep ZWJ / ZWNJ significant, and keep the two chillu spellings apart.
  ///
  /// For readers who must tell a joiner spelling from a non-joiner one. Off by
  /// default, because normally a reader should not have to type an invisible
  /// character to find a word.
  final bool strict;

  /// Fold away Devanagari and Vedic accent marks (Sanskrit chant accents), so a
  /// query without accents still finds accented text.
  final bool ignoreAccents;

  /// Enable Sandhi compound awareness (joining and splitting rules) for
  /// Malayalam and Sanskrit.
  final bool sandhi;

  /// Enable phonetic sound-alike rules (anusvara/nasals, chillu/virama variants,
  /// repha gemination, avagraha-ignorable).
  final bool phonetic;

  /// The plain default: joiners ignorable, accents significant, Sandhi & phonetic on.
  static const SearchOptions normal = SearchOptions();

  SearchOptions copyWith({
    bool? strict,
    bool? ignoreAccents,
    bool? sandhi,
    bool? phonetic,
  }) {
    return SearchOptions(
      strict: strict ?? this.strict,
      ignoreAccents: ignoreAccents ?? this.ignoreAccents,
      sandhi: sandhi ?? this.sandhi,
      phonetic: phonetic ?? this.phonetic,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchOptions &&
          runtimeType == other.runtimeType &&
          strict == other.strict &&
          ignoreAccents == other.ignoreAccents &&
          sandhi == other.sandhi &&
          phonetic == other.phonetic;

  @override
  int get hashCode => Object.hash(strict, ignoreAccents, sandhi, phonetic);
}

/// Where one grapheme cluster sits in both the comparison key and the original
/// text.
///
/// Key ranges are contiguous across the kept clusters, so a match found in the
/// key can be walked back to exact character positions in the original text —
/// and from there to pdfium's per-character rectangles.
class ClusterSpan {
  const ClusterSpan({
    required this.keyStart,
    required this.keyEnd,
    required this.sourceStart,
    required this.sourceEnd,
  });

  /// Range in [NormalizedText.key] (UTF-16 code units).
  final int keyStart;
  final int keyEnd;

  /// Range in the original, untouched text (UTF-16 code units).
  final int sourceStart;
  final int sourceEnd;
}

/// A match, reported in positions of the *original* text.
class TextMatch implements Comparable<TextMatch> {
  const TextMatch({
    required this.sourceStart,
    required this.sourceEnd,
    required this.clusterStart,
    required this.clusterEnd,
  });

  /// Range in the original text — what gets highlighted.
  final int sourceStart;
  final int sourceEnd;

  /// Range in [NormalizedText.clusters] (inclusive start, exclusive end).
  final int clusterStart;
  final int clusterEnd;

  @override
  int compareTo(TextMatch other) {
    final cmp = sourceStart.compareTo(other.sourceStart);
    if (cmp != 0) return cmp;
    return sourceEnd.compareTo(other.sourceEnd);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextMatch &&
          sourceStart == other.sourceStart &&
          sourceEnd == other.sourceEnd;

  @override
  int get hashCode => Object.hash(sourceStart, sourceEnd);
}

/// Text plus its throwaway comparison key and the map between them.
class NormalizedText {
  const NormalizedText({required this.key, required this.clusters});

  /// The folded key. Never shown to anyone — comparison only.
  final String key;

  /// One entry per kept grapheme cluster, in reading order.
  final List<ClusterSpan> clusters;

  static const NormalizedText empty = NormalizedText(key: '', clusters: []);

  /// Finds every non-overlapping occurrence of [queryKey] in [key].
  List<TextMatch> findAll(String queryKey) {
    if (queryKey.isEmpty || clusters.isEmpty) return const [];

    final matches = <TextMatch>[];
    var startPos = 0;
    while (true) {
      final matchStart = key.indexOf(queryKey, startPos);
      if (matchStart == -1) break;
      final matchEnd = matchStart + queryKey.length;

      // The matchEnd MUST align exactly with a cluster boundary.
      int? endClusterIndex;
      for (var idx = 0; idx < clusters.length; idx++) {
        if (clusters[idx].keyEnd == matchEnd) {
          endClusterIndex = idx;
          break;
        }
      }

      if (endClusterIndex == null) {
        // Ends mid-cluster — not a real match (e.g. slices a vowel sign).
        startPos = matchStart + 1;
        continue;
      }

      // Find the cluster containing matchStart.
      int? startClusterIndex;
      for (var idx = 0; idx <= endClusterIndex; idx++) {
        if (clusters[idx].keyStart <= matchStart &&
            matchStart < clusters[idx].keyEnd) {
          startClusterIndex = idx;
          break;
        }
      }

      if (startClusterIndex != null) {
        matches.add(
          TextMatch(
            sourceStart: clusters[startClusterIndex].sourceStart,
            sourceEnd: clusters[endClusterIndex].sourceEnd,
            clusterStart: startClusterIndex,
            clusterEnd: endClusterIndex + 1,
          ),
        );
        startPos = clusters[endClusterIndex].keyEnd;
      } else {
        startPos = matchStart + 1;
      }
    }
    return matches;
  }

  /// Finds all non-overlapping occurrences across multiple [queryKeys],
  /// deduplicated and sorted by source position in reading order.
  List<TextMatch> findAllKeys(Iterable<String> queryKeys) {
    if (queryKeys.isEmpty || clusters.isEmpty) return const [];

    final allMatches = <TextMatch>[];
    for (final qKey in queryKeys) {
      if (qKey.trim().isEmpty) continue;
      allMatches.addAll(findAll(qKey));
    }

    if (allMatches.isEmpty) return const [];

    // Sort in ascending reading order
    allMatches.sort();

    // Deduplicate and remove overlapping hits
    final nonOverlapping = <TextMatch>[];
    for (final match in allMatches) {
      if (nonOverlapping.isEmpty) {
        nonOverlapping.add(match);
        continue;
      }
      final last = nonOverlapping.last;
      // If this match overlaps with the last accepted match, skip it
      if (match.sourceStart < last.sourceEnd) {
        continue;
      }
      nonOverlapping.add(match);
    }
    return nonOverlapping;
  }
}

/// Builds a canonical comparison key so the same word matches however it was
/// typed or stored.
class SearchNormalizer {
  const SearchNormalizer([this.options = SearchOptions.normal]);

  final SearchOptions options;

  static const int _zwnj = 0x200C;
  static const int _zwj = 0x200D;
  static const int _malayalamVirama = 0x0D4D;

  static final String _zwnjChar = String.fromCharCode(_zwnj);
  static final String _zwjChar = String.fromCharCode(_zwj);

  static const SandhiEngine _sandhiEngine = SandhiEngine();
  static const IndicPhoneticEngine _phoneticEngine = IndicPhoneticEngine();

  /// Malayalam consonants that have an atomic chillu form.
  static const Map<int, int> _chillu = {
    0x0D23: 0x0D7A, // ണ -> ൺ
    0x0D28: 0x0D7B, // ന -> ൻ
    0x0D30: 0x0D7C, // ര -> ർ
    0x0D32: 0x0D7D, // ല -> ൽ
    0x0D33: 0x0D7E, // ള -> ൾ
    0x0D15: 0x0D7F, // ക -> ൿ
  };

  /// Builds the key for [text] and the map back to it.
  NormalizedText normalize(String text) {
    if (text.isEmpty) return NormalizedText.empty;

    final buffer = StringBuffer();
    final spans = <ClusterSpan>[];
    var source = 0;

    for (final cluster in text.characters) {
      final sourceStart = source;
      source += cluster.length;

      final folded = _fold(cluster);
      if (folded.isEmpty) continue;

      final keyStart = buffer.length;
      buffer.write(folded);
      spans.add(
        ClusterSpan(
          keyStart: keyStart,
          keyEnd: keyStart + folded.length,
          sourceStart: sourceStart,
          sourceEnd: source,
        ),
      );
    }
    return NormalizedText(key: buffer.toString(), clusters: spans);
  }

  /// The primary key for a query.
  String queryKey(String query) => normalize(query).key;

  /// Generates all candidate query keys considering Sandhi joining rules and
  /// phonetic variations.
  Set<String> candidateQueryKeys(String query) {
    final rawKey = queryKey(query);
    if (rawKey.trim().isEmpty) return const {};

    final keys = <String>{rawKey};

    // If strict mode is active, only the exact normalized key is searched.
    if (options.strict) return keys;

    // 1. Sandhi Compound Query Expansion
    if (options.sandhi) {
      final words = query
          .trim()
          .split(RegExp(r'\s+'))
          .where((w) => w.isNotEmpty)
          .toList();
      if (words.length > 1) {
        final compounds = _sandhiEngine.generateCompoundQueries(words);
        for (final comp in compounds) {
          final compKey = queryKey(comp);
          if (compKey.isNotEmpty) keys.add(compKey);
        }
      }
    }

    // 2. Indic Phonetic Variations
    if (options.phonetic) {
      final phoneticVariants = <String>{};
      for (final k in keys) {
        final f = _phoneticEngine.phoneticFold(k);
        if (f.isNotEmpty) phoneticVariants.add(f);

        // Generate Anusvara / Class nasal alternates
        _addNasalVariants(k, phoneticVariants);
        // Generate Chillu / Virama alternates
        _addChilluViramaVariants(k, phoneticVariants);
        // Generate Samvruthokaram variants (് vs ു vs ു്)
        _addSamvruthokaramVariants(k, phoneticVariants);
        // Generate Avagraha variants
        _addAvagrahaVariants(k, phoneticVariants);
        // Generate Visarga variants (e.g. root without visarga matching nominative with visarga)
        _addVisargaVariants(k, phoneticVariants);
      }
      for (final variant in phoneticVariants) {
        final vKey = queryKey(variant);
        if (vKey.isNotEmpty) keys.add(vKey);
      }
    }

    return keys;
  }

  static void _addVisargaVariants(String text, Set<String> out) {
    if (text.endsWith('ഃ')) {
      out.add(text.substring(0, text.length - 1));
    } else if (text.endsWith('ः')) {
      out.add(text.substring(0, text.length - 1));
    } else {
      out.add('$textഃ');
      out.add('$textः');
    }
  }

  static void _addNasalVariants(String text, Set<String> out) {
    // Malayalam Anusvara to class nasals & vice versa
    if (text.contains('ം')) {
      out.add(
        text
            .replaceAll('ംഗ', 'ങ്ഗ')
            .replaceAll('ംക', 'ങ്ക')
            .replaceAll('ംച', 'ഞ്ച')
            .replaceAll('ംത', 'ന്ത')
            .replaceAll('ംപ', 'മ്പ'),
      );
    }
    if (text.contains('ങ്ഗ')) out.add(text.replaceAll('ങ്ഗ', 'ംഗ'));
    if (text.contains('ങ്ക')) out.add(text.replaceAll('ങ്ക', 'ംക'));
    if (text.contains('ഞ്ച')) out.add(text.replaceAll('ഞ്ച', 'ംച'));
    if (text.contains('ന്ത')) out.add(text.replaceAll('ന്ത', 'ംത'));
    if (text.contains('മ്പ')) out.add(text.replaceAll('മ്പ', 'ംപ'));

    // Devanagari Anusvara to class nasals & vice versa
    if (text.contains('ं')) {
      out.add(
        text
            .replaceAll('ंग', 'ङ्ग')
            .replaceAll('ंक', 'ङ्क')
            .replaceAll('ंच', 'ञ्च')
            .replaceAll('ंत', 'न्त')
            .replaceAll('ंप', 'म्प')
            .replaceAll('ंड', 'ण्ड'),
      );
    }
    if (text.contains('ङ्ग')) out.add(text.replaceAll('ङ्ग', 'ंग'));
    if (text.contains('ङ्क')) out.add(text.replaceAll('ङ्क', 'ंक'));
    if (text.contains('ञ्च')) out.add(text.replaceAll('ञ्च', 'ंच'));
    if (text.contains('न्त')) out.add(text.replaceAll('न्त', 'ंत'));
    if (text.contains('म्प')) out.add(text.replaceAll('म्प', 'ंप'));
    if (text.contains('ण्ड')) out.add(text.replaceAll('ण्ड', 'ंड'));
  }

  static void _addChilluViramaVariants(String text, Set<String> out) {
    if (text.contains('ർ')) out.add(text.replaceAll('ർ', 'ര്'));
    if (text.contains('ര്')) out.add(text.replaceAll('ര്', 'ർ'));
    if (text.contains('ൻ')) out.add(text.replaceAll('ൻ', 'ന്'));
    if (text.contains('ന്')) out.add(text.replaceAll('ന്', 'ൻ'));
    if (text.contains('ൽ')) out.add(text.replaceAll('ൽ', 'ല്'));
    if (text.contains('ല്')) out.add(text.replaceAll('ല്', 'ൽ'));
    if (text.contains('ൾ')) out.add(text.replaceAll('ൾ', 'ള്'));
    if (text.contains('ള്')) out.add(text.replaceAll('ള്', 'ൾ'));
    if (text.contains('ൺ')) out.add(text.replaceAll('ൺ', 'ണ്'));
    if (text.contains('ണ്')) out.add(text.replaceAll('ണ്', 'ൺ'));
    if (text.contains('ൿ')) out.add(text.replaceAll('ൿ', 'ക്'));
    if (text.contains('ക്')) out.add(text.replaceAll('ക്', 'ൿ'));

    // NTA ligature variations
    if (text.contains('ന്റ')) {
      out.add(text.replaceAll('ന്റ', 'ൻറ'));
      out.add(text.replaceAll('ന്റ', 'ൻറ്റ'));
    }
    if (text.contains('ൻറ')) {
      out.add(text.replaceAll('ൻറ', 'ന്റ'));
    }
  }

  static void _addSamvruthokaramVariants(String text, Set<String> out) {
    if (text.endsWith('്')) {
      out.add('${text.substring(0, text.length - 1)}ു');
      out.add('${text.substring(0, text.length - 1)}ു്');
    } else if (text.endsWith('ു്')) {
      out.add('${text.substring(0, text.length - 2)}്');
      out.add('${text.substring(0, text.length - 2)}ു');
    }
  }

  static void _addAvagrahaVariants(String text, Set<String> out) {
    if (text.contains('ഽ')) out.add(text.replaceAll('ഽ', ''));
    if (text.contains('ऽ')) out.add(text.replaceAll('ऽ', ''));
  }

  /// Folds one grapheme cluster into its comparison form.
  String _fold(String cluster) {
    if (_isBlank(cluster)) return ' ';

    var text = _isAscii(cluster) ? cluster : unorm.nfc(cluster);

    if (!options.strict) {
      text = _unifyChillu(text);
      text = _stripJoiners(text);
    }
    if (options.ignoreAccents) text = _stripAccents(text);

    return text.toLowerCase();
  }

  static bool _isBlank(String s) => s.trim().isEmpty;

  static bool _isAscii(String s) {
    for (final unit in s.codeUnits) {
      if (unit >= 0x80) return false;
    }
    return true;
  }

  /// Rewrites `consonant + virama + ZWJ` as the atomic chillu letter.
  static String _unifyChillu(String s) {
    if (!s.contains(_zwjChar)) return s;

    final runes = s.runes.toList();
    final out = <int>[];
    var i = 0;
    while (i < runes.length) {
      final atomic =
          i + 2 < runes.length &&
              runes[i + 1] == _malayalamVirama &&
              runes[i + 2] == _zwj
          ? _chillu[runes[i]]
          : null;
      if (atomic != null) {
        out.add(atomic);
        i += 3;
      } else {
        out.add(runes[i]);
        i++;
      }
    }
    return String.fromCharCodes(out);
  }

  /// Drops ZWJ / ZWNJ from the key.
  static String _stripJoiners(String s) =>
      s.replaceAll(_zwnjChar, '').replaceAll(_zwjChar, '');

  /// Drops Sanskrit / Vedic accent marks (accent-insensitive mode only).
  static String _stripAccents(String s) {
    final out = <int>[];
    for (final rune in s.runes) {
      if (!_isAccentMark(rune)) out.add(rune);
    }
    return String.fromCharCodes(out);
  }

  static bool _isAccentMark(int r) =>
      (r >= 0x0951 && r <= 0x0954) ||
      (r >= 0xA8E0 && r <= 0xA8F1) ||
      (r >= 0x1CD0 && r <= 0x1CE8) ||
      r == 0x1CED ||
      r == 0x1CF4 ||
      r == 0x1CF8 ||
      r == 0x1CF9;
}
