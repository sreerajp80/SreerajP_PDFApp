import 'package:flutter/widgets.dart';
import 'package:pdfapp/core/logging/app_logger.dart';

/// Observes app lifecycle events — engineering standard §9.
///
/// Registered in the `main()` init sequence. Phase 0 only logs transitions and
/// clears the image cache on memory pressure; later phases hook in flush-on-pause,
/// looping-animation pause, and (if ever needed) screen-obscure behavior.
class AppLifecycleService with WidgetsBindingObserver {
  bool _registered = false;

  void init() {
    if (_registered) return;
    WidgetsBinding.instance.addObserver(this);
    _registered = true;
  }

  void dispose() {
    if (!_registered) return;
    WidgetsBinding.instance.removeObserver(this);
    _registered = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLogger.debug('Lifecycle: $state');
  }

  @override
  void didHaveMemoryPressure() {
    AppLogger.info('Memory pressure — clearing image cache.');
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
  }
}
