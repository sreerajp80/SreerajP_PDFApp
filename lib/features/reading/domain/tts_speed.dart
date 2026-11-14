/// The speeds the reader's speed button steps through, slowest first.
///
/// 1.0 is normal speed. The Settings slider can pick other values (0.5–2.0);
/// [nextSpeechRate] handles those too.
const List<double> ttsSpeedSteps = [0.75, 1.0, 1.25, 1.5, 2.0];

/// The speed after [current] when the speed button is tapped.
///
/// Goes to the next higher step, and wraps from the fastest back to the
/// slowest. A value between steps (from the slider) moves to the next higher
/// step, so one tap always speeds up unless already at the top.
double nextSpeechRate(double current) {
  // A small tolerance, so a saved 1.2500001 still counts as the 1.25 step.
  const epsilon = 0.001;
  for (final step in ttsSpeedSteps) {
    if (step > current + epsilon) return step;
  }
  return ttsSpeedSteps.first;
}

/// How many decimals to show for [rate]: `1×`, `1.5×`, `1.25×`.
int speechRateFractionDigits(double rate) {
  final hundredths = (rate * 100).round();
  if (hundredths % 100 == 0) return 0;
  if (hundredths % 10 == 0) return 1;
  return 2;
}
