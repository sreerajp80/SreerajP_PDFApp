import 'package:flutter/widgets.dart';

/// Lets the app rebuild itself from scratch without leaving the process.
///
/// Used after "Delete all data": giving [child] a new key throws away the
/// whole provider container and every screen state, so nothing deleted from
/// storage survives in memory. Startup infrastructure (database connection,
/// preferences instance) is reused; only its contents were cleared.
class AppRestartScope extends StatefulWidget {
  const AppRestartScope({super.key, required this.child});

  final Widget child;

  /// Rebuilds the app below the nearest [AppRestartScope].
  static void restart(BuildContext context) =>
      context.findAncestorStateOfType<_AppRestartScopeState>()?._restart();

  @override
  State<AppRestartScope> createState() => _AppRestartScopeState();
}

class _AppRestartScopeState extends State<AppRestartScope> {
  Key _key = UniqueKey();

  void _restart() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: _key, child: widget.child);
}
