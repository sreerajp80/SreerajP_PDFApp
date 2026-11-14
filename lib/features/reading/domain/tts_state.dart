/// A language this app can read aloud.
enum TtsLanguage {
  english('en-US'),

  /// Malayalam. Off unless the reader turns it on in Settings, because the
  /// voice is an extra download on most phones.
  malayalam('ml-IN');

  const TtsLanguage(this.code);

  /// The BCP-47 tag handed to the Android speech engine.
  final String code;
}

/// Whether a language can actually be spoken right now.
///
/// This is the heart of the "never a dead button" rule: reader screens ask for
/// this and show the real answer, instead of offering a control that silently
/// does nothing.
enum TtsVoiceState {
  /// Not looked at yet.
  unknown,

  /// The voice is installed and ready.
  ready,

  /// The engine knows this language but the voice data is not downloaded. We
  /// can offer to install it.
  needsInstall,

  /// No speech engine on this device supports the language at all. Installing
  /// would not help, so we say so plainly rather than sending the reader on a
  /// wild goose chase.
  unavailable,
}

/// Why a page cannot be read aloud, checked before reading starts.
///
/// The app never falls back to another language's voice: an English voice
/// mangles Malayalam or Sanskrit, so the reader is told instead.
enum TtsVoiceProblem {
  /// A ready voice exists for the page's language.
  none,

  /// Malayalam text; the voice is installed but switched off in Settings.
  malayalamOff,

  /// Malayalam text; the voice is not installed (or not supported).
  malayalamNotInstalled,

  /// Devanagari (Sanskrit) text; the app has no Sanskrit voice.
  noSanskritVoice,

  /// Other text, and no English voice is ready.
  noVoice,
}

/// What the reader-aloud is doing.
enum TtsPlaybackState { idle, speaking, paused }

/// Everything a reader screen needs to draw its read-aloud controls.
class TtsStatus {
  const TtsStatus({
    this.playback = TtsPlaybackState.idle,
    this.english = TtsVoiceState.unknown,
    this.malayalam = TtsVoiceState.unknown,
    this.malayalamEnabled = false,
    this.speakingPage,
  });

  final TtsPlaybackState playback;
  final TtsVoiceState english;

  /// The Malayalam voice's state, whether or not the reader has enabled it.
  final TtsVoiceState malayalam;

  /// The Settings toggle. Malayalam text is only spoken when this is on *and*
  /// the voice is [TtsVoiceState.ready].
  final bool malayalamEnabled;

  /// The page being read aloud, if any.
  final int? speakingPage;

  bool get isSpeaking => playback == TtsPlaybackState.speaking;
  bool get isPaused => playback == TtsPlaybackState.paused;
  bool get isIdle => playback == TtsPlaybackState.idle;

  /// Whether Malayalam will really be used: switched on *and* installed.
  bool get malayalamUsable =>
      malayalamEnabled && malayalam == TtsVoiceState.ready;

  /// True when nothing can be read aloud at all, so the controls must say so.
  bool get canSpeak =>
      english == TtsVoiceState.ready || malayalam == TtsVoiceState.ready;

  TtsStatus copyWith({
    TtsPlaybackState? playback,
    TtsVoiceState? english,
    TtsVoiceState? malayalam,
    bool? malayalamEnabled,
    int? speakingPage,
    bool clearSpeakingPage = false,
  }) => TtsStatus(
    playback: playback ?? this.playback,
    english: english ?? this.english,
    malayalam: malayalam ?? this.malayalam,
    malayalamEnabled: malayalamEnabled ?? this.malayalamEnabled,
    speakingPage: clearSpeakingPage
        ? null
        : (speakingPage ?? this.speakingPage),
  );
}

/// One page's text, handed to the reader-aloud when it moves on to the next
/// page of a document.
class TtsPageText {
  const TtsPageText({required this.page, required this.text});

  /// The 1-based page number.
  final int page;
  final String text;
}

/// Gives the next page to read after [finishedPage], or null at the end of the
/// document. Pages with nothing to read should be skipped by the caller.
typedef TtsNextPage = Future<TtsPageText?> Function(int finishedPage);
