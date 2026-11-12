import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Fails when an icon-only control on screen has no tooltip (engineering
/// standard §7.8). Call it after pumping a screen, in every declared locale.
void expectAllIconButtonsHaveTooltips(WidgetTester tester) {
  for (final button in tester.widgetList<IconButton>(find.byType(IconButton))) {
    expect(
      button.tooltip != null && button.tooltip!.trim().isNotEmpty,
      isTrue,
      reason: 'IconButton with icon ${button.icon} has no tooltip',
    );
  }
  for (final fab in tester.widgetList<FloatingActionButton>(
    find.byType(FloatingActionButton),
  )) {
    // An extended FAB shows a text label, so it needs no tooltip.
    if (fab.isExtended) continue;
    expect(
      fab.tooltip?.trim().isNotEmpty ?? false,
      isTrue,
      reason: 'FloatingActionButton has no tooltip',
    );
  }
  for (final menu in tester.widgetList<PopupMenuButton<Object?>>(
    find.byWidgetPredicate((w) => w is PopupMenuButton),
  )) {
    expect(
      menu.tooltip?.trim().isNotEmpty ?? false,
      isTrue,
      reason: 'PopupMenuButton has no tooltip',
    );
  }
}
