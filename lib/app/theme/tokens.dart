import 'package:flutter/material.dart';

/// Design tokens — single source of truth for colors, spacing, radius, and motion
/// (engineering standard §6.1). Widgets reference these, never raw literals.
class AppTokens {
  const AppTokens._();

  // Brand seed color (Material 3 ColorScheme is generated from this).
  static const Color seed = Color(0xFF3D5A80);

  // Sepia reading surface (Phase 1 comfort mode; the full color-invert lives there).
  static const Color sepiaBackground = Color(0xFFF4ECD8);
  static const Color sepiaSurface = Color(0xFFEFE6CE);
  static const Color sepiaOnSurface = Color(0xFF5B4636);

  // Spacing scale (dp).
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // Corner radius.
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;

  // Motion durations (engineering standard §6.5 simplified scheme).
  static const Duration motionXs = Duration(milliseconds: 50);
  static const Duration motionSm = Duration(milliseconds: 100);
  static const Duration motionMd = Duration(milliseconds: 200);
  static const Duration motionLg = Duration(milliseconds: 300);
  static const Duration motionXl = Duration(milliseconds: 500);

  // Minimum tap target (engineering standard §7.1).
  static const double minTapTarget = 48;
}
