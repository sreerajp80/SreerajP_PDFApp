import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/features/reading/presentation/widgets/search_highlight_painter.dart';

double _lightness(Color c) => HSLColor.fromColor(c).lightness;
double _hue(Color c) => HSLColor.fromColor(c).hue;

void main() {
  group('highlightTone', () {
    test('a pale colour is darkened on a white page, keeping its hue', () {
      const pale = Color(0xFFB4C8FF); // pale blue, like a dark-theme primary
      final tone = highlightTone(pale, darkPage: false);

      expect(_lightness(tone), lessThan(_lightness(pale)));
      expect(_lightness(tone), closeTo(0.45, 0.01));
      expect(_hue(tone), closeTo(_hue(pale), 1));
    });

    test('a deep colour is lightened on a dark page, keeping its hue', () {
      const deep = Color(0xFF1A3D8F); // deep blue, like a light-theme primary
      final tone = highlightTone(deep, darkPage: true);

      expect(_lightness(tone), greaterThan(_lightness(deep)));
      expect(_lightness(tone), closeTo(0.6, 0.01));
      expect(_hue(tone), closeTo(_hue(deep), 1));
    });

    test('a colour that already stands out is left as it is', () {
      const deep = Color(0xFF1A3D8F);
      const pale = Color(0xFFB4C8FF);

      expect(highlightTone(deep, darkPage: false), deep);
      expect(highlightTone(pale, darkPage: true), pale);
    });

    test('the result is always opaque', () {
      final tone = highlightTone(
        const Color(0xFFB4C8FF).withValues(alpha: 0.3),
        darkPage: false,
      );

      expect(tone.a, 1);
    });
  });

  group('invertRgb', () {
    test('flips the colour and keeps alpha', () {
      final inverted = invertRgb(const Color(0x80FF8000));

      expect(inverted.r, closeTo(0, 0.001));
      expect(inverted.g, closeTo(1 - 0x80 / 255, 0.001));
      expect(inverted.b, closeTo(1, 0.001));
      expect(inverted.a, closeTo(0x80 / 255, 0.001));
    });

    test('inverting twice gives back the same colour', () {
      const c = Color(0xFF3366CC);

      final back = invertRgb(invertRgb(c));

      expect(back.r, closeTo(c.r, 1e-9));
      expect(back.g, closeTo(c.g, 1e-9));
      expect(back.b, closeTo(c.b, 1e-9));
      expect(back.a, closeTo(c.a, 1e-9));
    });
  });
}
